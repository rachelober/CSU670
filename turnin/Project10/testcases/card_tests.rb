# !/arch/unix/bin/ruby

# card_tests.rb
# All tests for the Card class

# Required files
require 'test/unit'
require 'code/card.rb'

class TestCard < Test::Unit::TestCase
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
    @air6 = Aircraft.new(Image.new("Dornier Do 26.gif"), "Dornier Do 26", axis, bomber, 2)
    @air7 = Aircraft.new(Image.new("Dornier Do 26.gif"), "Dornier Do 26", axis, bomber, 3)
		
    @keep1 = Keepem.new(Image.new("keepem.gif"), 1)
    @keep2 = Keepem.new(Image.new("keepem.gif"), 2)
		
    @vic1 = Victory.new(Image.new("victory.gif"))
    @vic2 = Victory.new(Image.new("victory.gif"))
  end
  
  def test_card_value
    assert_kind_of(Integer, @air1.card_value)
    assert_equal(10, @air1.card_value, "Card.card_value Failed")
		
    assert_kind_of(Integer, @air4.card_value)
    assert_equal(5, @air4.card_value, "Card.card_value Failed")
		
    assert_kind_of(Integer, @keep1.card_value)
    assert_equal(0, @keep1.card_value, "Card.card_value Failed")
    
    assert_kind_of(Integer, @vic1.card_value)
    assert_equal(0, @vic1.card_value, "Card.card_value Failed")
  end

  def test_comparable
    test_air1 = Aircraft.new(Image.new("question.gif"), "Baku Geki KI-99", Axis.new, Bomber.new, 1)
    assert(@air1 == @air1)
    assert(@air1 == test_air1)
    assert(@air1 < @air2)
    assert(@air2 > @air1)
    assert(@keep1 < @air2)
    assert(@air6 > @air1)
    assert(@keep1 < @keep2)
    assert(@vic1 < @keep2)
    assert(@vic1 == @vic2)
    assert(@vic1 < @air6)
    assert_equal([@vic1, @keep1, @air1, @air2, @air6, @air7], [@air6, @air2, @vic1, @air7, @air1, @keep1].sort)
    assert_same(test_air1, @air1)
    assert_equal([@air1], [test_air1])
  end

  def test_fail_contract
    #assert_raise RuntimeError do
    #  aircraft = Aircraft.new("blah", "Name", Axis.new, Bomber.new, 5)
    #end
    
    assert_raise ContractViolation do
      @air1.cards_have_same_name?("test")
    end
  end
	
  def test_card_less_than?
    assert(@air1.card_less_than?(@air4), "Card.card_less_than? Failed")
    assert_equal(false, @air4.card_less_than?(@air1), "Card.card_less_than? Failed")
    assert(@keep1.card_less_than?(@air1), "Card.card_less_than? Failed")
    assert_equal(false, @air1.card_less_than?(@keep1), "Card.card_less_than? Failed")
    assert_equal(false, @keep1.card_less_than?(@vic1), "Card.card_less_than? Failed")
    assert(@vic1.card_less_than?(@keep1), "Card.card_less_than? Failed")
  end
		
  def test_cards_have_same_name?
    assert(@air1.cards_have_same_name?(@air2), "Card.cards_have_same_name? Failed")
    assert_equal(false, @air1.cards_have_same_name?(@air4), "Card.cards_have_same_name? Failed")
    assert_equal(false, @air1.cards_have_same_name?(@keep1), "Card.cards_have_same_name? Failed")
    assert_equal(false, @air1.cards_have_same_name?(@vic1), "Card.cards_have_same_name? Failed")

    assert(@keep1.cards_have_same_name?(@keep2), "Card.cards_have_same_name? Failed")
    assert_equal(false, @keep1.cards_have_same_name?(@vic1), "Card.cards_have_same_name? Failed")
    assert_equal(false, @keep1.cards_have_same_name?(@air1), "Card.cards_have_same_name? Failed")
    assert(@vic1.cards_have_same_name?(@vic2), "Card.cards_have_same_name? Failed")
    assert_equal(false, @vic1.cards_have_same_name?(@keep1), "Card.cards_have_same_name? Failed")
    assert_equal(false, @vic1.cards_have_same_name?(@air1), "Card.cards_have_same_name? Failed")
  end

  def test_xml_to_card_aircraft
    aircraft = "<AIRCRAFT NAME=\"Baku Geki KI-99\" TAG=\"1\" />"
    doc = Document.new aircraft
    assert_same(@air1, Card.xml_to_card(doc))
  end

  def test_xml_to_card_keepem
    keepem = "<KEEPEM TAG=\"1\" />"
    doc = Document.new keepem
    assert_same(@keep1, Card.xml_to_card(doc))
  end

  def test_xml_to_card_victory
    victory = "<VICTORY />"
    doc = Document.new victory
    assert_same(@vic1, Card.xml_to_card(doc))
  end

  def test_card_to_xml
    ex_air = '<AIRCRAFT NAME="Baku Geki KI-99" TAG="1" />'
    ex_keep = '<KEEPEM TAG="1" />'
    ex_vic = "<VICTORY />"
    
    assert_equal(ex_air, @air1.card_to_xml)
    assert_equal(ex_keep, @keep1.card_to_xml)
    assert_equal(ex_vic, @vic1.card_to_xml)
  end
end
