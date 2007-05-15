# !/arch/unix/bin/ruby

# xmlhelper_tests.rb
# Tests cases for XMLHelper.rb

# Required files
require 'test/unit'
require 'code/xmlhelper.rb'

class TestXMLHelper < Test::Unit::TestCase
  def setup
    allies = Allies.new
    axis = Axis.new
    fighter = Fighter.new
    bomber = Bomber.new

    @air1 = Aircraft.new(Image.new("question.gif"), "Baku Geki KI-99", axis, bomber, 1)
    @air2 = Aircraft.new(Image.new("question.gif"), "Baku Geki KI-99", axis, bomber, 2)
    @air3 = Aircraft.new(Image.new("question.gif"), "Baku Geki KI-99", axis, bomber, 3)
    @air4 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", allies, fighter, 1)
    @air5 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", allies, fighter, 2)
    @air6 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", allies, fighter, 3)
    @air7 = Aircraft.new(Image.new("Dornier Do 26.gif"), "Dornier Do 26", axis, bomber, 1)
    @air8 = Aircraft.new(Image.new("Dornier Do 26.gif"), "Dornier Do 26", axis, bomber, 2)
    @air9 = Aircraft.new(Image.new("Dornier Do 26.gif"), "Dornier Do 26", axis, bomber, 3)
    @air10 = Aircraft.new(Image.new("Brewster F2A-3.gif"), "Brewster F2A-3", allies, fighter, 1)
    @air11 = Aircraft.new(Image.new("Brewster F2A-3.gif"), "Brewster F2A-3", allies, fighter, 2)
    @air12 = Aircraft.new(Image.new("Brewster F2A-3.gif"), "Brewster F2A-3", allies, fighter, 3)
    @air13 = Aircraft.new(Image.new("Curtiss P-40E.gif"), "Curtiss P-40E", allies, fighter, 1)
    @air14 = Aircraft.new(Image.new("Curtiss P-40E.gif"), "Curtiss P-40E", allies, fighter, 2)
    @air15 = Aircraft.new(Image.new("Curtiss P-40E.gif"), "Curtiss P-40E", allies, fighter, 3)
    @air16 = Aircraft.new(Image.new("Messerschmitt ME-109"), "Messerschmitt ME-109", axis, fighter, 1)
    @air17 = Aircraft.new(Image.new("Messerschmitt ME-109"), "Messerschmitt ME-109", axis, fighter, 2)
    @air18 = Aircraft.new(Image.new("Messerschmitt ME-109"), "Messerschmitt ME-109", axis, fighter, 3)
    @air19 = Aircraft.new(Image.new("Vickers Wellington"), "Vickers Wellington", allies, bomber, 1)
    @air20 = Aircraft.new(Image.new("Vickers Wellington"), "Vickers Wellington", allies, bomber, 2)
    @air21 = Aircraft.new(Image.new("Vickers Wellington"), "Vickers Wellington", allies, bomber, 3)
    @keep1 = Keepem.new(Image.new("keepem.gif"), 1)
    @keep2 = Keepem.new(Image.new("keepem.gif"), 2)
    @keep3 = Keepem.new(Image.new("keepem.gif"), 3)
    @keep4 = Keepem.new(Image.new("keepem.gif"), 4)
    @keep5 = Keepem.new(Image.new("keepem.gif"), 5)
    @keep6 = Keepem.new(Image.new("keepem.gif"), 6)
    @vic1 = Victory.new(Image.new("victory.gif"))
  end

  def test_xml_okay?
    okay = Document.new
    okay.add_element "OKAY"
    not_okay = Document.new
    not_okay.add_element "NOTOKAY"
    
    assert(XMLHelper.xml_okay?(okay))
    assert(!XMLHelper.xml_okay?(not_okay))
  end

  def test_boolean_to_xml
    ex_true = Document.new
    ex_true.add_element "TRUE"
    ex_false = Document.new
    ex_false.add_element "FALSE"
      
    assert_equal(ex_true.to_s, XMLHelper.boolean_to_xml(true).to_s)
    assert_equal(ex_false.to_s, XMLHelper.boolean_to_xml(false).to_s)
  end

  def test_inform_to_squadron
    example = Document.new
    inform = example.add_element "INFORM"
    squadron = inform.add_element "SQUADRON"
    squadron.add_element "VICTORY"
    squadron.add_element "KEEPEM", {"TAG"=>"2"}
    squadron.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"3"}

    expected_squd = Squadron.new([@vic1, @keep2, @air3])

    assert_same(XMLHelper.inform_to_squadron(example), expected_squd)
  end
  def test_parse_test_case
    
  end
end
