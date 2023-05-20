#!/usr/bin/env ruby

# html -> markdown


#TODO
# lists
# addenda
# sidebar
# sup
# span anchor
# html entities -- suppress automatic conversion by .content
# game_output
# markup within linktext
# negative examples of whitespace requirements!

require 'nokogiri'

lines = ARGF.to_a
#lines.unshift('<html>')
#lines.push('</html>')
doc = Nokogiri::HTML5.fragment(lines.join, 'utf-8')#, Nokogiri::XML::ParseOptions::NOENT)

$divs_to_pass = %w{addendum sidebar}

# def within(node, klass)
#   begin 
#   x = node.parent 
#   while x
#     return true if x.attr(:class) == klass
#     x = x.parent
#   end
#   return false
#   rescue
#     return false
#   end
# end

def traverse(node)
  node.children.each do |child|
    if child.element?
      next if child.name == "button"
      next if child.attr(:class) == "add-header"
      if child.name.match(/h(\d+)/)
        print "#" * ($1.to_i - 1)
        print " "
      elsif child.name == "div"
        puts "```" if child.attr(:class) == "codeblock"
#        puts %Q{{::options parse_block_html="false" /}} if child.attr(:class) == "game-output"
        puts %Q{<div class="#{child.attr(:class)}">} if $divs_to_pass.member?(child.attr(:class))
      elsif child.name == "b" or child.name == "strong"
        print "**"
      elsif child.name == "i" or child.name == "em"
        print "*"
      # deliberately don't handle a-tags
      end
      if child.attr(:class) == "game-output"
        print child.inner_html.sub(/\A\n*/,'').gsub(/\n+/,"\n")
      else
        traverse(child)
      end
    elsif child.text?
      content = child.content.to_s
      newline = (content.end_with?("\n") ? "\n" : "")
      indent = 0
      if content.start_with?("\u2002")
        orig = content.length
        content.gsub!(/ /,'') # ensp
        indent = (orig - content.length) / 3
      end
      if child.parent.attr(:class) == "codeline"
        content = "" if content.length > 0 and content[0].ord == 8201
        print "\t" * indent
        print content
        print newline
      elsif child.parent.name == "a"
        print "[#{content}](#{child.parent.attr(:href)})"
      else
        print content
      end
    end
    if $divs_to_pass.member?(child.attr(:class))
      puts ((child.attr(:class) == "game-output") ? "\n</blockquote>" : "\n</div>")
    elsif child.attr(:class) == "codeblock"
      puts unless child.children.last and child.children.last.text? and child.children.last.content.match(/\n\Z/)
      puts "```"
    end
    puts %Q{{::options parse_block_html="false" /}} if child.attr(:class) == "game-output"
    print "*" if child.name == "i" or child.name == "em"
    print "**" if child.name == "b" or child.name == "strong"
  end
end

traverse(doc)
