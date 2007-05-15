# !/arch/unix/bin/ruby

require 'rexml/document'
include REXML

file = File.new('aircrafts/index.xml')
doc = Document.new file

doc.elements.each('deck/aircraft') { |element|
  nation = element.attributes['nation']
  image = element.attributes['image']
  
  if(nation.eql?('Japan') or nation.eql?('Germany') or nation .eql('Italy'))
    nation = "axis"
  elsif(element.attributes['category'] == 'bomber')
    nation = "allies":q!
  end

  if(element.attributes['nation'] == 'axis')
    nation = axis
  elsif(element.attributes['nation'] == 'allies')
    nation = allies
  end
}
