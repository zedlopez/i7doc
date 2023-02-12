#!/usr/bin/env ruby

require 'nokogiri'

lines = ARGF.to_a
doc = Nokogiri::HTML5.fragment(lines.join, 'utf-8')

$divs_to_pass = %w{addendum sidebar game-output}

def traverse(node)
  node.children.each do |child|
    if child.element?
#      child_lines = child.to_s.split("\n")
      if child.name == "div" and child.attr(:class) == "game-output"
        puts %Q{<div class="game-output">}
        child.children.each do |grandkid|
          if grandkid.element? and grandkid.name == "div" and grandkid.attr(:class) == "command"
            content = grandkid.children.last
            print %Q{<p><span class="command">#{content}</span></p>\n}
          elsif grandkid.element? and grandkid.name == "p"
            print "<p>"
            print grandkid.attr(:class) == "bold" ? %Q{<span class="bold">#{grandkid.inner_html}</span>} : grandkid.inner_html.gsub(/\n/,' ')
            puts "</p>\n"
          else
            print grandkid.to_html unless grandkid.text? and !grandkid.content.match(/\S/)
          end
        end
        print "</div>"
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
