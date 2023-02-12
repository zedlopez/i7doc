#!/usr/bin/env ruby

require 'nokogiri'

lines = ARGF.to_a
doc = Nokogiri::HTML5.fragment(lines.join, 'utf-8')

$divs_to_pass = %w{addendum sidebar game-output}

def traverse(node)
  node.children.each do |child|
    if child.element?
      #      child_lines = child.to_s.split("\n")
      next if child.name == "button"
      if child.name == "div" and child.attr(:class) == "codeline"
        content = child.content.gsub(/\u2009/,'')
        if content.empty?
          print ""
        else
          indent = 0
          if content.start_with?("\u2002")
            orig = content.length
            content.gsub!(/ /,'') # ensp
            indent = (orig - content.length) / 3
          end
          print "\t" * indent
          print content.chomp
        end
      elsif child.name == "div" and child.attr(:class) == "codeblock"
        puts %Q{<pre><code>}
        traverse(child)
        puts %Q{</code></pre>}
      elsif child.name == "div" and child.attr(:class) == "game-output"
#        puts %Q{{::options parse_block_html="false" /}} 
        puts %Q{<blockquote>} # class="game-output">}
        child.children.each do |grandkid|
          if grandkid.element? and grandkid.name == "div" and grandkid.attr(:class) == "command"
            content = grandkid.children.last
            puts "<br>\n" unless grandkid == child.first_element_child
            puts %Q{<span class="command">#{content}</span><br>}
          elsif grandkid.element? and grandkid.name == "p"
#            print "<p>"
            print grandkid.attr(:class) == "bold" ? %Q{<strong>#{grandkid.inner_html}</strong>} : grandkid.inner_html.gsub(/\n/,' ')
          #            puts "</p>\n"
            puts "<br>"
          else
            print grandkid.to_html unless grandkid.text? and !grandkid.content.match(/\S/)
          end
        end
        print "</blockquote>"
      else
        print child.to_html
      end
 #       puts child_lines[0]
 #       traverse(child)
 #       puts %Q{</#{child.name}>}
#      end
    elsif child.text?
      print child.content
    end
  end
end

traverse(doc)
