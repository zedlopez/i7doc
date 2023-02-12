#!/usr/bin/env ruby

require 'i7/template'
#require 'redcarpet'
require 'kramdown'
require 'kramdown-parser-gfm'
require 'ostruct'
require 'htmlentities'

filename = ARGV.shift
dirname = File.dirname(filename)
basename = File.basename(filename, '.md')
output_filename = File.join(dirname, basename + '.md.html')

puts output_filename

markdown_source = File.read(filename, encoding: "UTF-8")

# class Conf
#   def self.[](x)
#     @h[x.to_sym]
#   end
#   def self.[]=(x,y)
#     @h ||= {}
#     @h[x.to_sym]=y
#   end
#   def self.method_missing(m, *args)
#     @h[m]
#   end
# end
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

module Kramdown
  class Converter::Html5 < Converter::Html

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
#      result += lines.map {|cl| %Q{<div class="codeline">#{cl.empty? ? '&thinsp;' : cl.sub(/\A(\t+)/,'&ensp;&ensp;&ensp;'*($1 ? $1.length : 0))}</div>}}
      result << "</div>"
      result.join("\n")
    end
  end
end

$html_ent = HTMLEntities.new  
html_fragment = Kramdown::Document.new(markdown_source, input: 'GFM', hard_wrap: false, parse_block_html: true).to_html5
html = I7::Template[:i7handbook].render(html: html_fragment)
File.open(output_filename, 'w', encoding: 'UTF-8') {|f| f.puts(html)}
