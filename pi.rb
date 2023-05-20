#!/usr/bin/env ruby

require 'pp'
require 'cgi'
require 'fileutils'
require 'base64'
require 'erubi'
require 'ostruct'
require 'open3'
require 'i7/template'
require 'json'
require 'charlock_holmes'
require 'i18n'
require 'yaml'
require 'humanize'
require "active_support"
require "active_support/core_ext/string/inflections"
require "active_support/core_ext/object/blank"
require 'nokogiri'

I18n.config.available_locales = :en

class UTF8 < File

  def self.convert(x)
    if x.respond_to?(:to_a)
      return x.to_a.map {|y| UTF8.convert(y) }
    elsif x.respond_to?(:to_s)
      return x.to_s.to_utf8
    end
    nil
  end

  def self.readlines(*x)
    UTF8.convert(super.join).split(%r{#{$/}})
  end

  def self.read(*x)
    UTF8.convert(super)
  end

end

class String
  def to_utf8
    x = self.dup
    detection = CharlockHolmes::EncodingDetector.detect(x)
    CharlockHolmes::Converter.convert(x, detection[:encoding], 'UTF-8')
  end
end

Conf = OpenStruct.new(YAML.load(File.read("i7doc.yml")))

# non-output
def configure
  Conf.default_inform_dir = "/home/zed/mine/inform"
  informdir = ARGV.shift || Conf.default_inform_dir
  Conf.resource_dir = File.join(informdir, 'resources')
  Conf.doc_dir = File.join(Conf.resource_dir, 'Documentation')
  Conf.example_dir = File.join(Conf.doc_dir, 'Examples')
  Conf.example_output_dir = File.join(Conf.output_dir, 'examples')
  %i{ chapter_names subnames }.each {|x| Conf[x] = Hash.new {|h,k| h[k] = {} } }
#  Conf.section_names = Hash.new {|h,k| h[k] = {} }
#  Conf.chapter_names = Hash.new {|h,k| h[k] = {} }
#  Conf.subnames = Hash.new {|h,k| h[k] = {} }
  %i{ volumes books defns omit_examples examples examples_by_num gi gi_by_tag gi_by_name index_bar documented_at see rmatch }.each {|x| Conf[x] = {} }
  Conf.table = []
  Conf.syms = { left: '⬅', right: '⮕', up: '⬆', star: '★', downright: '↴', heavyright: '➜' }
  Conf.text_subs = 
    { %r{ Click the heading of the example, or the example number, to reveal the text\.} => '',
      %r{(<strong>)?www.inform-fiction.org(</strong>)?} => %Q{<a href="https://inform-fiction.org">inform-fiction.org</a>},
      %r{(https://)?github.com/ganelson/inform} => %Q{<a href="https://github.com/ganelson/inform">github.com/ganelson/inform</a>},
      %r{<strong>github.com/ganelson/inform</strong>} => %Q{<a href="https://github.com/ganelson/inform">github.com/ganelson/inform</a>},
      %r{https?://intfiction.org/c/general/events/47} => %Q{<a href="https://intfiction.org/c/general/events/47">intfiction.org/c/general/events/47</a>},
      %r{https?://intfiction.org/(\s)} => %Q{<a href="https://intfiction.org/">intfiction.org</a>#{$1}},
      %r{<strong>(?:www\.)?intfiction.org</strong>} => %Q{<a href="https://intfiction.org/">intfiction.org</a>},
      %r{https?://inform7.com/downloads?/} => %Q{<a href="http://inform7.com/downloads/">inform7.com/downloads/</a>},
      %r{<strong>(?:www.vorbis.com|xiph.org/vorbis)</strong>} => %Q{<a href="https://xiph.org/vorbis/">xiph.org/vorbis</a>},
      %r{https?://vorple-if.com} => %Q{<a href="https://vorple-if.com/">vorple-if.com</a>},
      %r{www.csszengarden.com} => %Q{<a href="http://csszengarden.com/">csszengarden.com</a>},
      %r{https?://itch.io/jams} => %Q{<a href="https://itch.io/jams">itch.io/jams</a>},
      %r{https?://www.procjam.com/} => %Q{<a href="https://www.procjam.com/">procjam.com</a>},
      %r{https://emshort.blog/} => %Q{<a href="https://emshort.blog/">emshort.blog</a>},
      %r{(?:https?://)?ifdb(?:\.tads)?\.org/?} => %Q{<a href="https://ifdb.org">ifdb.org</a>},
      %r{https?://(?:upload|www).ifarchive.org/cgi-bin/upload.py} => %Q{<a href="https://upload.ifarchive.org/cgi-bin/upload.py">https://upload.ifarchive.org/cgi-bin/upload.py</a>},
      %r{semver.org} => %Q{<a href="https://semver.org">semver.org</a>},
      %r{https?://www.ifwiki.org/?} => %Q{<a href="https://ifwiki.org">ifwiki.org</a>},
      %r{<strong>XYZZY Awards</strong>} => %Q{<a href="https://xyzzyawards.org">XYZZY Awards</a>},
      %r{Interactive Fiction Technology Foundation} => %Q{<a href="https://iftechfoundation.org/">Interactive Fiction Technology Foundation</a>},
      %r{\s+If you are reading this within the Inform application, you will see that the (Recipe Book|Writing with Inform) pages are on &quot;(yellow|white) paper&quot;, while the (Recipe Book|manual) is on &quot;(yellow|white) paper&quot;\.} => '',
      %r{\bi6\b}i => %Q{<span class="sc">i</span>6},
      %r{\bi7\b}i => %Q{<span class="sc">i</span>7},
    }
end

def get_icon(*l)
  color, shape, icon = *l;
#  bg = Conf.doc.create_element('span', 'class' => "abs icon-bg bg-#{shape} fg-#{color}")
#  fg = Conf.doc.create_element('span', 'class' => "invert icon abs #{icon}")
  #  [ bg, fg ]
  [ Conf.doc.create_element('span', 'class' => "bg-#{shape} bg-#{color} bg-icon icon #{icon}") ]
end


#vmglulx.png
replacements = { doc: { tick: 'green-check',
                 greytick: 'gray-check',
                 cross: 'red-cross',
                 greycross: 'red-cross',
                 paste: 'joined-squares',
#                 help: 'blue-question',
                 shelp: 'blue-tooltip',
#                 Below: 'gray-down-arrow',
                 #                 Beneath: 'gray-search',
                 calc1: 'calc',
                 calc2: 'calc',
                 Revealext: 'reveal-extension', },
                 scene: { WPB: 'green-square',
                 WhenC: 'green-question',
                 Segue: 'yellow-play',
                 Simul: 'yellow-plus',
                 WNever: 'red-cross',
                 ENever: 'red-ellipsis',
                 Recurring: 'gray-clockwise-arrow', },
               }
image_dirs = { doc: 'doc_images', scene: 'scene_icons' }

Conf.rep = {}
replacements.each_pair do |image_dir, hash|
  hash.each_pair do |png, target|
    Conf.rep["inform:/#{image_dirs[image_dir]}/#{png}.png"] = target.to_s
  end
end

Conf.docfilenames = YAML.load(File.read("docfilenames.yml"))
Conf.docfilenames.each {|k,v| v.match(/(\w\w)\s+(\d+)\.(\d+)/); Conf.docfilenames[k] = "#{$1}_#{$2}.html#section_#{$3}" }
Conf.docfilenames = Hash[Conf.docfilenames.map {|k,v| ["inform:/#{k}",v] }]


def transform(div)

  div.css("table.elementbanner").each do |banner|
    para = banner.at_css('p')
    next unless para
    para.add_class('element-banner')
    para.remove_attribute('style')
    children = para.children.dup
    
    h2 = Conf.doc.create_element('h2', children.shift.content)
    h2.content = 'Options' if h2.content == 'Innards'
    h2.content = 'Outline' if h2.content == 'Contents'
    strong = Conf.doc.create_element('strong', children.shift.content.sub(/\s*—\s*/,''))
    new_div = Conf.doc.create_element('div')
    new_div << h2
    new_div << strong
    new_div << children
    banner.replace(new_div)
  end

  div.css('img[src="inform:/doc_images/extra.png"]').each do |img|
    parent_p = img.parent.parent
    new_span = Conf.doc.create_element('span', class: 'prime')
    parent_p.children.each do |child|
      next if child.name == 'a'
      child.parent = new_span
    end
    parent_p << new_span
  end
  div.css('img[src="inform:/doc_images/noextra.png"]').each do |img|
    this_para = img.parent
    prev_para = this_para.previous_element
    new_span = Conf.doc.create_element('span', class: 'alternate')
    this_para.children.each do |child|
      next if child.name == 'img'
      new_span << child
    end
    prev_para << new_span
    this_para.remove
  end
  
  div.css('img[src="inform:/doc_images/extra.png"]').each do |img|
    parent_p = img.parent.parent
    siblings = []
    sib = img.parent.next
    while !sib.nil?
      siblings << sib
      sib = sib.next
    end
    subsequent_div = parent_p.next_element
    next unless subsequent_div
    summary = Conf.doc.create_element('summary')
    if siblings[0].inner_html == "if"
      siblings[0].replace(span)
    end
    siblings.each.with_index(1) do |sib,j|
      if sib.element?
        if sib.name == 'span' and !sib.attributes['class'].blank? and sib.attributes['class'].value.match(/phrasetokendesctext/)
          puts "#{sib.content}" if sib.content.match(/>/)
          sib.content = sib.content.gsub(/->/,'➜')
        elsif sib.name == 'i'
          if sib.inner_html == "if"
            span = Conf.doc.create_element('span', 'if', 'class' => 'if')
            summary.add_child(span)
            next
          elsif j == siblings.count
            span = ((sib.content == ":") ? Conf.doc.create_element('span', ':', 'class' => 'colon') : Conf.doc.create_element('span', sib.content, 'class' => 'result'))
            summary.add_child(span)
            next
          end
        end
      elsif sib.text?
        sib.content = sib.content.sub(/\.\.\.(\s*)\Z/,"⇒ ") if sib.inner_text.match(/\.\.\.\s*\Z/)
        sib.content = sib.content.sub(/\A(\s*)[()]/,($1 ? $1 : ""))
        sib.content = sib.content.sub(/[()](\s*)\Z/,($1 ? $1 : ""))
      end
      summary.add_child(sib)
    end
    details = Conf.doc.create_element('details')
    details << summary
    #      else
    if subsequent_div.at_css('table.indexmorebox') and subsequent_div.at_css('table.indexmorebox').css('p')
      subsequent_div.at_css('table.indexmorebox').css('p').each do |p|
        details << p
      end
    else
      
      subsequent_div.children.each do |child|
        details.add_child(child)
      end
    end
    
    parent_p.replace(details)
  end

  div.xpath('//a[@name="contra"]').each do |node|
    node.children.each do |child|
      child.parent = node.parent
    end
    node.parent['id'] = 'contra'
    node.remove
  end

  div.xpath('//span[@style="white-space:nowrap"]').each do |node|
    new_div = Conf.doc.create_element('div', clss: 'no-wrap' )
    node.children.each {|c| c.parent = new_div }
    if node.next and node.next.text? and node.next.content.match(/,\s+/)
      node.next.remove
    end
    node.replace(new_div)
#    node.remove_attribute('style')
#    node.add_class('no-wrap')
  end

  
  div.css('img').each do |img|
    
    if !img.attributes['src'].blank?
      
      img.attributes['src'].value.match(%r{/([^/\.]+).png})
      name = $1
      if %w{ rulenone rulemore vm_glulx }.member?(name)
        img.remove
        next
      end
      
      if (%w{ Below Beneath help }.member?(name))
        link = img.parent
        
        
        prev = link.previous
        prev_el = link.previous_element

        if name == 'help' and prev.nil?
          prev = link.next
        end
        
        next unless prev
        if prev_el and %w{ span i }.member?(prev_el.name) and prev.text? and prev.content == "\u00A0" and name == 'Beneath'
          prev = prev_el
          if prev.name == 'span'
            if prev.previous and prev.previous.text? and prev.previous.content.match(/,\s+/)
              separator = Conf.doc.create_element('span', class: 'sep')
              prev.previous.replace(separator)
            end
          end
        end

        content = (prev.text? ? prev.content : prev.children.first.content)

        content.match(/\A[[:space:]]*([;,])?[[:space:]]*(.*?)[[:space:]]*\Z/)
        had_comma, text_content = $1, $2

        text_content.sub!(/\s+\(in red\)/,'')
        text_content.gsub!(/[[:space:]]+/,"\u00A0")

        link.content = text_content.strip
        prev.replace(link)
        if had_comma
          separator = Conf.doc.create_element('span', class: 'sep')
          link.previous = separator
        end

        link.previous = Conf.doc.create_text_node(" ") if link.previous and !link.previous.content.match(/[[:space]]\Z/)
        
        next
      end

      if (%w{ Reveal Revealext }.member?(name))
        img.parent.remove
        next
      end

      
      if Conf.rep.key?(img.attributes['src'].value)
        span = Conf.doc.create_element('span', 'class' => [ Conf.rep[img.attributes['src'].value], "icon"].join(" "))
        img.parent.add_class('borderless') if img.parent.name == 'a'
        img.replace(span)
        next
      end
      if img.attributes['src'].value.match(%r{inform:/})
        img.attributes['src'].value = img.attributes['src'].value.sub(%r{inform:/}, 'assets/')
      end
    end
  end
  div.css('td').each do |td|
    if td.attributes['background-image'] and td.attributes['background-imaage'].value.match(/url\('inform:([^']+)'/)
      td.attributes['background-image'].value = td.attributes['background-image'].value.sub(%r{inform:/},'assets')
    end
  end
  
  div.css('a').each do |a|
    if !a.attributes['href'].blank? and !a.attributes['href'].value.blank?
      if Conf.docfilenames.key?(a.attributes['href'].value)
        a.attributes['href'].value = Conf.docfilenames[a.attributes['href'].value]
      elsif a.attributes['href'].value.match(/javascript:pasteCode/)
        a.attributes['href'].value = a.attributes['href'].value.gsub(/'/,'`').gsub(/\[=0x0009=\]/,"\t").gsub(/\[=0x000A=\]/,"\n").gsub(/\[=0x0022=\]/,"&quot;").gsub(/\[=0x0027=\]/,"&apos;").gsub(/\[=0x(\X{4})=\]/,"")
      end
    end
  end
  
  div.css('details').each do |details|
    see = details.at_xpath('//p/b[starts-with(text(),"See")]')
    if see
      a = see.next
      pp see.parent unless a.next and !a.next.content.nil?
      linktext = a.next
      if linktext.content.match(/\A.*\s+(\d+\.\d+\.\s+\D.*)\Z/)
        a.inner_html = $1
        see.replace(a)
        a.next.remove
      end
    end
    details.xpath('//p[last()]/b[starts-with(text(),"Kind:")]').each do |bold|
      kind_text = bold.next
      text = Conf.doc.create_text_node(bold.next.content.gsub(/-(>|&gt;)/,'⇒'))
      kind_text.replace(text)
    end
  end
  
  div
end

def process(name, filename)
  puts name
  Conf.doc = Nokogiri::HTML(File.read(filename))
  numtotitle = {} # Hash.new {|h,k| h[k] = {} }
  segments = []
  divs = Conf.doc.at_css('body').css('div').each do |div|
    next unless div and div.attributes and div.attributes['id'] and div.attributes['id'].value.match(/\Asegment(\d+)/)
    segment_num = $1
    if elementlink = div.at_css('a.elementlink')
      numtotitle[segment_num] = elementlink.attributes['title'].value
    end
    div.add_class("project-index pi-segment #{name.downcase}")
    puts "segment: #{segment_num}"
    segment = transform(div)
    
    segments << segment
  end
  
  if name == "Contents"
    numtotitle["1"] = "Outline"
    numtotitle["5"] = "Options"
  end
  numtotitle["3"] = "Values" if name == "Kinds"
  output = File.join("docs", filename)

  I7::Template.write(:pi, output, title: name, pages: Conf.pages, segments: segments, numtotitle: numtotitle)
end

Conf.pages = {}
%w{Contents Actions Kinds Phrasebook Rules Scenes World}.each do |page|
  Conf.pages[page] = "#{page}.html"
end

Conf.pages.each do |page, dest|
  process(page,dest)
end

FileUtils.mkdir_p(File.join("docs", "Details"))

Conf.docfilenames.each do |k,v|
  Conf.docfilenames[k] = "../" + v
end
exit
Dir["Details/*.html"].each do |filename|
  filename.match(%r{/([^\.]+)\.})
  name = $1
  Conf.doc = Nokogiri::HTML(File.read(filename))
  body = Conf.doc.at_css('body')
  element_banner = body.at_css('table.elementbanner')
  first_para = element_banner.at_xpath('following-sibling::p')
  new_div = Conf.doc.create_element('div')
  bolds = first_para.css('b')
  action = bolds.last.content
  action = action[0].upcase + action[1,action.length-1]
  parts = bolds.first.inner_text.split(/\s*-\s*/)
  new_div << Conf.doc.create_element('div', action, class: 'detail-head')
  new_div << Conf.doc.create_element('p', parts.pop)
  separator = Conf.doc.create_element('span', class: 'sep')

  bolds.last.previous.replace(separator) if bolds.last.previous.text? and bolds.last.previous.content.start_with?(',')
  bolds.first.remove
  element_banner.replace(new_div)
  content = Conf.doc.create_element('div')
  body.children.each { |child| content << transform(child) }
  
  output = File.join("docs", filename)
  tmpl = I7::Template[:pi_details]
  
  html =  tmpl.render(level: 1, title: name, pages: Conf.pages, content: content).gsub(/\u007F+/,'<p>').gsub(%r{href="Details/},'href="')
  
  File.open(output, 'w') {|f| f.puts(html) }
  
end

