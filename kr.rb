#!/usr/bin/env ruby

# generic html -> markdown, doesn't handle codeblocks

#require 'i7/template'
#require 'redcarpet'
require 'kramdown'
require 'kramdown-parser-gfm'
require 'ostruct'
require 'htmlentities'

filename = ARGV.shift
dirname = File.dirname(filename)
basename = File.basename(filename, '.html')
#output_filename = File.join(dirname, basename + '.html.md')

module Kramdown

  module Utils

    # Provides convenience methods for HTML related tasks.
    #
    # *Note* that this module has to be mixed into a class that has a @root (containing an element
    # of type :root) and an @options (containing an options hash) instance variable so that some of
    # the methods can work correctly.
    module Html

      # Convert the entity +e+ to a string. The optional parameter +original+ may contain the
      # original representation of the entity.
      #
      # This method uses the option +entity_output+ to determine the output form for the entity.
      def entity_to_str(e, original = nil)
        entity_output = @options[:entity_output]
        pp entity_output
        pp @root.options[:encoding]
        pp e.char.encode(@root.options[:encoding])
        if entity_output == :as_char &&
            (c = e.char.encode(@root.options[:encoding]) rescue nil) &&
           ((c = e.char) == '"' || !ESCAPE_MAP.key?(c))
          pp e.char

          c
        elsif (entity_output == :as_input || entity_output == :as_char) && original
          original
        elsif (entity_output == :symbolic || ESCAPE_MAP.key?(e.char)) && !e.name.nil?
          "&#{e.name};"
        else # default to :numeric
          "&##{e.code_point};"
        end
      end

    end
  end
end


module Kramdown
  class Converter::Kramdown5 < Converter::Kramdown

    def convert_codeblock(el, indent)
      content = el.value.sub(/\A\s*/,'').sub(/\s*\Z/,'')
      "```\n" + content + "\n```\n"
    end

      def convert_blockquote(el, opts)
        opts[:indent] += 2
#        pp inner(el, opts)
        inner(el, opts).split(/\n/).map(&:strip).map {|l| "> #{l}" }.join(" \\\n").sub(/\\\Z/,'') + "\n"
#        inner(el, opts).chomp.split(/<br>\n/).map {|l| "> #{l}" }.join("\n") << "\n"
      end

      def convert_entity(el, _opts)
        return el.value.char if [ '<', '>', '&' ].member?(el.value.char)
        x = entity_to_str(el.value, el.options[:original])
        pp x
        x
      end

      # def convert_a(el, opts)
      #   if el.attr['href'].empty?
      #     "[#{inner(el, opts)}]()"
      #   elsif el.attr['href'] =~ /^(?:http|ftp)/ || el.attr['href'].count("()") > 0
      #     index = if (link_el = @linkrefs.find {|c| c.attr['href'] == el.attr['href'] })
      #               @linkrefs.index(link_el) + 1
      #             else
      #               @linkrefs << el
      #               @linkrefs.size
      #             end
      #     "[#{inner(el, opts)}][#{index}]"
      #   else
      #     title = parse_title(el.attr['title'])
      #     "[#{inner(el, opts)}](#{el.attr['href']}#{title})"
      #   end
      # end

      
      def convert_a(el, opts)
        if el.attr['href'].empty?
          "[#{inner(el, opts)}]()"
        else
          title = parse_title(el.attr['title'])
          "[#{inner(el, opts)}](#{el.attr['href']}#{title})"
        end
      end
      
    
#    def convert_blockquote(el, arg2)
#      lines = el.value.split("<br>\n")
#      lines.map {|l| "> #{l}"}.join("\n")
#    end
  end
end



html_source = File.read(filename, encoding: "UTF-8")
html_source.gsub!(/\n\n\n+/,"\n\n")
doc = Kramdown::Document.new(html_source, input: 'html', entity_output: :as_char)
pp doc.toc
md = doc.to_kramdown5(entity_output: :as_char, output: 'gfm') # (output: 'gfm', entity_output: :numeric)
#html = I7::Template[:i7handbook].render(html: html_fragment)
#File.open(output_filename, 'w', encoding: 'UTF-8') {|f| f.puts(md)}
puts md
