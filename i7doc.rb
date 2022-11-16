#!/usr/bin/env ruby

# ruby -Ilib i7doc.rb

# Save your sanity and don't look at this ugly, ugly code.
# It's too late for me; it doesn't have to be too late for you.

# remglk and status line updates

# add link to plain text version (the generated .i7)
# include comment in plain text with original filename

# ostruct for Conf

# file:///home/zed/mine/i7doc/docs/examples/tilt3.html
# copycode has no focus

# "the (next|previous) chapter"

# build both -rnd and non-rnd versions of the examples. Use the rnd versions for the testme_output and
# the non-rnd versions for Quixe.

# maybe a scheme at end of htmlify to detect orphans and surround with a nowrap span

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

class Conf
  def self.[](x)
    @h[x.to_sym]
  end
  def self.[]=(x,y)
    @h ||= {}
    @h[x.to_sym]=y
  end
  def self.method_missing(m, *args)
    @h[m]
  end
end

def configure
  Conf[:default_inform_dir] = "/home/zed/mine/inform"
  informdir = ARGV.shift || Conf.default_inform_dir
  Conf[:resource_dir] = File.join(informdir, 'resources')
  Conf[:doc_dir] = File.join(Conf.resource_dir, 'Documentation')
  Conf[:example_dir] = File.join(Conf.doc_dir, 'Examples')
  Conf[:output_dir] = 'docs'
  Conf[:example_output_dir] = File.join(Conf.output_dir, 'examples')
  Conf[:volumes] = {}
  Conf[:books] = {}
  Conf[:section_names] = Hash.new {|h,k| h[k] = {} }
  Conf[:chapter_names] = Hash.new {|h,k| h[k] = {} }
  Conf[:defns] = {}
  Conf[:omit_examples] = {}
  Conf[:examples] = {}
  Conf[:examples_by_num] = {}
  Conf[:subnames] = Hash.new {|h,k| h[k] = {} }
  Conf[:gi] = {}
  Conf[:gi_by_tag] = {}
  Conf[:gi_by_name] = {}
  Conf[:index_bar] = {}
  Conf[:testme_cmds] = {
    "HintsOff" => [ 'test me', 'no', 'quit', 'y' ],
    "Entrevaux" => [ 'test me', ' ', 'quit', 'y' ],
    "Cloves" => ["insouciantly test me", "\quit defiantly", "y"],
    "IgpayAtinlay" => ["test me"],
    "Nudge" => ["test me", "y", "y"],
    "Proposal" => ["yes", "test me", "quit", "y"],
    "SP" => ["test me", ' ', "  test ad", ' ', "  test ending", "quit", "y"],
    "Solitude" => ["y", "test me", "quit", "y"],
    "Wight" => ["hint about wight", "y", "north", "get bar", "south", "open tomb", "get dagger", "south", "hint about wight", "y", "read inscription", "hint about wight", "y", "attack wight", "throw dagger at wight", "south", "quit", "y"],
    "Rubies" => [ 'Exemplar', 'test me' ]
  }
  Conf[:text_subs] = 
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
#  Conf[:append] = { after: { rb: { }, wi: { }, ex: {} },
#                    fore: { rb: { }, wi: { }, ex: {} },
#                  }
  Conf[:xdir] = '/home/zed/inf7/y'
  Conf[:table] = []
  Conf[:tmpl] = 'i7/tmpl'
  Conf[:skip_examples] = %w{ Floorplan Mapped MappedGreece Tilt3 Gas2 Garibaldi2 TrinityStatus }
  Conf[:see] = {}
  Conf[:navpages] = { toc: {name:"Contents", dest: 'index.html'},
             examples: {name: "Examples", dest: 'examples/index.html' },
             general_index: { name: "Index", dest: 'general_index.html' },
             search: {name: "Search", dest: 'search.html' },
                    }
  Conf[:documented_at] = {}
#  ← → ↑ ⭱⬆ ⬅ ⮕ ⬆ ↓ ↴
  Conf[:syms] = { left: '⬅', right: '⮕', up: '⬆', star: '★', downright: '↴', heavyright: '➜' }
end

def prepare_output_dir
  FileUtils.mkdir_p(Conf.output_dir)
  FileUtils.cp_r(File.join(Conf.resource_dir, 'Imagery', 'doc_images'), Conf.output_dir)
  %w{ i7doc.js i7doc.css license.html mit.html}.each do |fname|
    path = File.join(Conf.output_dir, fname)
    FileUtils.rm(path) if File.exists?(path)
    FileUtils.cp(fname, Conf.output_dir)
  end
  FileUtils.rm_rf(File.join(Conf.example_output_dir, 'interpreter'))
  FileUtils.cp_r('interpreter', Conf.example_output_dir)
end

def scan_recipes
  rb_chapter_num = 0
  rb_section_num = 0
  UTF8.readlines(File.join(Conf.example_dir,"(Recipes).txt")).each do |line|
    line.strip!
    case line
    when ''
      next
    when /\A(.+?)\s+==\s+OMIT\Z/
      Conf.omit_examples[$1] = true # we store this, but do nothing with it.
    # start of a chapter
    when /\A>(.*)/
      puts "Can't find #{$1.downcase} in rb" unless Conf.chapter_names[:rb].key?($1.downcase)
      rb_chapter_num = Conf.chapter_names[:rb][$1.downcase]
    # start of a section
    when /\A\*(.*)/
      puts "couldn't find #{$1}" unless Conf.section_names[:rb][$1.downcase] 
      next unless Conf.section_names[:rb][$1.downcase] 
      rb_section_num = Conf.section_names[:rb][$1.downcase][1]
    else
      key = line.strip.downcase.sub(/\A\d+\.\s+/,'')
      Conf.section_names[:rb][key] = [ rb_chapter_num, rb_section_num ]
    end
  end
end

def target_anchor(*target)
  vol, ch, sect, monolith = *target
  monolith ? "#{vol}#{ch}_#{sect}" : "#{Conf.books[vol][:abbrev]}_#{ch}.html#section_#{sect}"
end

def print_target(*target)
  vol, ch, sect, monolith = *target
  target = target_anchor(vol, ch, sect, monolith)
  target = "##{target}" if monolith
  %Q{<a href="#{target}"><span class="sc">#{vol.to_s.upcase}</span>&nbsp;#{ch}.#{sect}</a>}
end

# ^^{kinds: default values of kinds <-- default properties of kinds}
# this means 'default properties of kinds' gets a see-also to kinds: default values of kinds
# ^^{values: kinds of value: default values}
# this means this bit has an entry under values -> kinds of value -> default values

#^^{initial state of the world <-- beginning of story <-- introduction}
# create "initial state of the world" entry here
# "beginning of story" gets a "see initial state of the world"
# "inroduction" gets initial state of the world


# ^^{variables: global <-- values: varying <-- global variables}
# create variables: global here
# values: varying gets see variables: global
# global: variables gets see variables: global

numwords = %w{one two three four five six seven eight nine ten eleven twelve}
$nummap = Hash[numwords.map.with_index {|s,i| [(i+1).to_s,s]}]

def keysort(str)
  return str if ["a / an / the","an / a / the","the / a / an", '"'].member?(str)
  words = str.downcase.sub(/ü/,'u').sub(/è/,'e').sub(/\A(a|an|the)\s+/,'').split(/\s+/)
  words[0] = $nummap[words[0]] if $nummap.key?(words[0])
  words.join(' ').gsub(/["\(\)]/,'')
end


$catmap = {}
$rhash = {}

$cat_hash = { "phrase" => { label: 'phrase', bracketed: true, bracket_class: :phrase, unbracket_class: :neutral }, "say phrase" => { label: 'say phrase', bracketed: true, bracket_class: :sayphrase, unbracket_class: :neutral } }

def target_chapter(vol, chapter_num, monolithic = false, label = nil, level: 0)
  ((['..']*level) + [[ Conf.books[vol][:abbrev], chapter_num ].join('_')]).join('/') + '.html'
end

def target_pair(target, monolithic = false, label = nil)
  vol, ch, sect = *target
  dest = monolithic ? "##{vol}#{ch}.#{sect}" : "#{Conf.books[vol][:abbrev]}_#{ch}.html#section_#{sect}"
  label ||= %Q{<span class="sc">#{vol.to_s}</span>&nbsp;#{ch}.#{sect}}
  title = "#{Conf.books[vol][:chapters][ch][:name]} &gt; #{Conf.books[vol][:chapters][ch][:sections][sect][:name]}"
  [ dest, label, title ]
end
  
def target_pair_link(target, monolithic = false, label = nil, level: 0)
  dest, label, title = *(target_pair(target, monolithic, label))
  dest = ((['..']*level) + [dest]).join('/')
  %Q{<a href="#{dest}" title="#{title}" class="index-link raw">#{label}</a>}
end

def manage(m, target, caret_count, payload)
  print_it = (caret_count == 1)
  reflist = payload.split(/\s*<--\s*/)
  firstmost = reflist.shift
  firstmost, explicit_sortby = firstmost.split(/\s*-->\s*/)
  parts = firstmost.split(/\s*:\s*/).map {|x| x.gsub(/\\(\d+)/) {|m| $1.to_i.chr } }
  current = Conf.gi
  prev = nil
  total_name = []
  parts.each.with_index(1) do |part,i|
    $rhash.each_pair do |regexp, cat|
      next unless part.match(regexp)
      part.sub!(/\A[`@>]/,'')
      part.gsub!(%r{\+(#{cat}|to|sayphr|tosay|phr|toout)\+},'')
      if $cat_hash[cat][:invert] and !part.include?(',')
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
  reflist.each do |ref|
    Conf[:see][ref] ||= []
    Conf[:see][ref] << current[:tag]
  end
  print_it ? (parts.empty? ? firstmost : parts.last) : ''
end

def index_see
  Conf[:see].each do |ref, taglist|
    current = Conf.gi
    parts = ref.split(/\s*:\s*/).map {|x| x.gsub(/\\(\d+)/) {|m| $1.to_i.chr } }
    parts.each.with_index(1) do |part,i|
      $rhash.each_pair do |regexp, cat|
      next unless part.match(regexp)
      part.sub!(/\A[`@>]/,'')
      part.gsub!(/\+[^\+]+\+/,'')
      if $cat_hash[cat][:invert] and !part.include?(',')
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
    end
    taglist.each do |tag|
      Conf[:gi_by_tag][current[:tag]][:see] << Conf[:gi_by_tag][tag] unless Conf[:gi_by_tag][tag][:fullname] == Conf[:gi_by_tag][current[:tag]][:fullname]
    end
  end
end

def sym(sym, i)
  %Q{<span class="sym">#{Conf.syms[:star] * i.to_i}</span>}
end


def replace_example(line, vol, monolithic = false, level: 0)
  result = []
  prev = nil
  line.gsub(/«\/b»/,'«b»').split(/«b»/).each.with_index do |word, i|
    if i.even?
      result << htmlify(word, level: level)
    else
      orig = word
      word.sub!(/\s+1\Z/,'')
      if word == '2'
        word = prev + ' 2'
        word.sub!(/\AThe\s+/,'')
      end
      cname = canonical_example_name(word);
      if Conf.examples.key?(cname)
        example = Conf.examples[cname]
        target = (monolithic ? "#example_#{cname}" : "examples/#{cname}.html")
        result << %Q{<span class="example-name"><a href="#{target}" title="#{CGI.escapeHTML(example[:desc])}">#{htmlify(word, level: level)}</a></span> #{sym(:star, example[:stars])}}
      elsif orig.match(/(Writing with Inform|The Inform Recipe Book)/)
        target = ($1 == 'Writing with Inform') ? "wi" : "rb"
        result << %Q{<a href="##{target}"><strong>#{htmlify(orig, level: level)}</strong></a>}
      else
        result << %Q{<strong>#{htmlify(word, level: level)}</strong>}
      end
      prev = word
    end
  end
  result.join
end

def mung(line, vol, chapter, section, type: :text)
  target = [ vol, chapter, section ]
  line = line.gsub(/&gt;/,'>').gsub(/&lt;/,'<')
  line.gsub!(/([\^]+)\{([^}]+)\}/) { |m| manage(m, target, $1.length, $2) }
  line.gsub(/<b>/,'«b»').gsub(/<\/b>/,'«/b»').gsub(/<i>/,'«i»').gsub(/<\/i>/,'«/i»')
end

$hyph = {}
File.open("local") do |f|
  f.each_line do |l|
    l.chomp!
    p = l.split(/\|/);
    $hyph[p[0]] = p[1].gsub(/-/,'­');
  end
end

# shy: ­


def htmlify(line, type: :text, level: 0)
  orig = line
  line = line.gsub(%r{///asterisk.png///\s*}, '★').gsub(/★-/,'★ -')
  # newline = []
  # chs = []
  # if type == :text
  #   line.chars.each do |char|
  #     if char.match(/[A-Za-z]/)
  #       chs << char
  #     else
  #       unless chs.empty?
  #         word = chs.join
  #         puts word if $hyph.key?(word.downcase)
  #         newline << ($hyph.key?(word.downcase) ? $hyph[word.downcase] : word)
  #         chs = []
  #       end
  #       newline << char
  #     end
  #   end
  #   line = newline.join
  # end
  line = CGI::escapeHTML(line)
  line.gsub!(%r{///(?:([^:]+):)?(.+?)///}) do |m|
    result= %Q{«img src="#{level.zero? ? ['doc_images',$2].join('/') : [(['..']*level),'doc_images',$2].join("/")}"}
    result += %Q{ class="#{$1}"} if $1 and !$1.empty?
    result + '»'
  end
  line = line.gsub(/«/,'<').gsub(/»/,'>').gsub(/<b>/,'<strong>').gsub(/<\/b>/,'</strong>').gsub('<i>','<em>').gsub(/<\/i>/,'</em>')
  Conf.text_subs.each_pair { |regexp, subst| line.gsub!(regexp, subst.to_s) }
#  if false
  Conf.books.each_pair do |vol,book|
    book[:chapters].keys.sort.each do |chapter_num|
      chapter = book[:chapters][chapter_num]
      line.gsub!(%r{(#{chapter[:name]}\s+chapter|chapter\s+on\s+"?#{chapter[:name]}"?)}i) {|m| %Q{<a href="#{target_chapter(vol, chapter[:chapter_num])}">#{$1}</a>} }
    end
  end
#  end
  line.gsub!(/-&gt;/,'&rarr;') if type == :defn
  if type == :text
    line.gsub!(/\.\.\./,'&hellip;')
    line.gsub!(/(\s+)--?(\s+)/) {|m| "#{$1}&ndash;#{$2}" }
  end
  line
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
  result.join.strip.gsub(/->/,'<span class="mono">-&gt;</span>').gsub(/\s+/,' ')
end

$i = 0
def uid
  $i += 1
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
      id = $1
      defn_str = $2
      parenthesized = nil
      bolded = nil
      defn_type = id.start_with?('phs') ? "say phrase" : "phrase"
      Conf.defns[id] = { entry: [ vol, chapter_num, section_num], id: id, type: defn_type, list: [] }
      defn_str.split(/\s+&\s+/).each do |defn|
        phrase, *result = *(defn.split(/\s*\.\.\.\s*/))
        compact = phrase_defn(phrase, omit: true).sub(/:\Z/,'')
        h = { phrase: phrase, result: result.join('...'), sortby: [ keysort(compact), defn_type] }
        Conf.defns[id][:list] << h
        gi_key = [phrase, defn_type]
        Conf[:gi][gi_key] ||= { type: defn_type, sortby: [ keysort(compact), defn_type], targets: [] , see: [], tag: uid } 
        Conf[:gi_by_tag][Conf[:gi][gi_key][:tag]] = Conf[:gi][gi_key]
        entry_target = Conf.defns[id][:entry]
        Conf[:gi][gi_key][:targets] << entry_target 
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
    chapter[:sections].values.each do |section|
      section[:blocks].each do |block|
        next unless block[:type] == :code
        block[:code].pop while !block[:code].empty? and !block[:code][-1].match(/\S/)
        block[:pastie].pop while !block[:pastie].empty? and !block[:pastie][-1].match(/\S/)
      end
    end
  end
  
  return container, chapters, chapter_names, section_names, defns
end

def first_pass
  Conf.volumes.each_pair do |vol, info|
    Conf.books[vol] = { abbrev: info[:abbrev], title: info[:title], fulltitle: info[:title] }
    chapters = Conf.books[vol][:chapters]
    container, chapters, chapter_names, section_names, defns = read_rawtext([], File.join(Conf.doc_dir, info[:filename]), vol)
    Conf.books[vol][:chapters] = chapters
    Conf.chapter_names[vol] = chapter_names
    Conf.section_names[vol] = section_names
    Conf.defns = defns
#    chapters.values.each {|ch| dest = target_chapter(vol, ch[:chapter_num]); Conf[:text_subs][%r{(#{ch[:name]}\s+chapter|chapter\s+on\s+#{ch[:name]})}i] = lambda { |m| %Q{<a href="">#{m[1]}</a>} } }
  end
  Conf.books[:rb][:title] = 'Recipe Book'
  Conf[:chapter_names][:rb]['introduction'] = 1
  
end

def print_bar(f, alpha)
    alpha ||= ('a'.ord-1).chr
    f.print %Q{<div class="indexbar-holder"><div class="indexbar" id="indexbar_#{alpha}">}
    'a'.upto('z') do |letter|
      if letter == alpha
        f.print %Q{<div class="indexletter indexcurrentletter">#{letter.upcase}</div>}
      else
        f.print Conf.index_bar.key?(letter) ? %Q{<div class="indexletter"><a href="#indexbar_#{letter}">#{letter.upcase}</a></div>} : letter.upcase
      end
    end
    f.print '</div></div>'
end

def print_index_entry(f, k, h, level, monolithic = false)
  text, cat = *k
  return if cat == 'relcat' or cat == 'propcat'
  if level == 0
    alpha = Conf.gi[k][:sortby][0][0]
    print_bar(f, alpha) if Conf.index_bar[alpha] == h[:tag]
  end
  cat = 'sayphrase' if ((cat == 'phrase') and (text.start_with?('say')))
  f.print %Q{<div class="index-entry indent#{level}" id="index_#{h[:tag]}">}
  text = text.dup
  unless h[:id]
    text = text.gsub(/\\\(/,'«').gsub(/\\\)/,'»').gsub(/\(/,'').gsub(/\)/,'').gsub(/«/,'(').gsub(/»/,')') 
    text = text.gsub(/([[:punct:]]+?)(,?)/) {|m| %Q{<span class="mono">#{$1}</span>#{$2}} }
  end
  #  text.gsub!(/->/,Conf.syms[:heavyright])
  text = phrase_defn(text, "index#{cat}", "index#{cat}bracketed")
  if h[:id]
    defn = Conf.defns[h[:id]]
    dvol, dchap = *(defn[:entry])
    f.print %Q{<a href="#{target_chapter(dvol, dchap, monolithic)}##{h[:id]}">#{text}</a>}
  else
    f.print text
  end
  if $cat_hash[cat][:label]
    f.print %Q{ <span class="index-label">#{$cat_hash[cat][:label]}</span>}
  end
  if !h[:targets].blank?
    f.print " "
    # crude de-duping
    targets = Hash[ h[:targets].map {|x| [x,x]}].keys.map do |target|
      target_pair_link(target, monolithic)
    end
    f.print %Q{<span class="index-ref-list">#{targets.join('&ensp;')}</span>}
  end
  if !h[:see].blank?
    f.print ' ; ' if !h[:targets].blank?
    f.print %Q{ <span class="see">see}
    f.print ' also' if !h[:targets].blank?
    f.print '</span> '
    f.print (h[:see].map do |x|
               anchor = "#index_#{x[:tag]}"
               %Q{<a class="index-link raw" href="#{anchor}">#{x[:fullname]}</a>}
             end).join(', ')
  end
  f.puts "</div>"
  subentries = h.keys.select {|v| Array === v }
  subentries.sort_by {|k| h[k][:sortby]}.each do |s|
    print_index_entry(f, s, h[s], level + 1)
  end
end

def print_index(f, monolithic = false)
  f.puts '<div id="general-index">'
  Conf.gi.keys.sort_by {|k| Conf.gi[k][:sortby] }.each do |k|
    primary = Conf.gi[k][:sortby][0][0]
    Conf.index_bar[primary] ||= Conf.gi[k][:tag] if primary.match(/\A[a-z]/)
    if Conf.gi[k][:sortby][0].length > 1
      secundus = Conf.gi[k][:sortby][0][0,2] 
      Conf.index_bar["#{primary}#{secundus}"] ||= Conf.gi[k][:tag] if secundus.match(/\A[a-z]*\Z/)
    end
  end
  print_bar(f, nil)
  Conf.gi.keys.sort_by {|k| Conf.gi[k][:sortby] }.each do |k|
    print_index_entry(f, k, Conf.gi[k], 0, monolithic)
  end
  f.puts "</div>"
end

def canonical_example_name(str)
    canonized_name = I18n.transliterate(str.downcase.sub(/\A(?:an?|the)\s+/,'').gsub(/[-'!\.,\?]*/,'').sub(/:?\s+1\Z/,'').sub(/:?\s+(\d+)\Z/) {|m| $1 }.gsub(/\s+/,' ').gsub(/ /,'_'))
    case canonized_name
    when 'swigmore'
      'swigmore_u'
    when 'meteoric'
      'meteoric_i_and_ii'
    when 'rip'
      'rip_van_winkle'
    when 'neighbourhood_watch'
      'neighborhood_watch'
    else
      canonized_name
    end
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

    #(Sybil: 1. ASK, TELL, and ANSWER conflated--ASK, TELL, and ANSWER commands rolled into one)
    # (Accented and exotic letters and symbols; The Über-complète clavier)    

    # Basic Scenery is the rb_section_title
    # (Disenchantment Bay: 2. Scenery--Basic scenery)
    # (The Crane's Leg: 1. Descriptions based on how objects compare with player's expectations--Description related to player preconceptions)
    # Garibaldi.txt: (Garibaldi: 1. Readout of all doors in the game--Readout showing status of all doors)
    # Zed.txt: (Travel requiring a vehicle; Peugeot) <-- Peugeot is name; other is rb-map AND should be an examples-index intry
    # Regexp.txt: (About Inform's regular expression support) <-- both name and rb-map from recipes.txt
    # (Port Royal: 1. A landscape from Jamaica, 1691)
    cname = canonical_example_name(name)
    name.sub!(/:\s+(\d)\Z/) { " #{$1}" }
    desc = lines.shift.strip
    body = read_rawtext(lines)
    container = body.first
    ex_value = { stars: stars.length, name: name, desc: desc, wi: wi_section_title, rb: rb_section_title, body: container, refs: {}, filename: basename, cname: cname, index_entries: rubric_parts, subtitle: subtitle, subname: subname, subnum: subnum }
    Conf.examples[cname] = ex_value
    Conf.subnames[subname][subnum] = Conf.examples[cname] if subname
  end
  clark2 = Conf.examples['man_of_steel_excuses_himself'][:body][:blocks].find {|b| (b[:type] == :code) && !b[:pastie].empty? }
  clark = Conf.examples['man_of_steel'][:body][:blocks].find {|b| (b[:type] == :code) && !b[:pastie].empty? }
  excuse = Conf.examples['man_of_steel_excuses_himself'][:body][:blocks].find {|b| (b[:type] == :code) && !b[:pastie].empty? }
  %i{code pastie}.each do |s|
    excuse[s] = clark[s] + [''] + clark2[s]
    excuse[s].shift
    excuse[s].unshift(%Q{"The Man of Steel Excuses Himself"})
  end
end

def run_examples
  FileUtils.rm("leaderboard.glkdata") if File.exist?("leaderboard.glkdata") # Rubies example
  suffix_syms = %i{ i7 i6 ulx out}
    Conf.examples.values.each do |example|
      codeblocks = example[:body][:blocks].select {|x| x[:type] == :code and !x[:pastie].empty? and x[:pastie][0].strip.start_with?('"') }
      testme = nil
      results = []
      basename = example[:filename]
      next if Conf.skip_examples.member?(basename)
      result = nil
      codeblocks.each.with_index do |codeblock, i|
        pastie = codeblock[:pastie]
        filename = (codeblocks.count > 1) ? "#{basename}_#{i+1}" : basename
        borogove = "v10ex#{example[:example_num]}" + ((codeblocks.count > 1) ? "#{('a'.ord + i).chr}" : '')
        result = { borogove: borogove, filename: filename, title: pastie.first.sub(/\A"/,'').sub(/"\Z/,'') }
        fhash = Hash[ %i{ i7 i6 ulx out }.map {|x| [x, File.join(Conf.xdir, "#{filename}.#{x}") ]}]
        fname = OpenStruct.new(fhash)
        current_content = pastie.join("\n")
        result[:testme] = pastie.find {|l| l.match(/Test me with/)}
        this_xdir = File.join(Conf.example_output_dir, filename)
        FileUtils.mkdir_p(this_xdir)
        result[:quixe] = File.join(this_xdir, 'index.html')
        File.open(fname.i7,'w') {|f| f.puts(current_content) } 
#       write_it = false
#       if 
# #        puts "#{fname.i7} #{File.exist?(fname.i7)} #{File.size(fname.i7)}"
#         existing_content = File.read(fname.i7)
#         if existing_content != current_content
#           puts "#{fname.i7} differs"
#           write_it = true
#         else
#           puts "#{fname.i7} is the same"
#         end
#       else
#         write_it = true
#       end
#       if write_it
#        puts "#{fname.i7} is new"
#   if false
#       if File.mtime(__FILE__) > File.mtime(fname.i7)
#         fhash.values.each {|fi| FileUtils.rm_f(fi) }
#       else
#         suffix_syms.reverse.each_cons(2) do |x|
#           FileUtils.rm_f(fhash[x[1]]) unless File.exist?(fhash[x[0]]) and !File.size(fhash[x[0]]).zero?
#         end
#       end
# #      i7_filename = File.join(Conf.xdir, "#{filename}.i7")
# #      i6_filename = File.join(Conf.xdir, "#{filename}.i6")
# #      ulx_filename = File.join(Conf.xdir, "#{filename}.ulx")
# #      js_filename = File.join(Conf.xdir, "#{filename}.js")
#       File.open(fname.i7, 'w') {|f| f.write(pastie.join("\n")) }
      #      puts "inform7 --transient /tmp -o #{fname.i6} --source #{fname.i7}"
       if false
       stdout, stderr, status = Open3.capture3("inform7 --transient /tmp -o #{fname.i6} --source #{fname.i7}")
      if status.exitstatus.zero?
        if File.exist?(fname.i6) and !File.size(fname.i6).zero?
          stdout, stderr, status = Open3.capture3("inform6 -wE2SDG #{fname.i6} #{fname.ulx}")
          if status.exitstatus.zero?
            if File.exist?(fname.ulx) and !File.size(fname.ulx).zero? and testme
              stdout, stderr, status = Open3.capture3("cheap-git #{fname.ulx}", stdin_data: [ "test me", "quit", "y", "" ].join("\n"))
              if status.exitstatus.zero?
                result[:testme] = stdout
              end
            end
          else
            puts "error in inform6 -wE2SDG #{fname.i6} #{fname.ulx}"
            puts stderr
            puts stdout
          end
        end
      else
        puts "Error in inform7 --transient /tmp -o #{fname.i6} --source #{fname.i7}"
        puts stderr
        puts stdout
        FileUtils.rm_f(fname.i6)
      end
        end
        if File.exist?(fname.ulx) and !File.size(fname.ulx).zero?
          if result[:testme]
            if File.exist?(fname.out) and !File.size(fname.out).zero?
              result[:testme_output] = UTF8.readlines(fname.out)
            else
              testme_input = ((Conf.testme_cmds[basename] or [ "test me", "quit", "y" ]) + ['']).join("\n")
              pp testme_input
              stdout, stderr, status = Open3.capture3("cheap-git #{fname.ulx}", stdin_data: testme_input)
              detection = CharlockHolmes::EncodingDetector.detect(stdout)
              begin
                result[:testme_output] = process_testme(CharlockHolmes::Converter.convert(stdout, detection[:encoding], 'UTF-8').split(/\n/))
                FileUtils.rm(fname.out) if File.exist?(fname.out)
                File.open(fname.out, 'w') {|f| f.puts(result[:testme_output]) } unless result[:testme_output].blank?
              rescue StandardError => e
                puts e.message
              end
              puts stderr unless stderr.blank?
            end
          end
        end
#        result[:testme_output] = process_testme(File.readlines(fname.out)) if File.exist?(fname.out)

# PUT BACK IN when you strip if false
#        I7::Template.write(:quixe, result[:quixe], title: result[:title], interpreter_levels_up: 1, ulxjs: Base64.strict_encode64(File.read(fname.ulx)), ahref: "../#{example[:cname]}.html", link_label: example[:name])
        codeblock[:result] = result
      Conf.examples[example[:cname]] ||= {}
      Conf.examples[example[:cname]][result[:title]] = result 
    end
#  and File.exist?(fname.ulx)
#           #if File.exist?(fname.ulx) and !File.exist?(fname.out)
#           stdout, stderr, status = Open3.capture3("cheap-git #{fname.ulx}", stdin_data: [ "test me", "quit", "y" ].join("\n"))
#           begin
#             testme = stdout.split(/\n/)
#           rescue StandardError => e
#             testme = nil
#             puts e.message
#           end
#           File.open(fname.out, 'w') {|f| f.puts stdout; f.puts stderr } if stdout and stderr
#           puts stderr if stderr and !stderr.empty?
#           this_xdir = File.join(Conf.xdir, filename)
#           FileUtils.mkdir_p(this_xdir)
#           I7::Template.write(:example_quixe, File.join(this_xdir, 'index.html'), title: name, interpreter_levels_up: 1, ulxjs: Base64.strict_encode64(File.read(fname.ulx)))
#         end
#       else
#         puts stdout
#         puts stderr
#       end 
#   end
#     end
# end
    end
end

def place_examples
  [ :wi, :rb ].each do |vol|
    Conf.examples.each_pair do |k,v|
      if !v[:name] or v[:name].empty?
        puts "Empty name for #{k}"
      end
      if !Conf.section_names[vol].key?(v[vol].downcase)
        puts "can't find #{v[vol].downcase} in #{vol}"
      else
        v[:refs][vol] = [vol]+ Conf.section_names[vol][v[vol].downcase]
        chapter_num, section_num = *(Conf.section_names[vol][v[vol].downcase])
        (Conf.books[vol][:chapters][chapter_num][:sections][section_num][:example_keys] ||= []) << k
      end
    end
  end
  example_num = 0
  Conf.books[:wi][:chapters].each_pair do |chapter_num, chapter|
    chapter[:sections].each_pair do |section_num, section|
      section[:examples] = []
      section[:example_keys].map {|k| Conf.examples[k]}.sort_by {|y| [y[:stars], y[:filename].downcase ] }.each do |x|
        example_num += 1
        x[:example_num] = example_num
        Conf.examples_by_num[example_num] = x
        section[:examples] << x
      end
    end
  end
  Conf.books[:rb][:chapters].each_pair do |chapter_num, chapter|
    chapter[:sections].each_pair do |section_num, section|
      section[:examples] = section[:example_keys] ? section[:example_keys].map {|k| Conf.examples[k]}.sort_by {|x| x[:example_num] } : []
    end
  end
end

def print_table(f, codelines)
  return if Conf.table.empty?
  table = []
  Conf.table.each do |row|
    if row.empty?
      table[-1][-1] += "\n"
    else
      table << row
    end
  end
  f.puts '<table>'
  max = Conf.table.map(&:count).max
  table.each do |columns|
    f.print '<tr><td>'
    extra_columns = (max - columns.count)
    columns += ["\xC2\xA0"] * extra_columns if extra_columns > 0 # xA0 = nbsp
    f.print columns.map {|x| htmlify(x, type: :code) }.map {|x| x.strip.gsub(/\n/,'<br>') }.join('</td><td>')
    f.print '</td></tr>'
  end
  f.puts '</table>'
  f.puts %Q{<div class="codeline blankline">&thinsp;</div>} unless codelines.empty?
  Conf[:table] = []
end

def process_testme(lines)
  return nil if lines.blank?
  lines = lines.map(&:rstrip)
  begin
    lines.shift until (lines.empty? or lines.first.match(/\ARelease \d/))
    lines.shift if !lines.empty? and lines.first.match(/\ARelease \d/)
    lines.shift while !lines.empty? and lines.first.strip.blank?
    lines.pop while !lines.empty? and (lines.last.strip.blank? or lines.last == '>' or lines.last.match(/(?:you want to quit|undo the last command|<end of input>)\?\s*\Z/i))
    return lines
  rescue StandardError => e
    pp block[:result]
    puts e.message
    return nil
  end
end


def print_blocks(f, blocks, vol = nil, chapter_num = nil, section_num = nil, monolithic = false, search = false, level: 0)
  testme_output = nil
  testme_block = nil
  target_block = nil
  blocks.each do |block|
    case block[:type]
    when :text
      if block[:content].match(/\S/)
        content = replace_example(block[:content], vol, monolithic, level: level)
        f.puts "<p>#{content}</p>"
      end
    when :code
      if block[:result] and !search
        if block[:result][:borogove]
          f.puts %Q{<div class="play-example borogove"><a class="raw" href="https://snippets.borogove.app/inform7/#{block[:result][:borogove]}">Play/modify in Borogove</a></div>}
        end
        if block[:result][:quixe]
          if File.exist?(block[:result][:quixe])
            f.puts %Q{<div class="play-example quixe"><a class="raw" href="#{block[:result][:filename]}/index.html">Play in Quixe</a></div>}
          end
        end
        f.print '</p>'
        testme_output = block[:result][:testme_output]
        testme_block = block
        target_block = block[:pastie_block]
      end
      f.print '<div class="codeblock"'
      f.print ' id="#{block[:id]"' if block.key?(:id)
      f.print '>'
      if !block[:pastie].empty?
        f.print %Q{<button class="copycode" title="Copy to clipboard" onclick="copyCode(`#{block[:pastie].map {|c| c.gsub(/"/,'&quot;').gsub(/'/,'&apos;').gsub(/\t/,'\\t') }.join('\\n')}`)"><span class="sym">⧉</span></button>}
      end

      # in_table means we have content with internal tabs but not necessarily headed with a "Table of", like in WI 16.11 or in Kyoto example (Throwing.txt)
      # encountered_table_header means we've encountered a "Table of" header
      encountered_table_header = false
      in_table = false
      quotes = 0
      prev_quotes = 0
#      prev_blank = nil
      codelines = block[:code].clone
      idx = -1
      # while loop / shifting instead of looping with 'each' so that we can eat additional lines within the loop in case of still-open quoted texts
      while !codelines.empty?
        codeline = codelines.shift
        idx += 1
        codeline.gsub!(/\A\tcheck\tan actor throwing something at\t/,"check\tan actor throwing something at\t") # special case for example "Kyoto"/Throwing.txt
        codeline.match(/\A(\t*)(.*)/);
        indent = $1.length
        payload = $2
        prev_quotes = quotes
        quotes += payload.scan(/"/).count
        # to catch single-column table case while excluding the repeated table header lines in code block in WI 16.1 
        in_table = true if encountered_table_header and !payload.start_with?('Table')
        if in_table # encountered_table_header
          if prev_quotes.odd?
            q = prev_quotes
            Conf.table[-1][-1] += "\n"
            parts = payload.split(/\t+/)
            while !parts.empty?
              part = parts.shift
              Conf.table[-1][-1] += part
              q+=part.scan(/"/).count
              if q.even?
                Conf.table[-1] += parts unless parts.empty?
                break
              end
            end
            next
          end
          if !payload.match(/\S/) or payload.match(/\A\s*with\s+\d+\s+blank\s+rows/i)
            print_table(f, codelines)
            encountered_table_header = false
            in_table = false
            prev_quotes = quotes = 0
            f.puts %Q{<div class="codeline blankrows">#{payload}</div>} if payload.match(/\A\s*with\s+\d+\s+blank\s+rows/i)
          else
            parts = codeline.split(/\t+/)
            Conf.table << parts
          end
          next
        end
        if payload.match(/\t/) and !payload.blank?
          in_table = true
          Conf.table ||= []
          Conf.table << codeline.split(/\t+/)
          next
        end
        case payload
        when /\A\s*\Z/
          f.puts %Q{<div class="codeline blankline">&thinsp;</div>}
        when /\A(?:Volume|Book|Part|Chapter|Section)/
          f.print %Q{<div class="codeline i7header">#{htmlify(payload, type: :code)}</div>}
        when /\ATable\s+(?:(\d+(?:\.\d+)?)|of\s+(.*))/
          f.print %Q{<div class="codeline tablename">#{htmlify(payload, type: :code)}</div>}
          encountered_table_header = true
          Conf.table = []
          prev_quotes = quotes = 0
        else
          f.puts %Q{<div class="codeline#{((idx.zero? and !block[:pastie].empty? and indent.zero? and payload.start_with?('"')) ? ' storytitle': '')}">}+('&ensp;'*(indent*3))+htmlify(payload, type: :code)+'</div>'
        end
      end
      print_table(f, codelines)
      in_table = false
      quotes = 0
      f.print '</div>'
      if (block == target_block) and testme_output and !search
        f.print %Q{<details class="testme-output"><summary><div class="summation">}
        f.print %Q{#{testme_block[:result][:testme]}}
          f.print %Q{</div></summary><div class="testme-output">}
          f.puts testme_output.map {|x| CGI.escapeHTML(x)}.map {|x| x.match(/\A&gt;/) ? %Q{<span class="mono">#{x}</span>} : x }.join("<br>")
          f.print '</div></details>'
      end
    when :defn
      f.print %Q{<div class="defn" id="#{block[:id]}">}
      Conf.defns[block[:id]][:list].each.with_index do |defn,i|
        f.print '<div class="defnline">'
        f.print phrase_defn(defn[:phrase], "defn", "neutral")
        f.print %Q{ &rArr; <em>#{defn[:result]}</em>} unless defn[:result].empty?
        f.print '</div>'
        f.print('<div class="defn-or">or&hellip;</div>') if i < (Conf.defns[block[:id]][:list].count-1)
      end
    when :end
      f.print '</div>'
    else
      # we shouldn't ever get here.
      f.print "<!-- "
      pp block
      f.print "-->"
    end
    print_table(f, codelines)
  end
end

def example_refs(example, vol, monolithic = false, level: 1)
  lb_vol, lb_chapter, lb_section = *example[:refs][vol]
  target = target_anchor(lb_vol, lb_chapter, lb_section, monolithic)
  target = "##{target}" if monolithic
  return %Q{<a class="raw example-ref" href="#{(['..']*level + [target]).join('/')}" title="#{CGI.escapeHTML(Conf.books[vol][:chapters][lb_chapter][:name])} &gt; #{CGI.escapeHTML(Conf.books[vol][:chapters][lb_chapter][:sections][lb_section][:name])}"><span class="sc">#{Conf.books[vol][:abbrev].downcase}</span>&nbsp;#{[lb_chapter,lb_section].join('.')}</a>}, target, lb_vol, lb_chapter, lb_section
end

def numeric_examples(f, monolithic = false)
  have_printed_chapter = {}
  f.puts '<div class="example-index-table" id="numeric-examples">'
  Conf.books[:wi][:chapters].keys.sort.each do |chapter_num|
    chapter = Conf.books[:wi][:chapters][chapter_num]
    Conf.books[:wi][:chapters][chapter_num][:sections].keys.sort.each do |section_num|
      section = Conf.books[:wi][:chapters][chapter_num][:sections][section_num]
      next if section[:examples].blank?
      unless have_printed_chapter[chapter_num]
        f.puts %Q{<div class="example-index-row"><div class="example-index-cell right"><span class="numeric-index-large">WI #{chapter_num}.</span></div><div class="example-index-cell left">&thinsp;</div><div class="example-index-cell"><a href="#{target_chapter(:wi, chapter_num, level: 1)}"><span class="numeric-index-large">#{chapter[:name]}</span></a></div></div>}
        have_printed_chapter[chapter_num] = true
      end
      ex = section[:examples].sort_by {|x| x[:example_num]}
      dest, label, title = *(target_pair([:wi, chapter_num, section_num], monolithic, "§#{chapter_num}.#{section_num} #{htmlify(section[:name])}"))
#      zeroes = "0"* (3 - section_num.to_s.length)
      f.puts %Q{<div class="example-index-row"><div class="example-index-cell right"><span class="sect">§</span>#{chapter_num}.</div><div class="example-index-cell left">#{section_num}</div><div class="example-index-cell">#{target_pair_link([:wi, chapter_num, section_num], monolithic, htmlify(section[:name]), level: 1)}</div></div>}
      f.puts %Q{<div class="example-index-row"><div class="example-index-cell"></div><div class="example-index-cell"></div><div class="example-index-cell">}
      f.puts %Q{<div class="numeric-example-list">}
      ex.each do |example|
        target = monolithic ? "#example_#{example[:cname]}" : "#{example[:cname]}.html"
        subzeroes = ("0" * (4 - example[:example_num].to_s.length))
        f.puts %Q{<div class="numeric-example-line"><span class="hidden numeric-example">#{subzeroes}</span><span class="numeric-example">#{example[:example_num]}. <a href="#{target}" title="#{CGI.escapeHTML(example[:desc])}">#{htmlify(example[:name])}</a></span> #{sym(:star, example[:stars])} #{example_refs(example, :rb, level: 1).first}</div>}
      end
      f.puts %Q{</div></div></div>}
    end
  end
  f.puts '</div></div>'
end

# to behave as indoc, we should also be looking for '{*}"Example Name"' in the *body* of Writing with Inform and including those
# in the alphabetical index of examples unless it's marked OMIT in (Recipes).txt. That would result in adding "Cave Entrance" and
# "The Undertomb", the latter of which is already there as "The Undertomb 1".
def nominal_examples(f)
  f.puts %Q{<h2>Examples by Name</h2>}# <div class="example-block">}
  alpha_index = {}
  Conf.examples.each do |cname,example|
    alpha_index[example[:name]] = {id: uid, example: example, real: true}
    example[:index_entries].each {|entry| alpha_index[entry] = {id: uid, example: example}}
  end
  letter_index = Hash.new {|h,k| h[k] = '|'}
  alpha_index.keys.each do |k|
    fl = keysort(k)
    char = fl[0]
    letter_index[char] = k if fl < keysort(letter_index[char])
  end

  f.print '<div id="nominal-examples-indexbar" class="indexbar-holder"><div class="indexbar">'
  'a'.upto('z') do |letter|
    f.print letter_index.key?(letter) ? %Q{<div class="indexletter"><a href="#alpha-index-entry-#{alpha_index[letter_index[letter]][:id]}">#{letter.upcase}</a></div>} : letter.upcase
  end
  f.print '</div></div><div class="example-index-table" id="nominal-examples-table">'

  alpha_index.keys.sort_by {|x| x.match(/\A(.*?)(\d+)\Z/) ? [ keysort($1), $2.to_i ] : [keysort(x), 0 ]  }.each do |key|
    example = alpha_index[key][:example]
    f.print %Q{<div class="example-index-row">}
    [:wi, :rb].each do |vol|
      devnull, target, vl, ch, sect = example_refs(example, vol)
#      ch = %Q{<span class="hidden">0</span>#{ch}} if ch.to_s.length < 2
#      sect = %Q{#{sect}<span class="hidden">0</span>} if sect.to_s.length < 2
      #    if (alpha_index[key][:real])
      secretc0= ((ch.to_s.length < 2) ? %Q{<span class="hidden">0</span>} : '')
#      secrets0= ((sect.to_s.length < 2) ? %Q{<span class="hidden">0</span>} : '')
      f.print %Q{<div class="example-index-cell"><div class="example-index-ref"><a class="raw" href="../#{target}"><div class="example-index-cell-part right">#{Conf.books[vol][:abbrev]} #{secretc0}#{ch}.</div><div class="example-index-cell-part left">#{sect}</div></a></div></div>}
    end
    f.print %Q{<div class="example-index-cell"><span class="#{alpha_index[key][:real] ? 'example-index-name' : ''}"><a id="example-example-index-entry-#{alpha_index[key][:id]}" title="#{CGI.escapeHTML(example[:desc])}" href="#{example[:cname]}.html">#{htmlify(key)}#{example[:subtitle].blank? ? '' : ': <span class="example-index-subtitle">'+ example[:subtitle] + '</span>'}</a></span> <span class="sym">#{'★' * example[:stars]}</span></div></div>}
  end
  f.puts '</div>'
end



def html_head(f, title, level: 0)
  f.puts '<!doctype html>'
  f.puts %Q{<html lang="en"><head><meta charset="utf-8">
<title>#{title}</title>
<script src="#{((['..']*level)+['i7doc.js']).join('/')}"></script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Source+Code+Pro:ital,wght@0,375;0,400;0,500;0,700;1,375;1,400;1,500;1,700&family=Source+Sans+Pro:ital,wght@0,350;0,400;0,550;0,700;1,350;1,400;1,550;1,700&display=swap" rel="stylesheet"> 
<link rel="stylesheet" href="#{((['..']*level)+['i7doc.css']).join('/')}">
</head>}
end


def nav(f, page = nil, level: 0)
  f.print '<nav>'
  el = []
  Conf.navpages.each_pair do |k,v|
    el << ((k == page) ? "<strong>#{v[:name]}</strong>" : %Q{<a class="raw nav-el" href="#{((['..']*level)+[v[:dest]]).join('/')}">#{v[:name]}</a>})
  end
  el.each.with_index do|x,i|   f.print %Q{<div class="nav-el}
    f.print %Q{">#{x}</div>}
  end 
  f.puts '</nav>'
end

class Object
  def blank?
    return true if self.nil? or self.empty?
    return false
  end
end

def example_linkback(f, vol, example)
  f.print '<div class="linkback">'
  lb_vol, lb_chapter, lb_section = *example[:refs][vol]
  target = target_anchor(lb_vol, lb_chapter, lb_section)
  f.print %Q{<a href="#{target}" title="#{CGI.escapeHTML(Conf.books[vol][:chapters][lb_chapter][:name])} &gt; #{CGI.escapeHTML(Conf.books[vol][:chapters][lb_chapter][:sections][lb_section][:name])}">#{Conf.books[vol][:abbrev]} #{[lb_chapter, lb_section].join('.')} #{Conf.books[vol][:chapters][lb_chapter][:sections][lb_section][:name]}</a>}
  f.puts '</div>'
end

def output_section_examples(f, vol, examples, monolithic = false)
  linkback_vol = Conf[:books].keys.find {|x| x != vol}
  f.puts '<div class="examples">'
  f.puts %Q{<h4>Example#{(examples.count > 1) ? 's' : ''}</h4>}
  examples.each do |example|
    target = monolithic ? "#example_#{example[:cname]}" : "examples/#{example[:cname]}.html"
    zeroes = 3 - example[:example_num].to_s.length
    f.print %Q{<div class="example-short"><div class="example-short-num"><span class="hidden">#{"0"*zeroes}</span>#{ example[:example_num] }.</div><div class="example-short-name"><span class="example-short-name"><a href="#{target}">#{example[:name]}</a></span> <span class="sym">#{'★' * example[:stars]}</span></div></div>}
    f.puts %Q{<div class="example-short"><div class="example-short-num"><span class="hidden">000.</span></div><div class="example-short-name">#{htmlify(example[:desc])}</div></div>}
    example_linkback(f, linkback_vol, example)
  end
  f.puts('</div>')
end

def output_section(f, vol, chapter_num, section_num, monolithic = false, search: true, level: 0)
  book = Conf.books[vol]
  section = book[:chapters][chapter_num][:sections][section_num]
  f.print %Q{<article><div class="section-title"><div class="section-title-row"><div class="section-title-link"><a class="permalink raw" href="#{target_anchor(vol, chapter_num, section_num)}">&#128279;&ensp;</a></div><h3 class="section-title-header" id="#{monolithic ? target_anchor(vol,chapter_num,section_num, monolithic) : "section_#{section_num}"}">}
  label = %Q{#{book[:abbrev]} <span class="sect-mark">§</span>#{chapter_num}.#{section[:section_num]} #{section[:name]}}
  f.print search ? %Q{<a href="#{target_anchor(vol, chapter_num, section_num)}">#{label}</a>} : label
  f.puts '</h3></div></div>'
  navbar = []
  navbar << %Q{<div class="doc-navbar"><div class="doc-navbar-left">}
  prev = nil
  prev = book[:chapters][chapter_num][:sections][section_num-1] if section_num > 1
  prev ||= book[:chapters][chapter_num-1][:sections][book[:chapters][chapter_num-1][:sections].keys.max] if chapter_num > 1
#  abbr = Conf.books[vol][:abbrev]
  prev ||= Conf.books[:wi][:chapters][Conf.books[:wi][:chapters].keys.max][:sections][Conf.books[:wi][:chapters][Conf.books[:wi][:chapters].keys.max][:sections].keys.max] if vol == :rb
  if !prev.blank?
    abbr = Conf.books[prev[:vol]][:abbrev]
    prefix = ((prev[:vol] == vol) ? '' : "#{Conf.books[Conf.books.keys.find {|x| x != vol}][:abbrev]} ")
    dest = ((prev[:chapter_num] == chapter_num) ? "#section_#{prev[:section_num]}" : "#{abbr}_#{prev[:chapter_num]}.html#section_#{prev[:section_num]}")
    navbar << %Q{<a class="raw nav-el" href="#{dest}" title="#{htmlify(prev[:name])}"><div class="nav-arrow"><span class="sym">#{Conf.syms[:left]}</span>#{prefix}#{prev[:chapter_num]}.#{prev[:section_num]}</div><div class="doc-navbar-text">#{htmlify(prev[:name])}</div></a>}
  else
    navbar << %Q{<div>&thinsp;</div>}
  end
  navbar << '</div>'
  dest = search ? "#{Conf.books[vol][:abbrev]}_#{chapter_num}.html" : "#chapter_#{chapter_num}"
  navbar << %Q{<div class="doc-navbar-center"><a class="raw nav-el" href="#{dest}"><div class="nav-arrow"><span class="sym">#{Conf.syms[:up]}</span>#{chapter_num}.</div><div class="doc-navbar-text">#{book[:chapters][chapter_num][:name]}</div></a></div>}
  navbar << %Q{<div class="doc-navbar-right">}
  if book[:chapters][chapter_num][:sections].key?(section_num+1)
    dest = search ? "#{Conf.books[vol][:abbrev]}_#{chapter_num}.html#section_#{section_num+1}" : "#section_#{section_num+1}"
    navbar << %Q{<a class="raw nav-el" href="#{dest}"><div class="doc-navbar-text">#{book[:chapters][chapter_num][:sections][section_num+1][:name]}</div><div class="nav-arrow">#{chapter_num}.#{section_num+1}<span class="sym">#{Conf.syms[:right]}</span></div></a></div>}
  elsif book[:chapters].key?(chapter_num+1)
    dest = "#{Conf.books[vol][:abbrev]}_#{chapter_num+1}.html"
    ch_name = htmlify(book[:chapters][chapter_num+1][:name])
    navbar << %Q{<a class="raw nav-el" href="#{dest}" title="#{ch_name}"><div class="doc-navbar-text">#{ch_name}</div><div class="nav-arrow">#{chapter_num+1}.<span class="sym">#{Conf.syms[:right]}</span></div></a></div>}
  elsif vol == :wi
    dest = "#{Conf.books[:rb][:abbrev]}_1.html"
    ch_name = htmlify(Conf.books[:rb][:chapters][1][:name])
    navbar << %Q{<a class="raw nav-el" href="#{dest}" title="#{ch_name}"><div class="doc-navbar-text">#{ch_name}</div><div class="nav-arrow">RB 1.<span class="sym">#{Conf.syms[:right]}</span></div></a></div>}
  else
    navbar << %Q{<div class="doc-navbar-text finit">Finit</div>}
  end
  navbar << %Q{</div></div>}
  f.puts(navbar.join(''))
  
  print_blocks(f, section[:blocks], vol, chapter_num, section_num, monolithic, level: 0)
  if !section[:see].blank?
    f.puts '<div class="see-also">'
    f.puts '<h4>See Also</h4>'
    f.print '<p>'
    section[:see].each do |see|
      ch, sect = *Conf.section_names[vol][see[0].downcase]
      target = target_anchor(vol, ch, sect, monolithic)
      target = "##{target}" if monolithic
      f.print %Q{<a href="#{target}" title="#{CGI.escapeHTML(Conf.books[vol][:chapters][ch][:name])} &gt; #{CGI.escapeHTML(Conf.books[vol][:chapters][ch][:sections][sect][:name])}">#{see[0]}</a> #{see[1]}<br>}
    end
    f.print '</p>'
    f.print '</div>'
  end
  if !section[:examples].blank?
    if (:rb == vol) and search
      f.puts %Q{<h4>Example#{(section[:examples].count > 1) ? 's' : ''}</h4>}
      section[:examples].sort_by {|x|  [x[:stars], x[:example_num] ]}.each do |example|
        f.print %Q{<p><span class="example-name">#{ example[:example_num] }. <a href="examples/#{example[:cname]}.html" class="example-name">#{CGI.escapeHTML(example[:name])}</a></span> #{'★'  * example[:stars]}</p>}
        print_blocks(f, example[:body][:blocks], nil, nil, nil, nil, true)
        f.puts '<div class="linkback">'
        f.puts (%i{ wi rb }.map do |vol|
                  lb_vol, lb_chapter, lb_section = *example[:refs][vol]
                  target = target_anchor(lb_vol, lb_chapter, lb_section, monolithic)
                  target = "##{target}" if monolithic
                  %Q{<a href="#{target}" title="#{CGI.escapeHTML(Conf.books[vol][:chapters][lb_chapter][:name])} &gt; #{CGI.escapeHTML(Conf.books[vol][:chapters][lb_chapter][:sections][lb_section][:name])}"><span class="sc">#{Conf.books[vol][:abbrev].downcase}</span>&nbsp;#{[lb_chapter, lb_section].join('.')} #{Conf.books[vol][:chapters][lb_chapter][:sections][lb_section][:name]}</a>}
                end).join('<br>')
        f.puts '</div>'
      end
    else
      output_section_examples(f, vol, ((vol == :rb) ? section[:examples].sort_by {|x|  [x[:stars], x[:example_num] ]} : section[:examples]))
    end
  end
  f.puts '</article>'
end

def output_examples(monolithic = false)
  FileUtils.mkdir_p(Conf.example_output_dir)
  File.open(File.join(Conf.example_output_dir, 'index.html'), 'w') do |f|
    html_head(f, "Examples", level: 1)
    f.puts %Q{<body id="example-index">}
    f.puts '<header>'
    nav(f, :examples, level: 1)
    f.puts '<div class="superheading"><div class="heading"><h1>Examples</h1></div></div></header>'
    f.puts '<main><div id="nominal-example-jump"><a href="#nominal-examples-indexbar">Examples by Name</a></div></div>'
    f.puts '<h2>Numeric Index of Examples</h2>'
    numeric_examples(f)
    nominal_examples(f)
    footer(f, level: 1, page: :examples)
    f.puts %Q{</main></body></html>}
  end
  Conf.examples.each do |cname, example|
    File.open(File.join(Conf.example_output_dir, "#{cname}.html"), 'w') do |f|
      html_head(f, "Ex. #{example[:example_num]}. #{example[:name]}", level: 1)
      f.puts %Q{<body><main>}
      f.puts %Q{<header class="example-header">}
      nav(f, level: 1)
      f.puts %Q{<div class="superheading"><div class="heading"><h1>#{example[:name]}</h1><div class="subheading">#{example[:subtitle] ? (example[:subtitle]+'<br>') : ''}<wbr><div class="ex-no">Example #{example[:example_num]}</div> #{'★'  * example[:stars]}</div></div>}
      linkbacks = {}
      %i{ wi rb }.each do |vol|
        lb_vol, lb_chapter, lb_section = *example[:refs][vol]
        target = target_anchor(lb_vol, lb_chapter, lb_section, monolithic)
        target = "##{target}" if monolithic
        if vol == :wi
          guts = %Q{<div class="nav-arrow"><span class="sc">#{Conf.books[vol][:abbrev].downcase}</span>&nbsp;#{[lb_chapter, lb_section].join('.')}</div><div class="doc-navbar-text">#{Conf.books[vol][:chapters][lb_chapter][:sections][lb_section][:name]}</div>}
        else # vol == :rb
          guts = %Q{<div class="doc-navbar-text">#{Conf.books[vol][:chapters][lb_chapter][:sections][lb_section][:name]}</div><div class="nav-arrow"><span class="sc">#{Conf.books[vol][:abbrev].downcase}</span>&nbsp;#{[lb_chapter, lb_section].join('.')}</div>}
        end
        linkbacks[vol] = %Q{<a class="raw nav-el" href="../#{target}" title="#{CGI.escapeHTML(Conf.books[vol][:chapters][lb_chapter][:name])} &gt; #{CGI.escapeHTML(Conf.books[vol][:chapters][lb_chapter][:sections][lb_section][:name])}">#{guts}</a>}
      end
      f.puts %Q{<div class="doc-navbar example-linkback"><div class="doc-navbar-left">#{linkbacks[:wi]}</div><div class="doc-navbar-right">#{linkbacks[:rb]}</div></div>}

      f.puts %Q{</div>}
      f.puts %Q{<div class="example-meta-desc"><p>#{htmlify(example[:desc])}</p></div>}
                                                                           
      example_link_rows = Hash.new {|h,k| h[k] = {} }
      if example[:subname]
        example_link_rows[0][:left] = Conf.subnames[example[:subname]][example[:subnum]-1] if example[:subnum] > 1
        example_link_rows[0][:right] = Conf.subnames[example[:subname]][example[:subnum]+1] if Conf.subnames[example[:subname]][example[:subnum]+1]
      end
      example_link_rows[1][:left] = Conf.examples_by_num[example[:example_num]-1] if example[:example_num] > 1
      example_link_rows[1][:right] = Conf.examples_by_num[example[:example_num]+1] if Conf.examples_by_num.key?(example[:example_num] + 1)
      finit = !(Conf.examples_by_num.key?(example[:example_num] + 1))
      navbar = []
      if !example_link_rows[0].blank? and !example_link_rows[1].blank?
        [:left,:right].each {|i| example_link_rows[0].delete(i) if example_link_rows[0].key?(i) and example_link_rows[1].key?(i) and (example_link_rows[1][i] == example_link_rows[0][i]) }
      end

      example_link_rows.values.each.with_index(1) do |row,i|
        next unless row.key?(:left) or row.key?(:right)
        navbar << %Q{<div class="doc-navbar">}
        [:left,:right].each do |side|
          navbar << %Q{<div class="doc-navbar-#{side}">}
          if row.key?(side)
            navbar << %Q{<a class="raw nav-el" href="#{row[side][:cname]}.html" title="#{htmlify(row[side][:desc])}">}
            navbar << ((:left == side) ? %Q{<div class="nav-arrow">#{Conf.syms[:left]}#{row[side][:example_num]}. </div><div class="doc-navbar-text">#{row[side][:name]}</div>} : %Q{<div class="doc-navbar-text">#{row[side][:name]}</div><div class="nav-arrow">#{row[side][:example_num]}.#{Conf.syms[:right]}</div>})
            navbar << '</a>'
          end
          navbar << '<span class="finit">Finit</span>' if finit and (:right == side) and (i == (example_link_rows.count-1))
          navbar << '</div>' 
        end
        navbar << '</div>'
      end
      f.puts navbar.join('')
      
      f.puts '</header>'
      f.print '<div class="example-body">'
      print_blocks(f, example[:body][:blocks], level: 1)
      f.print '</div>'
      f.puts navbar.join('')
      f.print '</main>'
      footer(f, level: 1)
      f.puts '</body></html>'
    end
  end
end

def output_chapter_toc(f, vol, chapter)
  chapter_num = chapter[:chapter_num]
  f.puts %Q{<div class="section-block">}
  chapter[:sections].keys.sort_by(&:to_i).each do |section_num|
    f.puts %Q{<div class="section-row">}
    section = chapter[:sections][section_num]
    f.puts %Q{<div class="section-chapter-num"><span class="sect-mark">§</span>#{chapter_num}.</div><div class="section-section-num">#{section_num}</div><div class="section-name-holder"><div class="section-name"><a href="#{target_anchor(vol, chapter_num, section_num)}">#{section[:name]}</a></div></div>}
    f.puts '</div>'
  end
  f.puts "</div>"
end

#<h1 class="title">I<span style="letter-spacing: -.3rem;">nf</span>orm</h1>
#<div class="subtitle">A <span style="letter-spacing: -.1rem;">De</span>sign <span style="letter-spacing: -.1rem;">Sy</span><span style="letter-spacing: -.05rem;"></span>stem <span style="letter-spacing: -.075rem;">f</span>or Inte<span style="letter-spacing: -.05rem;">rac</span>tive <span style="letter-spacing: -.15rem;">F</span>iction</div></div>}


def output_toc(monolithic = false)
  title = "Inform 7 v10 documentation"
  filename = File.join(Conf.output_dir, "index.html")
  File.open(filename,'w') do |f|
    html_head(f, title)
    f.puts %Q{<body class="toc"><header class="toc-er">}
    nav(f, :toc)
    f.puts %Q{<div class="superheading" id="toc-superheading">}
    f.puts %Q{<div class="heading" id="toc-heading">}
    f.puts %Q{<h1 class="title">In<span style="letter-spacing: -.15rem;">f</span>orm</h1><div class="subtitle">A <span style="letter-spacing: -.075rem;">D</span>esign <span style="letter-spacing: -.04rem;">S</span><span style="letter-spacing: -.1rem;">y</span>stem <span style="letter-spacing: -.075rem;">f</span>or I<span style="letter-spacing: -.1rem;">n</span>teractive <span style="letter-spacing: -.09rem;">F</span>iction</div>}
f.puts %Q{</div></div>}
    f.puts %Q{</header><main class="toc"><div class="toc">} # <div class="toc-row">}
    Conf.books.each_pair do |vol,book|
      f.puts %Q{<div class="toc-vol" id="#{vol}"><div class="vol-contents">}
      f.puts "<h2>#{book[:title]}</h2>"
      book[:chapters].keys.sort_by(&:to_i).each do |chapter_num|
        chapter = book[:chapters][chapter_num]
        f.puts %Q{<details class="chapter-details"><summary class="toc-chapter"><span class="chapter-num">#{chapter_num}.</span> <span class="chapter-name">#{chapter[:name]}</span></summary>}
        f.puts %Q{<div class="section-block">}
        chapter[:sections].keys.sort_by(&:to_i).each do |section_num|
          f.puts %Q{<div class="section-row">}
          section = chapter[:sections][section_num]
          f.puts %Q{<div class="section-chapter-num"><span class="sect-mark">§</span>#{chapter_num}.</div><div class="section-section-num">#{section_num}</div><div class="section-name-holder"><div class="section-name"><a href="#{target_anchor(vol, chapter_num, section_num)}">#{section[:name]}</a></div></div>}
          f.puts '</div>'
          if (:rb == vol)
            if !section[:examples].empty?
              f.print %Q{<div class="section-row"><div class="section-chapter-num">&nbsp;</div><div class="section-section-num">&nbsp;</div><div class="section-name-holder"><div class="section-name section-example-name">}
              f.puts '<div class="thematic-examples">'
              section[:examples].each do |example|
                cname = example[:cname]
                target = (monolithic ? "#example_#{cname}" : "examples/#{cname}.html")
                f.puts %Q{<span class="section-example-name"><a href="#{target}" onClick="(function() { document.getElementById('example_#{example[:cname]}').setAttribute('open','open'); return true; })();" title="#{CGI.escapeHTML(example[:desc])}">#{example[:name]}</a></span>}
              end
              f.puts '</div></div></div></div>'
            end
          end
        end
        f.puts '</div></details>'
      end
      f.puts '</div></div></div>'
    end
    f.puts '</div></main>'
    f.puts '<div class="i7prog"><h2><a class="raw" href="i7prog/index.html">Inform 7 for Programmers (for 8.5/6G60) by Ron Newcomb</a></h2></div>'
    footer(f, css: "toc-er", page: :toc)
    f.puts '</body></html>'
  end
  
end

def output_search
  File.open(File.join(Conf.output_dir, Conf.navpages[:search][:dest]), 'w') do |f|
    html_head(f, "Inform 7 v10 Docs Search") 
    f.puts %Q{<body><header>#{nav(f, :search)}}
    f.puts %Q{<p class="search">The whole text of the documentation to be searched within your browser. The links jump back to the pages per chapter/example.</p>}
    Conf.books.each_pair do |vol,book|
      f.puts %Q{<div class="superheading"><div class="heading"><h1>#{book[:title]}</h1></div></div>}
      f.puts '</header>'
      book[:chapters].keys.sort_by(&:to_i).each do |chapter_num|
        chapter = book[:chapters][chapter_num]
        output_chapter(f, vol, chapter_num, search: true)
      end
    end
    footer(f, page: :search)
    f.puts %Q{</body></html>}
  end
end


def output_chapters
  Conf.books.each_pair do |vol,book|
    book[:chapters].keys.sort_by(&:to_i).each do |chapter_num|
      chapter = book[:chapters][chapter_num]
      filename = File.join(Conf.output_dir,"#{book[:abbrev]}_#{chapter_num}.html")
      File.open(filename, 'w') do |f|
        output_chapter(f, vol, chapter_num)
      footer(f)
      f.puts %Q{</body></html>}
      end
    end
  end
end

def output_chapter(f, vol, chapter_num, monolithic = false, search: false)
  book = Conf.books[vol]
    chapter = book[:chapters][chapter_num]
    title = "#{chapter_num}. #{chapter[:name]}"
    if search
      f.print %Q{<header><h2><a href="#{book[:abbrev]}_#{chapter_num}.html">#{title}</a></h2></header>}
    else
      html_head(f, "#{book[:abbrev]} #{title}") 
      f.puts %Q{<body><header>#{nav(f)}<div class="superheading"><div class="heading">
<h1 id="chapter_#{chapter_num}">#{title}</h1>
<div class="subheading">#{book[:title]}</div></div></div></header>}
    end
    f.puts %Q{<main><section>}
    navbar = []
    navbar << %Q{<div class="doc-navbar"><div class="doc-navbar-left">}
    if chapter_num > 1
      navbar << %Q{<a class="raw nav-el" href="#{book[:abbrev]}_#{chapter_num-1}.html"><div class="nav-arrow">#{Conf.syms[:left]}#{chapter_num-1}.</div><div class="doc-navbar-text">#{book[:chapters][chapter_num-1][:name]}</div></a>}
    elsif :rb == vol
      last_ch = Conf.books[:wi][:chapters][Conf.books[:wi][:chapters].keys.max]
      dest = "#{Conf.books[:wi][:abbrev]}_#{last_ch[:chapter_num]}.html"
      ch_name = htmlify(last_ch[:name])
      navbar << %Q{<a class="raw nav-el" href="#{dest}" title="#{ch_name}"><div class="nav-arrow">#{Conf.syms[:left]}WI #{last_ch[:chapter_num]}.</div><div class="doc-navbar-text">#{ch_name}</div></a>}
    else
      navbar << %Q{<span class="hidden">0</span>}
    end
    navbar << '</div>'
#    navbar << %Q{<div class="doc-navbar-center"><div class="raw nav-el"><span class="hidden">0</span></div></div>}
    navbar << %Q{<div class="doc-navbar-right">}
    if book[:chapters].key?(chapter_num+1) 
        navbar << %Q{<a class="raw nav-el" href="#{book[:abbrev]}_#{chapter_num+1}.html"><div class="doc-navbar-text">#{book[:chapters][chapter_num+1][:name]}</div> <div class="nav-arrow">#{chapter_num+1}.#{Conf.syms[:right]}</div></a>}
    elsif :wi == vol
      dest = "#{Conf.books[:rb][:abbrev]}_1.html"
      ch_name = htmlify(Conf.books[:rb][:chapters][1][:name])
      navbar << %Q{<a class="raw nav-el" href="#{dest}" title="#{ch_name}"><div class="doc-navbar-text">#{ch_name}</div><div class="nav-arrow">RB 1.#{Conf.syms[:right]}</div></a></div>}
    else
      navbar << %Q{<div class="finit">Finit</div>}
    end
    navbar <<  %Q{</div></div>}
    f.puts navbar.join('')
    output_chapter_toc(f, vol, chapter)
    chapter[:sections].keys.sort_by(&:to_i).each do |section_num|
      output_section(f, vol, chapter_num, section_num, monolithic, search: search, level: 0)
    end
    f.puts '</section>'
    f.puts navbar.join('')
    f.puts '</main>'
end

def output_about
  File.open(File.join(Conf.output_dir,"about.html"), 'w') do |f|
    title = "About this edition"
    html_head(f, title)
    f.puts '<header>'
    nav(f)
    f.puts %Q{<div class="superheading"><div class="heading"><h1 id="about-edition">#{title}</h1></div></div></header>}
    f.puts %Q{<main>}
    f.puts %Q{<p>Code examples can be copied to the clipboard by selecting the <span class="sym">⧉</span> icon in the upper-right hand corner of most code blocks. (Sometimes the code copied will include some of the subsequent code blocks, following the source material's behavior.)</p>}
    f.puts %Q{<div class="codeblock" id="about_example_copycode">}
    f.puts %Q{<button class="copycode" title="Copy to clipboard" onclick="copyCode('Copy me');"><span class="sym">⧉</span></button>}
    f.puts %Q{<div class="codeline">Copy me</div></div>}
    f.puts %Q{<p>Most code samples will <em>not</em> work if you select text and copy-paste: it will be missing tab characters that are significant to Inform. Use the copy button.</p>}
    f.puts %Q{<p><em>Writing with Inform</em>, <em>The Inform Recipe Book</em>, and the documentation examples are a part of the distribution of <a href="http://inform7.com">Inform 7</a> by Graham Nelson. For descriptions of them, see <a href="WI_1.html#section_1">Writing with Inform's Preface</a>, <a href="RB_1.html#section_1">The Recipe Book's Preface</a>, and <a href="about_the_examples.html">About the Examples</a>. For more detailed credits, see <a href="WI_1.html#section_2">Writing with Inform's Acknowledgements</a> and <a href="RB_1.html#section_2">the Recipe Book's Acknowledgements</a>.</p>}
    f.print %Q{<p>Thanks go to <a href="http://nitku.net/blog/">Juhana Leinonen</a> for <a href="https://borogove.app">Borogove</a>. The playable examples use <a href="https://eblong.com">Andrew Plotkin</a>'s <a href="https://eblong.com/zarf/glk/glkote.html">GlkOte</a> and <a href="https://eblong.com/zarf/glulx/quixe/index.html">Quixe</a>, distributed under an <a href="mit.html">MIT License.</a> The Quixe pages are offered in case one's off-line with a local copy of this edition; there isn't otherwise any reason to prefer them to the Borogove links. (Borogove itself uses Quixe).</p>}
    f.puts %Q{<p>A few examples lack Borogove/Quixe links because they're Z-machine only or their purpose is to write an EPS file to the project's materials dir and there's no suitable way to demonstrate them.</p>}
    f.puts %Q{<p>Sections 1.3-1.7 of Writing with Inform as presented here omit some details particular to individual platforms. You should check them within the Inform app itself to see the appropriate platform-specific content.</p>}
    f.puts %Q{<p>This edition was reformatted by <a href="http://zedlopez.org">Zed Lopez</a>; it has been modestly adapted to suit the format changes, with my apologies for any errors I may have introduced.</p>}
    f.puts '</main>'
    footer(f, false, page: :about)
    f.puts"</body></html>"
  end
end

#    f.puts '<h2 class="colophon">Colophon</h2>'
    
def output_general_index(monolithic = false)
  File.open(File.join(Conf.output_dir, 'general_index.html'), 'w') do |f|
    title = 'General Index'
    html_head(f, title)
    f.puts %Q{<body><header>}
    nav(f, :general_index)
    f.puts %Q{<div class="superheading"><div class="heading"><h1>#{title}</h1></div></div>}
    f.puts %Q{</header><main id="general-index-page">}
    print_index(f, monolithic)
    f.puts '</main>'
    footer(f, page: :general_index)
    f.puts"</body></html>"
  end
end

def footer(f, about = true, css: nil, level: 0, page: nil)
  f.print '<footer id="credits-footer"'
  f.print %Q{ class="#{css}"} if css
  f.print '>'
  nav(f, page, level: level)
  f.print %Q{<div class="footing"><p id="i7credit"><a href="http://inform7.com">Inform 7</a> and its documentation are &copy; 2006-<span id="current_year">2022</span> by Graham Nelson and published under the <a href="#{((['..']*level)+['license.html']).join('/')}">Artistic License 2.0</a>.</p>}
  f.print %Q{<p>Thanks go to <a href="http://nitku.net/blog/">Juhana Leinonen</a> for <a href="https://borogove.app">Borogove</a>. The playable examples use <a href="https://eblong.com">Andrew Plotkin</a>'s <a href="https://eblong.com/zarf/glk/glkote.html">GlkOte</a> and <a href="https://eblong.com/zarf/glulx/quixe/index.html">Quixe</a>, distributed under an <a href="#{((['..']*level)+['mit.html']).join('/')}">MIT License.</a></p>} if page == :example
  about_html = (about ? %Q{<a class="raw" href="#{((['..']*level)+['about.html']).join('/')}">About this edition</a>&ensp;&bull;&ensp;} : '')
    f.print %Q{<p class="about">#{about_html}<a class="raw" href="https://mastodon.gamedev.place/web/@inform7tips">@inform7tips@mastodon.gamedev.place</a></p></div>}
  f.puts "</footer>"
end


def write_borogove
  result = Hash.new {|h,k| h[k] = {
                       "compiler": "10.1.0",
                                   "created": "2022-08-27T14:25:06.439Z",
                                   "language": "inform7",
                                   "revision": 1,
                                   "template": "inform7" } }
  Conf.examples.each do |cname, title|
    Conf.examples[cname][title].each do |i7|
      i7.each do |h|
        result[h[:borogove]]['code'] = UTF8.read(File.join(Conf.xdir,"#{h[:filename]}.i7"))
      end
    end
  end
  File.open('borogove.json','w') {|f| f.puts(result.to_json) }
end

def read_indoc
  UTF8.read(File.join(Conf.doc_dir, "indoc-instructions.txt")).each_line do |line|
    line.strip!
    case line
    when /volume:\s+([^\(]+)\s*(?:\(([^\)]+)\)\s+=\s+(.*))?/
      title = $1
      abbrev_raw = ($2 || title.chars.select { |x| /[[:upper:]]/.match(x) }.join).downcase
      filename = $3 || "#{title}.txt"
      Conf.volumes[abbrev_raw.to_sym] = { title: title, abbrev: abbrev_raw.upcase, filename: filename }
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
      
      $catmap[cat] = $1 if !modlist.empty? and modlist.first.match(/\A"([^"]+)"\Z/)
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
        $rhash[%r{\A#{rawentry.sub(/headword/,'([^}\+]+)')}}] = cat
                                                              $cat_hash[cat] = modhash
        else
          puts "@@#{line}"
                                                              end
                                                              
                                                              end
                                                              end
                                                              $cat_hash['command'][:label] = 'command'
                                                              end

                                                              configure
                                                              read_indoc
                                                              first_pass
                                                              index_see
                                                              scan_recipes
                                                              read_examples
                                                              place_examples
                                                              run_examples
                                                              # write_borogove
                                                              prepare_output_dir


                                                              output_toc
                                                              output_about
                                                              output_chapters
                                                              output_examples
                                                              output_general_index
                                                              output_search

__END__
