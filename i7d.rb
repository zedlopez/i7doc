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

$i = 0
def uid
  $i += 1
end

#def phrase_tokenize(str)
#  puts str
  #  str.match(/\(.*?)([^()]*?\)(.*?)/) do |m|


#str.match(/(?<re>((?:[^()]++|\g<re>)*))/) do |m|
  
#  str.match(/\([^()]*?\)/) 
#    puts "|#{$`}|#{$~}|#{$'}|"
#  end
#  puts "--"
#end


  

def phrase_defn(phrase, unbracketed = "neutral", bracketed = "neutral", omit: false)
  paren_level = 0
  open = {}
  [ unbracketed, bracketed ].each {|s| open[s] =  %Q{<span class="#{s.to_s}">} }
  close = '</span>'
  result = []
  result << open[unbracketed] unless phrase.start_with?('(') or omit
  phrase.each_char.with_index do |c,i|
    if c == '('
      unless omit
        result << close unless i.zero?
        result << open[bracketed]
      end
      paren_level += 1
    end
    result << c if !omit or paren_level.zero?
    if c ==')'
      paren_level -= 1 
      if paren_level.zero?
        unless omit
          result << close
          result << open[unbracketed] unless i == (phrase.length - 1)
        end
      end
    end
  end
  result << close unless phrase.end_with?(')') or omit
  result
#  result.join.strip.gsub(/->/,'<span class="mono">-&gt;</span>').gsub(/\s+/,' ')
end

def keysort(str)
  return "(* *)" if str.match(/\{\s+\}/)
  return str if ["a / an / the","an / a / the","the / a / an", '"'].member?(str)
  words = str.downcase.sub(/ü/,'u').sub(/è/,'e').sub(/\A(a|an|the)\s+/,'').split(/\s+/)
  words[0] = words[0].humanize if words[0].match(/\A\d+\Z/) and words[0].to_i < 13
  words.join(' ').gsub(/["\(\)]/,'')
end


def manage(m, target, caret_count, payload)
  print_it = (caret_count == 1)
  reflist = payload.split(/\s*<--\s*/)
  firstmost = reflist.shift
#  puts firstmost if firstmost.match(/paragraph/i)
#  puts firstmost.chars.map {|c| "#{c}|#{c.ord}"}.join("|") if firstmost.match(/paragraph/i)
#  puts '!' if firstmost.match(/\s--\s/)
  firstmost.gsub!(/\s\-\-\s/,': ')
#  puts firstmost if firstmost.match(/paragraph/i)

  firstmost, explicit_sortby = firstmost.split(/\s*-->\s*/)
  parts = firstmost.split(/\s*:\s*/).map {|x| x.gsub(/\\(\d+)/) {|m| $1.to_i.chr } }
  current = Conf.gi
  prev = nil
  total_name = []
  parts.each.with_index(1) do |part,i|
    Conf.rmatch.each_pair do |regexp, cat|
      next unless part.match(regexp)
      part.sub!(/\A[`@>]/,'')
      part.gsub!(%r{\+(#{cat}|to|sayphr|tosay|phr|toout)\+},'')
      if Conf.cat_info[cat][:invert] and !part.include?(',')
        nameparts = part.split(/\s+/)
        part = nameparts.pop + ', ' + nameparts.join(' ')
      end
      name = part
      gi_key = [ name, cat ]
      current[gi_key] ||= { sortby: [ keysort(part), cat ], targets: [], see: [], tag: uid, name: name, key: gi_key }
      total_name << name
      Conf[:gi_by_tag][current[gi_key][:tag]] = current[gi_key]
      Conf[:gi_by_name][total_name.join(': ')] = current[gi_key]
      current[gi_key][:fullname] = total_name.join(': ') 
      if i == parts.count
        current[gi_key][:targets] << target
        current[gi_key][:sortby] = [ explicit_sortby, cat ] if explicit_sortby
      end
      prev = current
      current = current[gi_key]
      break
    end
  end
  if current[:tag]
    reflist.each do |ref|
      Conf[:see][ref] ||= []
      Conf[:see][ref] << current[:tag]
    end
  end
  print_it ? (parts.empty? ? firstmost : parts.last) : ''
end

def mung(line, vol, chapter, section, type: :text)
  target = [ vol, chapter, section ]
  line.gsub!(/\u2013/,'-')
  line = line.gsub(/&gt;/,'>').gsub(/&lt;/,'<')
  line.gsub!(/([\^]+)\{([^}]+)\}/) { |m| manage(m, target, $1.length, $2) }
  line.gsub(/<b>/,'«b»').gsub(/<\/b>/,'«/b»').gsub(/<i>/,'«i»').gsub(/<\/i>/,'«/i»')
end

def read_rawtext(lines = [], filename = nil, vol = nil)
  lines = UTF8.readlines(filename) if lines.blank? and filename
  lines = lines.map(&:rstrip)
  chapter_num = 0
  section_num = 0
  current_code = nil
  previous_pastie = nil
  pastie = nil
  chapters = Hash.new {|h,k| h[k] = { sections: Hash.new {|i,j| i[j] = {} } } }
  section_names = {}
  chapter_names = {}
  defns = {}
  container = { refs: [], blocks: [], example_keys: [], see: [] }
  lines.each.with_index(1) do |line,index|
    line.gsub!(/\t*\Z/,'') # strip any trailing tabs
    case line
    when /\A\(-?See\s+(.*?)\s+(for\s+[^\)]+)\)\Z/
#      puts "adding |#{$1}|#{$2}| to see"
      chapters[chapter_num][:sections][section_num][:see] << [ $1, $2 ]
    when /\A\[(?:[xX]|Chapter:\s+([^\]]+))\]\s*(.*)/
      if !$1.blank?
        chapter_num += 1
        section_num = 0
        chapters[chapter_num][:name] = $1
        chapters[chapter_num][:chapter_num] = chapter_num
        chapter_names[chapters[chapter_num][:name].downcase] = chapter_num
      end
      section_num += 1
      text = $2.strip
      text.match(/\A([^\{]+)(\{.*)?/)
      name = $1.strip
      container = chapters[chapter_num][:sections][section_num] = { name: name, refs: [], blocks: [], example_keys: [], see: [], section_num: section_num, chapter_num: chapter_num, vol: vol }
      if $2 and !$2.empty?
        docrefs = $2
        docrefs.scan(/\{([^\}]+)\}\s*/) do |m|
          chapters[chapter_num][:sections][section_num][:refs] << m.first
          Conf.documented_at[m.first] = [vol, chapter_num, section_num] 
        end
      end
      section_names[name.downcase] = [ chapter_num, section_num ]
    # tags
    when /\A\{([^:]+):\}\s*(.*)/
      taglist = $1
      content = mung($2, vol, chapter_num, section_num)
    # we're simply omitting all tag-specific content
    #      container[:blocks] << { type: (content.match(/\S/) ? :text : :blank), content: content, tags: taglist.split(/\s*,\s*/) } 
    when /\A\s*\Z/
      if current_code # and line.match(/\A\t/)
        # don't add another blank line if previous line was blank
        current_code[:code] << ''
        pastie[:pastie] << '' if pastie
      end
      next
    when /\A(\t+)(?:\{(\*+)\})?\s*(.*)/
      codeline = ("\t" * ($1.length-1)) + mung($3, vol, chapter_num, section_num, type: :code) 
      pastie_indicator = $2
      if current_code
        current_code[:code] << codeline
      else
        current_code = { type: :code, code: [ codeline ], pastie: [], tables: Hash.new {|h,k| h[k] = 0 } }
        current_code[:pastie_block] = current_code
        pastie = nil
        container[:blocks] << current_code
      end
      if pastie_indicator
        if pastie_indicator.length > 1
          pastie = previous_pastie
          pastie[:pastie_block] = current_code
        else
          pastie = current_code
          previous_pastie = pastie
        end
      end
      pastie[:pastie] << codeline if pastie
      next
    when /\A\{end\}/
      container[:blocks] << { type: :end, content: "</div>" }
    # defn
    when /\A\{defn\s+([^\}]+)\}\s*(.*):?\s*/
      id = $1.to_sym
      defn_str = $2
      parenthesized = nil
      bolded = nil
      defn_type = id.start_with?('phs') ? "say phrase" : "phrase"
      puts "** Dupe id #{id}" if Conf.defns.key?(id)
      phrase_obj = I7doc::Phrase.new(id, defn_type, vol, chapter_num, section_num)
#      Conf.defns[id] = { entry: [ vol, chapter_num, section_num], id: id, type: defn_type, list: [] }
      defn_str.split(/\s+&\s+/).each do |defn|
        phrase, *result = *(defn.split(/\s*\.\.\.\s*/))

        phr_defn = phrase_defn(phrase, "<", ">")
        compact = phrase_defn(phrase, omit: true).join.strip.gsub(/->/,'<span class="mono">-&gt;</span>').gsub(/\s+/,' ').sub(/:\Z/,'')
        h = { phrase: phrase, parts: phr_defn, result: result.join('...'), sortby: [ keysort(compact), defn_type] }
        phrase_obj << h
        gi_key = [phrase, defn_type]
        Conf[:gi][gi_key] ||= { type: defn_type, sortby: [ keysort(compact), defn_type], targets: [] , see: [], tag: uid } 
        Conf[:gi_by_tag][Conf[:gi][gi_key][:tag]] = Conf[:gi][gi_key]
        Conf[:gi][gi_key][:targets] << phrase_obj.entry
        Conf[:gi][gi_key][:id] = id
      end
      container[:blocks] << { type: :defn, id: id }
    when /\A\{/
      puts "?????|#{line}|"
    else
      if line.match(/\S/)
        content = mung(line, vol, chapter_num, section_num)
        container[:blocks] << { type: :text, content: content }
      end
    end
    if current_code
      current_code[:code] << '' unless !current_code[:code][-1].match(/\S/)
      pastie[:pastie] << '' if pastie and !pastie[:pastie][-1].match(/\S/)
    end
     
   current_code = nil
  end
  # because we have no lookahead, we may add trailing blank lines to
  # codeblocks. This cleans them up.
  container[:blocks].each do |block|
    next unless block[:type] == :code
    block[:code].pop while !block[:code].empty? and !block[:code][-1].match(/\S/)
    block[:pastie].pop while !block[:pastie].empty? and !block[:pastie][-1].match(/\S/)
  end
  chapters.values.each do |chapter|
    chapter[:last_section] = chapter[:sections].keys.max
    chapter[:sections].values.each do |section|
      section[:blocks].shift while section[:blocks][0][:type] == :text and section[:blocks][0][:content].strip.blank?
      section[:blocks].each do |block|
        next unless block[:type] == :code
        block[:code].pop while !block[:code].empty? and !block[:code][-1].match(/\S/)
        block[:pastie].pop while !block[:pastie].empty? and !block[:pastie][-1].match(/\S/)
      end
    end
  end
  
  return container, chapters, chapter_names, section_names
end

def read_indoc
  UTF8.read(File.join(Conf.doc_dir, "indoc-instructions.txt")).each_line do |line|
    line.strip!
    case line
    when /volume:\s+([^\(]+)\s*(?:\(([^\)]+)\)\s+=\s+(.*))?/
      title = $1
      abbrev_raw = ($2 || title.chars.select { |x| /[[:upper:]]/.match(x) }.join).downcase
      filename = $3 || "#{title}.txt"
      I7doc::Volume.new(abbrev_raw, title, filename)
#      Conf.volumes[abbrev_raw.to_sym] = { title: title, abbrev: abbrev_raw.upcase, filename: filename }
    when /\Aindex:\s+\^\{([^}]+)\}\s*=\s*([^(]+)(\((?:.*))*/
      rawentry = $1
      orig = rawentry.dup
      cat = $2.strip
      modifiers = $3
      modlist = []
      if modifiers
        modifiers.scan(/\(([^)]+)\)\s*/) do |m|
          modlist << $1
        end
      end
      modhash = { label: nil }
      if !modlist.empty? and modlist[0].match(/\A"([^"]+)"\Z/)
        modhash[:label] = $1
        modlist.shift
      end
      modlist.each do |mod|
        mod_parts = mod.split(/\s+/)
        mod_key = mod_parts.shift
        modhash[mod_key.to_sym] = mod_parts.empty? ? true : mod_parts.join(' ')
      end
      
      Conf.cat_info[cat] = $1 if !modlist.empty? and modlist.first.match(/\A"([^"]+)"\Z/)
      if rawentry.include?('headword')
        chars = []
        open = false
        rawentry.each_char do |c|
          if ('+' == c)
            if open
              chars << '\\+)'
              open = false
            else
              chars << '(\\+'
              open = true
            end
          else
            chars << ('^*/(){}[]?'.include?(c) ? '\\' : '') + c
          end
        end   
        rawentry = chars.join

        Conf.rmatch[%r{\A#{rawentry.sub(/headword/,Conf.cat_regexp)}}] = cat
        Conf.cat_info[cat] = modhash
      else
        puts "@@#{line}"
      end
                                                              
    end
  end
  Conf.cat_info['command'][:label] = 'command'
end


def index_see
  Conf[:see].each do |ref, taglist|
    current = Conf.gi
    parts = ref.split(/\s*:\s*/).map {|x| x.gsub(/\\(\d+)/) {|m| $1.to_i.chr } }
    parts.each.with_index(1) do |part,i|
      Conf.rmatch.each_pair do |regexp, cat|
        next unless part.match(regexp)
        part.sub!(/\A[`@>]/,'')
        part.gsub!(/\+[^\+]+\+/,'')
        if Conf.cat_info[cat][:invert] and !part.include?(',')
          nameparts = part.split(/\s+/)
          part = nameparts.pop + ', ' + nameparts.join(' ')
        end
        gi_key = [ part, cat ]
        current[gi_key] ||= { sortby: [ keysort(part), cat ], targets: [], see: [], tag: uid, name: part }
        Conf[:gi_by_tag][current[gi_key][:tag]] = current[gi_key]
        prev = current
        current = current[gi_key]
        break
      end
      taglist.each do |tag|
        Conf[:gi_by_tag][current[:tag]][:see] << Conf[:gi_by_tag][tag] unless Conf[:gi_by_tag][tag][:fullname] == Conf[:gi_by_tag][current[:tag]][:fullname]
      end
    end
  end
end

def scan_recipes
  rb_section = nil
  UTF8.readlines(File.join(Conf.example_dir,"(Recipes).txt")).each do |line|
    line.strip!
    case line
    when ''
      next
    when /\A(.+?)\s+==\s+OMIT\Z/
      Conf.omit_examples[$1] = true # we store this, but do nothing with it.
    # start of a chapter
    when /\A>(.*)/
      puts "Can't find #{$1.downcase} in rb" unless I7doc::Volume[:rb].chapter_names.key?($1.downcase)
      rb_chapter = I7doc::Volume[:rb].chapter_names[$1.downcase]
    # start of a section
    when /\A\*(.*)/
      if I7doc::Volume[:rb].section_names[$1.downcase].blank?
        puts "couldn't find #{$1}"
        next
      end
      rb_section = I7doc::Volume[:rb].section_names[$1.downcase]
    else
      key = line.strip.downcase.sub(/\A\d+\.\s+/,'')
      I7doc::Volume[:rb].section_names[key] = rb_section
    end
  end
end

def phrase_defn(phrase, unbracketed = "neutral", bracketed = "neutral", omit: false)
  paren_level = 0
  open = {}
  [ unbracketed, bracketed ].each {|s| open[s] =  %Q{<span class="#{s.to_s}">} }
  close = '</span>'
  result = []
  result << open[unbracketed] unless phrase.start_with?('(') or omit
  phrase.each_char.with_index do |c,i|
    if c == '('
      unless omit
        result << close unless i.zero?
        result << open[bracketed]
      end
      paren_level += 1
    end
    result << c if !omit or paren_level.zero?
    if c ==')'
      paren_level -= 1 
      if paren_level.zero?
        unless omit
          result << close
          result << open[unbracketed] unless i == (phrase.length - 1)
        end
      end
    end
  end
  result << close unless phrase.end_with?(')') or omit
  result
#  result.join.strip.gsub(/->/,'<span class="mono">-&gt;</span>').gsub(/\s+/,' ')
end

def read_examples
  proceed = nil
  encountered_order = 0
  Dir[File.join(Conf.example_dir, '*.txt')].each do |pathname|
    basename = File.basename(pathname, '.txt')
    next if basename.start_with?('(')
    lines = UTF8.readlines(pathname).map(&:rstrip)
    stars, wi_section_title = lines.shift.strip.match(/\A([\*]+)\s+(.*)/).captures
    rubric = lines.shift.strip.sub(/\A\(/,'').sub(/\)\Z/,'')
    rubric_parts = rubric.split(/\s*--\s*/)
    subnum = nil
    subname = nil
    if rubric_parts[0].match(/([^:]+):\s+(\d+)\.\s+(.*)/)
      name = "#{$1} #{$2}"
      subname = $1
      subnum = $2.to_i
      subtitle = $3
      rubric_parts.shift
      rb_section_title = rubric_parts.empty? ? subtitle : rubric_parts.pop
    elsif rubric_parts[-1].include?(';')
      rb_section_title, name = *(rubric_parts.pop.split(/\s*;\s*/))
      rubric_parts.push(rb_section_title) if rubric_parts.empty?
    elsif rubric_parts.count == 1
      name = rb_section_title = rubric_parts.shift
    else
      puts "PROBLEM"
    end
    name.sub!(/:\s+(\d)\Z/) { " #{$1}" }
    desc = lines.shift.strip
    body = read_rawtext(lines)
    container = body.first
    
    example = I7doc::Example.new(stars: stars.length, name: name, desc: desc, section_name: { wi: wi_section_title, rb: rb_section_title}, body: container, filename: basename, index_entries: rubric_parts, subtitle: subtitle, subname: subname, subnum: subnum)

  end
end

def prepare_output_dir
  FileUtils.mkdir_p(Conf.output_dir)
  FileUtils.cp_r(File.join(Conf.resource_dir, 'Imagery', 'doc_images'), Conf.output_dir)
  %w{ i7doc.js license.html mit.html}.each do |fname|
    path = File.join(Conf.output_dir, fname)
    FileUtils.rm(path) if File.exists?(path)
    FileUtils.cp(fname, Conf.output_dir)
  end
  FileUtils.rm_rf(File.join(Conf.example_output_dir, 'interpreter'))
  FileUtils.cp_r('interpreter', Conf.example_output_dir)
end

def output_toc
  filename = File.join(Conf.output_dir, "index.html")
  I7::Template.write(:toc, filename, title: "Inform 7 v10 documentation")
end


module I7doc
  module Blockhead
    def blocklines
      return self.lines.join("\n") if !self.lines.blank?
      in_defn = false
      self.lines = []
      self.blocks.each do |block|
        self.lines << '' unless block[:type] == :end
        case block[:type]
        when :text
          self.lines << (in_defn ? "    #{block[:content]}" : block[:content])
        when :code
          self.lines << block[:code].map {|x| "    #{x}"}.join("\n")
        when :defn
          self.lines << I7doc::Phrase[block[:id]]
          in_defn = true
        when :end
          in_defn = false
        end
      end
      self.lines
    end
  end

  class Example
    include I7doc::Blockhead
    @example_num = 0

    def self.next_example_num
      @example_num += 1
    end
    
    @examples = {}
    @subnames = Hash.new {|h,k| h[k] = {} }
    @by_num = {}
    class << self
      attr_accessor :examples, :subnames, :by_num
    end

    def self.[](x)
      @examples[x.to_s]
    end

    def self.[]=(x,y)
      @examples[x.to_s] = y
    end

    def url
      [ 'examples', @cname, '' ].join('/')
    end
    
    def self.number_examples
      I7doc::Volume[:wi].chapters.each_pair do |chapter_num, chapter|
        chapter.sections.each_pair do |section_num, section|
          section.example_keys.each do |k|
            @examples[k].example_num = next_example_num
          end
        end
      end
    end

    
# TODO
#  clark2 = Conf.examples['man_of_steel_excuses_himself'][:body][:blocks].find {|b| (b[:type] == :code) && !b[:pastie].empty? }
#  clark = Conf.examples['man_of_steel'][:body][:blocks].find {|b| (b[:type] == :code) && !b[:pastie].empty? }
#  excuse = Conf.examples['man_of_steel_excuses_himself'][:body][:blocks].find {|b| (b[:type] == :code) && !b[:pastie].empty? }
#  %i{code pastie}.each do |s|
#    excuse[s] = clark[s] + [''] + clark2[s]
#    excuse[s].shift
#    excuse[s].unshift(%Q{"The Man of Steel Excuses Himself"})
#  end
    attr_reader :cname, :blocks, :name, :section_name, :stars, :filename, :desc
    attr_accessor :lines, :refs, :example_num
    
    def initialize(**opt)
      @stars = opt[:stars]
      @name = opt[:name]
      @desc = opt[:desc]
      @section_name = opt[:section_name]
      @blocks = opt[:body][:blocks]
      @refs = Hash.new {|h,k| h[k] = {} } 
      @example_keys = opt[:body][:example_keys]
      @see = opt[:body][:see]
      @filename = opt[:filename]
      @cname = @name.parameterize
      @index_entries = opt[:index_entries]
      @subtitle = opt[:subtitle]
      @subname = opt[:subname]
      @subnum = opt[:subnum]
      @lines = []
      @example_num = nil
      self.class.examples[@cname] = self
      self.class.subnames[@subname][@subnum] = self if @subname
    end

    def short_title
      "#{@example_num}. #{@name} #{'*' * @stars}"
    end

    def section(vol)
      I7doc::Volume[vol].section_names[@section_name[vol]].downcase
    end

    
    def to_s
      lines = blocklines
      lines.join("\n")
    end

  end
    
  class Volume
    @volumes = {}
    @docfilenames = {}
    class << self
      attr_accessor :volumes, :docfilenames
    end    
    def self.[](x)
      @volumes[x]
    end

    def self.[]=(x,y)
      @volumes[x] = y
    end

    def self.docfilename_dump
      @docfilenames.each_pair do |docname, sect|
        puts "#{docname} => #{sect.fullname}"
      end
    end
    
    attr_accessor :section_names, :chapter_names
    attr_reader :label, :filename, :abbrev, :title, :fulltitle, :chapters, :last_chapter
    def initialize(label, title, filename)
      @label = label.to_sym
      @filename = filename
      @abbrev = label.to_s.upcase
      @title = ((@label == :rb) ? 'Recipe Book' : title)
      @fulltitle = title
      @chapters = {}
      @section_names = {}
      @chapter_names = {}
      @count = 0
      self.class.volumes[@label] = self
      read_file
    end

    def docfilename_root
      self.wi? ? 'doc' : 'Rdoc'
    end
    
    def register(sect)
      @count += 1
      Volume.docfilenames[ "#{docfilename_root}#{@count}.html" ] = sect
    end

    def rb?
      @label == :rb
    end

    def wi?
      @label == :wi
    end
    
    def full_filename
      File.join(Conf.doc_dir, @filename)     
    end

    def [](n)
      n = n.to_i
      @chapters[n]
    end
    
    def read_file
      container, chapters, chapter_names, section_names = read_rawtext([], full_filename, @label)
      chapters.each_pair do |chapter_num, chapter|
        @chapters[chapter_num] = Chapter.new(chapter, self)
      end
      @last_chapter = chapters.keys.max

      chapter_names['introduction'] = 1 if @label == :rb
      chapter_names.each do |name, num|
        @chapter_names[name] = @chapters[num]
      end
      section_names.each do |name, tuple|
        @section_names[name] = @chapters[tuple[0]][tuple[1]]
      end
    end

    def assign_examples
      return unless @label == :wi
      find_examples
      I7doc::Volume[@label].chapters.each_pair do |chapter_num, chapter|
        chapter.sections.each_pair do |section_num, section|
          section.example_keys = section.example_keys.sort_by do |k|
            y = I7doc::Example.examples[k]
            [ y.stars, y.filename.downcase ]
          end
        end
      end
    end

    def place_examples
      return unless @label == :rb
      find_examples
      I7doc::Volume[@label].chapters.each_pair do |chapter_num, chapter|
        chapter.sections.each_pair do |section_num, section|
          section.example_keys = section.example_keys.sort_by do |k|
            y = I7doc::Example.examples[k]
            [ y.stars, y.example_num ]
          end
        end
      end
    end

    def find_examples
      I7doc::Example.examples.each_pair do |k,v|
        puts "** Empty name for #{k}" if v.name.blank?
        name = v.section_name[@label].downcase
        if !@section_names.key?(name)
          puts "** can't find #{name} in #{vol}"
        else
          section = @section_names[name]
          v.refs[@label] = section
          section.example_keys << k
        end
      end
    end

    def prev_volume
      self.rb? ? I7doc::Volume.volumes[:wi] : nil
    end

    def next_volume
      self.wi? ? I7doc::Volume.volumes[:rb] : nil
    end
  end

  class Chapter
    attr_reader :num, :name, :vol, :sections, :last_section
    def initialize(chapter, volume)
      @num = chapter[:chapter_num]
      @name = chapter[:name]
      @vol = volume
      @sections = {}
      chapter[:sections].each_pair do |section_num,section|
        @sections[section_num] = Section.new(section, self)
      end
      @last_section = @sections.keys.max
    end

    def [](n)
      @sections[n]
    end

    def url
      [ @vol.label, @num, ''].join('/')
    end

    def last_section
      @sections[@last_section]
    end

    def prev_chapter
      return @vol.chapters[@num - 1] if @num > 1
      v = @vol.prev_volume
      return v if v.nil?
      v.last_chapter
    end

    def next_chapter
      return @vol.chapters[@num + 1] if @num < @vol.last_chapter
      v = @vol.next_volume
      return v if v.nil?
      v.chapters[1]
    end

  end

  class Section
    include I7doc::Blockhead
    
    @names = {}
    class << self
      attr_accessor :names
    end
    
    attr_reader :name, :refs, :blocks, :see, :num, :chapter, :vol
    attr_accessor :lines, :example_keys

    def url
      [ self.chapter.url, @num ].join('#')
    end
    
    def to_s
      lines = blocklines
      lines.unshift(fullname)
      unless self.examples.blank?
        lines += [ '', 'Examples', '' ]
        self.examples.each do |num, example|
          lines << example.short_title
        end
      end
      lines.join("\n")
    end
    
    def initialize(section, chapter)
      @name = section[:name]
      @refs = section[:refs]
      @blocks = section[:blocks]
      @examples = nil
      @example_keys = section[:example_keys]
      @see = section[:see]
      @num = section[:section_num]
      @chapter = chapter
      @vol = chapter.vol
      @docfilename = @vol.register(self)
      @lines = nil
    end

    def examples
      @examples ||= example_keys.to_h {|k| [k, I7doc::Example.examples[k] ] }
    end

    def chap_sect
      "#{@chapter.num}.#{@num}"
    end

    def chap_sect_name
      "#{chap_sect} #{@name}"
    end
    
    def citation
      "#{@vol.abbrev} #{chap_sect}"
    end

    def fullname
      "#{citation} #{@name}"
    end

    def prev_sect
      return @chapter.sections[@num - 1] if @num > 1
      ch = @chapter.prev_chapter
      return ch if ch.nil?
      ch.last_section
    end

    def next_sect
      return @chapter.sections[@num + 1] if @num < @chapter.last_section
      ch = @chapter.next_chapter
      return ch if ch.nil?
      @chapter.next_chapter.chapters[1]
    end

    def legacy_anchor
      "##{legacy_id}"
    end

    def legacy_id
      "section_#{@num}"
    end

    def nav_elements
      [ prev_section, @chapter, next_section ]
    end
    
    
    
  end
  
  class Phrase
    @phrases = {}

    class << self
      attr_accessor :phrases
    end

    def self.[](x)
      x = x.to_sym
      @phrases[x]
    end

    def self.[]=(x,y)
      x = x.to_sym
      @phrases[x] = y
    end

    attr_reader :id, :type, :lines

    def <<(x)
      @lines << x
    end

    def to_s
      result = []
      self.lines.each.with_index(1) do |defn, i|
        phr_defn = phrase_defn(defn[:phrase], "defn", "neutral").reject {|x| x.match(/span/)}.join
        line = phr_defn
        line += " -> #{defn[:result]}" if !defn[:result].blank?
        line += "or..." if i < lines.count
        result << "    #{line}"
      end
      result.join("\n")
    end
    
    def entry
      [ @vol, @chapter_num, @section_num ]
    end
    
    def initialize(id, type, vol, chapter_num, section_num)
      @id = id
      @type = type
      @vol_label = vol
      @chapter_num = chapter_num
      @section_num = section_num
      @lines = []
      self.class.phrases[@id] = self
    end
  end
end

if __FILE__ == $0
  configure
  read_indoc
  index_see
  scan_recipes
  read_examples
  I7doc::Volume[:wi].assign_examples
  I7doc::Example.number_examples
  I7doc::Volume[:rb].place_examples
  # TODO next up: run_examples
  prepare_output_dir
  output_toc
  #  I7doc::Volume.docfilename_dump
  File.open("docfilenames.yml",'w') do |f|
    f.puts(YAML.dump(Hash[I7doc::Volume.docfilenames.map {|k,v| [k, v.citation]}]))
  end
  File.open("links.yml",'w') do |f|
    f.puts(YAML.dump(Hash[I7doc::Volume.docfilenames.map {|k,v| [k, "https://zedlopez.github.io/i7doc/#{v.vol.abbrev}_#{v.chapter.num}#section#{v.num}"] }]))
  end
  pp I7doc::Phrase.phrases
#  I7doc::Volume.volumes.each do |volume|
#    volume.chapters.each do |chapter|
#      chapter.sections.each do |section|
#        yaml[section.
  
  # output_about
  # output_chapters
  # output_examples
  # output_general_index
  # output search
#  puts "--"
#  puts I7doc::Example["aarp-gnosis"]
#  puts I7doc::Volume[:rb][2][1]
#  puts I7doc::Volume[:wi][11][8]
end
