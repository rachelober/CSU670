# !/arch/unix/bin/ruby

require 'test/unit'
require 'code/proxyturn.rb'
require 'code/alliance.rb'
require 'code/category.rb'
require 'code/image.rb'
require 'code/card.rb'
require 'code/deck.rb'
require 'code/hand.rb'
require 'code/squadron.rb'
require 'code/stack.rb'
require 'code/turn.rb'
require 'code/player.rb'
require 'code/administrator.rb'
            
class TestProxyTurn < Test::Unit::TestCase
  def setup
    @okay = '<OKAY />'
    @aircraft = '<AIRCRAFT NAME="Bell P-39D" TAG="1" />'
    @keepem = '<KEEPEM TAG="1" />'
    @victory = '<VICTORY />'
    
    image = Image.new('.gif')
    axis = Axis.new
    allies = Allies.new
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

    @stack = Stack.new([@air4, @air5, @air7])

    @list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    
    @proxy_turn1 = ProxyTurn.new(true, @stack, @list_of_squads)
    @proxy_turn2 = ProxyTurn.new(false, @stack, @list_of_squads)
  end

  def test_contract_get_from_deck
    STDOUT << "\n" + 'Please input: <VICTORY />' + "\n"
    turn_test = ProxyTurn.new(true, @stack, @list_of_squads)
    turn_test.turn_get_a_card_from_deck

    assert_raise TimingError do
      turn_test.turn_get_a_card_from_deck
    end
  end

  def test_contract_get_cards_from_stack
    STDOUT << "\n" + 'Please input: <VICTORY />' + "\n"
    test_stack1 = Stack.new([@air1, @air2, @air3, @air4, @air5])
    turn_test = ProxyTurn.new(true, test_stack1, @list_of_squads)
    turn_test.turn_get_a_card_from_deck

    assert_raise TimingError do
      turn_test.turn_get_cards_from_stack(3)
    end
  end

  def test_contract_get_cards_from_stack_no_stack_cards
    test_stack1 = Stack.new([])
    turn_test = ProxyTurn.new(false, test_stack1, @list_of_squads)

    assert_raise ContractViolation do
      turn_test.turn_get_cards_from_stack(3)
    end
  end

  def test_proxyturn_create
    assert_instance_of(ProxyTurn, ProxyTurn.new(true, @stack, @list_of_squads), "ProxyTurn.new failed")
    assert_instance_of(ProxyTurn, ProxyTurn.new(false, @stack, @list_of_squads), "ProxyTurn.new failed")
  end

  def test_turn_get_cards_from_stack_1
    STDOUT << "\n" + 'Please input: <OKAY />' + "\n"
    assert_equal([@air4], @proxy_turn1.turn_get_cards_from_stack(1))
  end
  
  def test_turn_get_cards_from_stack_2
    STDOUT << "\n" + 'Please input: <OKAY />' + "\n"
    assert_equal([@air4, @air5], @proxy_turn1.turn_get_cards_from_stack(2))
  end
  
  def test_turn_get_cards_from_stack_3
    STDOUT << "\n" + 'Please input: <OKAY />' + "\n"
    assert_equal([@air4, @air5, @air7], @proxy_turn1.turn_get_cards_from_stack(3))
  end
  
  def test_turn_get_cards_from_stack_4
    STDOUT << "\n" + 'Please input: <OKAY />' + "\n"
    assert_equal([@air4], @proxy_turn2.turn_get_cards_from_stack(1))
  end
  
  def test_turn_get_cards_from_stack_5
    STDOUT << "\n" + 'Please input: <OKAY />' + "\n"
    assert_equal([@air4, @air5], @proxy_turn2.turn_get_cards_from_stack(2))
  end
  
  def test_turn_get_cards_from_stack_6
    STDOUT << "\n" + 'Please input: <OKAY />' + "\n"
    assert_equal([@air4, @air5, @air7], @proxy_turn2.turn_get_cards_from_stack(3))
  end
  
  def test_turn_get_a_card_from_deck_aircraft
    STDOUT << "\n" + 'Please input: <AIRCRAFT NAME="Bell P-39D" TAG="1" />' + "\n"
    assert(@air4.cards_have_same_name?(@proxy_turn1.turn_get_a_card_from_deck))
  end
  
  def test_turn_get_a_card_from_deck_keepem
    STDOUT << "\n" + 'Please input: <KEEPEM TAG="1" />' + "\n"
    assert(@keep1.cards_have_same_name?(@proxy_turn1.turn_get_a_card_from_deck))
  end
  
  def test_turn_get_a_card_from_deck_victory
    STDOUT << "\n" + 'Please input: <VICTORY />' + "\n"
    assert(@vic1.cards_have_same_name?(@proxy_turn1.turn_get_a_card_from_deck))
  end

  def test_xml_to_pturn
    turn_doc = Document.new File.new("xmltests/turn_test.xml")
    
    ex_bool = true
    ex_stck = Stack.new([@vic1])
    ex_slst =
      [Squadron.new([@air19, @air20, @air21]),
      Squadron.new([@air7, @air8, @air9])]
    expected = ProxyTurn.new(ex_bool, ex_stck, ex_slst)
    results = ProxyTurn.xml_to_proxyturn(turn_doc)
    
    assert_same(expected, results)
  end
end
