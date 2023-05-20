#!/usr/bin/env ruby

# markdown -> html

#require 'i7/template'
#require 'redcarpet'
require 'kramdown'
require 'kramdown-parser-gfm'
require 'ostruct'
require 'htmlentities'


Conf = OpenStruct.new
Conf.tmpl = 'i7/tmpl'

require 'charlock_holmes'
require 'i18n'
I18n.config.available_locales = :en

class String
  def to_utf8
    x = self.dup
    detection = CharlockHolmes::EncodingDetector.detect(x)
    CharlockHolmes::Converter.convert(x, detection[:encoding], 'UTF-8')
  end
end

#
#   module Converter
#     attr_reader :result
#     class Base
#       def self.converter(doc, options = {})
#         tree = doc.root
#         converter = new(tree, ::Kramdown::Options.merge(options.merge(tree.options[:options] || {})))
#         if !converter.options[:template].empty? && converter.apply_template_before?
#           apply_template(converter, '')
#         end
#         @result = converter.convert(tree)
#         converter
#       end
#     end

#   end
module Kramdown
  class Converter::Html5 < Converter::Html

    def initialize(root, options)
      super(root, options)
    end

#
#    
    # def convert_root(el, indent)
    #   result = inner(el, indent)
    #   if @footnote_location
    #     result.sub!(/#{@footnote_location}/, footnote_content.gsub(/\\/, "\\\\\\\\"))
    #   else
    #     result << footnote_content
    #   end
    #   if @toc_code
    #     toc_tree = (@toc_tree ||= generate_toc_tree(@toc, @toc_code[0], @toc_code[1] || {}))
    #     text = if !toc_tree.children.empty?
    #              convert(toc_tree, 0)
    #            else
    #              ''
    #            end
    #     result.sub!(/#{@toc_code.last}/, text.gsub(/\\/, "\\\\\\\\"))
    #   end
    #   result
    # end
    
    def convert_codeblock(el, indent)

      attr = el.attr.dup
      lines = el.value.split("\n")
      copycode = lines.map {|cl| $html_ent.encode(cl.sub(/\t/,"\\t")) }.join("\\n")
      result = []
      result << %Q{<div class="codeblock"><button class="copycode" title="Copy to clipboard" onclick="copyCode(`#{copycode}`)"><span class="sym">⧉</span></button>}
      lines.each do |cl|
        if cl.empty?
          result << %Q{<div class="codeline">&thinsp;</div>}
          next
        end
        tabs, remainder = cl.match(/\A(\t+)?(.*)\Z/).captures
        indent = (tabs ? tabs.length : 0) * 3
        result << %Q{<div class="codeline">#{('&ensp;' * indent) + $html_ent.encode(remainder)}</div>}
      end
      result << "</div>"
      result.join("\n")
    end

    attr_reader :toc
    
      def generate_multi_toc_tree(toc, type, attr)
        sections = Element.new(type, nil, attr.dup)
        sections.attr['id'] ||= 'markdown-toc'
        stack = []
        toc.each do |level, id, children|
          li = Element.new(:li, nil, nil, level: level)
          li.children << Element.new(:p, nil, nil, transparent: true)
          a = Element.new(:a, nil)
          a.attr['href'] = "##{id}"
          a.attr['id'] = "#{sections.attr['id']}-#{id}"
          a.children.concat(fix_for_toc_entry(Marshal.load(Marshal.dump(children))))
          li.children.last.children << a
          li.children << Element.new(type)

          success = false
          until success
            if stack.empty?
              sections.children << li
              stack << li
              success = true
            elsif stack.last.options[:level] < li.options[:level]
              stack.last.children.last.children << li
              stack << li
              success = true
            else
              item = stack.pop
              item.children.pop if item.children.last.children.empty?
            end
          end
        end
        until stack.empty?
          item = stack.pop
          item.children.pop if item.children.last.children.empty?
        end
        sections
      end


    
  end
end

$html_ent = HTMLEntities.new  

$toc = {}


def md_to_html(filename)
  basename = File.basename(filename, '.md')
#  $toc[basename] = {}
  output_filename = File.join("docs/i7handbook", basename + '.html')
  markdown_source = File.read(filename, encoding: "UTF-8")
  options = { input: 'GFM', hard_wrap: false, parse_block_html: true, template: "tmpl/i7h.erb", toc_levels: 1..4, auto_ids: true }
  doc = Kramdown::Document.new(markdown_source, input: 'GFM', hard_wrap: false, parse_block_html: true, template: "tmpl/i7h.erb", toc_levels: 1..4, auto_ids: true)
 converter = Kramdown::Converter::Html5.send(:new, doc.root, ::Kramdown::Options.merge(options.merge(doc.root.options[:options] || {})))
 result = converter.convert(doc.root, 0)
# pp converter.toc
# pp doc.root
#  line = converter.toc[0]
#  puts line.map(&:to_s).join(' ')
$toc[basename] = converter
#html = doc.to_html5()
#File.open(output_filename, 'w', encoding: 'UTF-8') {|f| f.puts(html)}
end



if !ARGV.empty?
  md_to_html(ARGV.shift)
else
  Dir['*.md'].each do |filename|
    md_to_html(filename)
  end  
end
master_toc = {}
$toc.each do |k,v|
  puts k
  v.toc.each do |entry|
    pp entry
    pp entry.last.first.class
    puts v.convert_a(entry.last.first.class, 0)
  end
end
