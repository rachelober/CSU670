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

        @air1 = Aircraft.new(Image.new("question.jpg"), "Baku Geki KI-99", axis, bomber, 1)
        @air2 = Aircraft.new(Image.new("question.jpg"), "Baku Geki KI-99", axis, bomber, 2)
        @air3 = Aircraft.new(Image.new("question.jpg"), "Baku Geki KI-99", axis, bomber, 3)
        @air4 = Aircraft.new(Image.new("Bell P-39D.jpg"), "Bell P-39D", allies, fighter, 1)
        @air5 = Aircraft.new(Image.new("Bell P-39D.jpg"), "Bell P-39D", allies, fighter, 2)
        @air6 = Aircraft.new(Image.new("Bell P-39D.jpg"), "Bell P-39D", allies, fighter, 3)
        @air7 = Aircraft.new(Image.new("Dornier Do 26.jpg"), "Dornier Do 26", axis, bomber, 1)
        @air8 = Aircraft.new(Image.new("Dornier Do 26.jpg"), "Dornier Do 26", axis, bomber, 2)
        @air9 = Aircraft.new(Image.new("Dornier Do 26.jpg"), "Dornier Do 26", axis, bomber, 3)
        @air10 = Aircraft.new(Image.new("Brewster F2A-3.jpg"), "Brewster F2A-3", allies, fighter, 1)
        @air11 = Aircraft.new(Image.new("Brewster F2A-3.jpg"), "Brewster F2A-3", allies, fighter, 2)
        @air12 = Aircraft.new(Image.new("Brewster F2A-3.jpg"), "Brewster F2A-3", allies, fighter, 3)
        @air13 = Aircraft.new(Image.new("Curtiss P-40E.jpg"), "Curtiss P-40E", allies, fighter, 1)
        @air14 = Aircraft.new(Image.new("Curtiss P-40E.jpg"), "Curtiss P-40E", allies, fighter, 2)
        @air15 = Aircraft.new(Image.new("Curtiss P-40E.jpg"), "Curtiss P-40E", allies, fighter, 3)
        @air16 = Aircraft.new(Image.new("Messerschmitt ME-109"), "Messerschmitt ME-109", axis, fighter, 1)
        @air17 = Aircraft.new(Image.new("Messerschmitt ME-109"), "Messerschmitt ME-109", axis, fighter, 2)
        @air18 = Aircraft.new(Image.new("Messerschmitt ME-109"), "Messerschmitt ME-109", axis, fighter, 3)
        @air19 = Aircraft.new(Image.new("Vickers Wellington"), "Vickers Wellington", allies, bomber, 1)
        @air20 = Aircraft.new(Image.new("Vickers Wellington"), "Vickers Wellington", allies, bomber, 2)
        @air21 = Aircraft.new(Image.new("Vickers Wellington"), "Vickers Wellington", allies, bomber, 3)
        @keep1 = Keepem.new(Image.new("keepem.jpg"), 1)
        @keep2 = Keepem.new(Image.new("keepem.jpg"), 2)
        @keep3 = Keepem.new(Image.new("keepem.jpg"), 3)
        @keep4 = Keepem.new(Image.new("keepem.jpg"), 4)
        @keep5 = Keepem.new(Image.new("keepem.jpg"), 5)
        @keep6 = Keepem.new(Image.new("keepem.jpg"), 6)
        @vic1 = Victory.new(Image.new("victory.jpg"))
    end

    def test_xml_okay?
        okay = "<OKAY />"
        not_okay = "<NOTOKAY />"

        doc = Document.new okay
        ndoc = Document.new not_okay
        
        assert(XMLHelper.xml_okay?(doc))
        assert(!XMLHelper.xml_okay?(ndoc))
    end

    def test_boolean_to_xml
        ex_true = "<TRUE />"
        ex_false = "<FALSE />"

        assert_equal(ex_true, XMLHelper.boolean_to_xml(true))
        assert_equal(ex_false, XMLHelper.boolean_to_xml(false))
    end
end
