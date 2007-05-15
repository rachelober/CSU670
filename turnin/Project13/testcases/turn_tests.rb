# !/arch/unix/bin/ruby

# turn_tests.rb
# Tests cases for turn.rb

# Required files
require 'test/unit'
require 'code/turn.rb'

class TestTurn < Test::Unit::TestCase
	def setup
		@allies = Allies.new
		@axis = Axis.new
		fighter = Fighter.new
		bomber = Bomber.new
		
		@air1 = Aircraft.new(Image.new("Baku Geki KI-99.gif"), "Baku Geki KI-99", @axis, bomber, 1)
		@air2 = Aircraft.new(Image.new("Baku Geki KI-99.gif"), "Baku Geki KI-99", @axis, bomber, 2)
		@air3 = Aircraft.new(Image.new("Baku Geki KI-99.gif"), "Baku Geki KI-99", @axis, bomber, 3)
		@air4 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", @allies, fighter, 1)
		@air5 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", @allies, fighter, 2)
    @air6 = Aircraft.new(Image.new("Bell P-39D.jpg"), "Bell P-39D", @allies, fighter, 3)
    @air7 = Aircraft.new(Image.new("Dornier Do 26.jpg"), "Dornier Do 26", @axis, bomber, 1)
    @air8 = Aircraft.new(Image.new("Dornier Do 26.jpg"), "Dornier Do 26", @axis, bomber, 2)
    @air9 = Aircraft.new(Image.new("Dornier Do 26.jpg"), "Dornier Do 26", @axis, bomber, 3)
    @air10 = Aircraft.new(Image.new("Brewster F2A-3.jpg"), "Brewster F2A-3", @allies, fighter, 1)
    @air11 = Aircraft.new(Image.new("Brewster F2A-3.jpg"), "Brewster F2A-3", @allies, fighter, 2)
    @air12 = Aircraft.new(Image.new("Brewster F2A-3.jpg"), "Brewster F2A-3", @allies, fighter, 3)
    @air13 = Aircraft.new(Image.new("Curtiss P-40E.jpg"), "Curtiss P-40E", @allies, fighter, 1)
    @air14 = Aircraft.new(Image.new("Curtiss P-40E.jpg"), "Curtiss P-40E", @allies, fighter, 2)
    @air15 = Aircraft.new(Image.new("Curtiss P-40E.jpg"), "Curtiss P-40E", @allies, fighter, 3)
    @air16 = Aircraft.new(Image.new("Messerschmitt ME-109"), "Messerschmitt ME-109", @axis, fighter, 1)
    @air17 = Aircraft.new(Image.new("Messerschmitt ME-109"), "Messerschmitt ME-109", @axis, fighter, 2)
    @air18 = Aircraft.new(Image.new("Messerschmitt ME-109"), "Messerschmitt ME-109", @axis, fighter, 3)
    @air19 = Aircraft.new(Image.new("Vickers Wellington"), "Vickers Wellington", @allies, bomber, 1)
    @air20 = Aircraft.new(Image.new("Vickers Wellington"), "Vickers Wellington", @allies, bomber, 2)
    @air21 = Aircraft.new(Image.new("Vickers Wellington"), "Vickers Wellington", @allies, bomber, 3)
		@keep1 = Keepem.new(Image.new("keepem.gif"), 1)
		@keep2 = Keepem.new(Image.new("keepem.gif"), 2)
		@vic1 = Victory.new(Image.new("victory.gif"))
    
    # Game Deck for building Turns
		@deck = Deck.create
		
    # Stack used to create a turn
    @stack = Stack.new([@air7, @keep2, @vic1])
      
		# Squadron to be used to build a Turn's list_of_squads
		@list_of_squads = [Squadron.new([@air1, @air2, @air3])]
		
		# Generic turn for method testing
		@turn = Turn.new(@deck, @stack, @list_of_squads)
  end

  def test_contract_get_from_deck
		test_deck = Deck.new([@air1, @air2, @air3, @air4, @air5, @air7, @keep1, @keep2, @vic1])
		turn_test = Turn.new(test_deck, @stack, @list_of_squads)
    turn_test.turn_get_a_card_from_deck

    assert_raise TimingError do
      turn_test.turn_get_a_card_from_deck
    end
  end
  
  def test_contract_get_cards_from_stack
		test_stack1 = Stack.new([@air1, @air2, @air3, @air4, @air5])
		turn_test = Turn.new(@deck, test_stack1, @list_of_squads)
    turn_test.turn_get_a_card_from_deck
		
    assert_raise TimingError do
      turn_test.turn_get_cards_from_stack(3)
    end
  end

  def test_contract_get_cards_from_stack_no_stack_cards
		test_stack1 = Stack.new([])
		turn_test = Turn.new(@deck, test_stack1, @list_of_squads)
		
    assert_raise ContractViolation do
      turn_test.turn_get_cards_from_stack(3)
    end
  end

  def test_contract_turn_end
    turn_test = Turn.new(@deck, @stack, @list_of_squads)
    
    assert_raise TimingError do
      turn_test.turn_end
    end
  end

  def test_equal?
		test_deck = Deck.new([@air1, @air2, @air3, @air4, @air5, @air7, @keep1, @keep2, @vic1])
		turn_test = Turn.new(test_deck, @stack, @list_of_squads)
		
    assert_same(@turn, @turn, "Turn.equal? Failed")
		assert_equal(false, @turn.equal?(turn_test), "Turn.equal? Failed")
  end

  def test_create
    test_turn = Turn.new(@deck, @stack, @list_of_squads)
    
   	assert_instance_of(Turn, test_turn, "Turn.create_turn failed")
		assert_same(@turn, test_turn, "Turn.create_turn failed")
  end

  def test_how_many_cards?
    from_stack = FromStack.new(3)
    
    assert_instance_of(Fixnum, from_stack.how_many_cards?, "FromStack.how_many_cards? failed")
		assert_equal(3, from_stack.how_many_cards?, "FromStack.how_many_cards? failed")
  end

  def test_turn_card_on_deck?
		deck_empty = Deck.new([])
		turn_empty_deck = Turn.new(deck_empty, @stack, @list_of_squads)
	
		assert(@turn.turn_card_on_deck?, "Turn.turn_card_on_deck? Failed")
		assert(!turn_empty_deck.turn_card_on_deck?, "Turn.turn_card_on_deck? Failed")
  end

  def test_turn_get_a_card_from_deck
		test_deck = Deck.new([@air1, @air2, @air3, @air4, @air5, @air7, @keep1, @keep2, @vic1])
		turn_test = Turn.new(test_deck, @stack, @list_of_squads)
		turn_test2 = Turn.new(test_deck, @stack, @list_of_squads)
	
    assert_instance_of(Aircraft, turn_test2.turn_get_a_card_from_deck, "Turn.turn_get_a_card_from_deck failed")
		assert_same(@air1, turn_test.turn_get_a_card_from_deck, "Turn.turn_get_a_card_from_deck failed")
  end

  def test_turn_stack_inspect
		test_stack1 = Stack.new([@air1, @air2, @air3])
		test_stack2 = Stack.new([@air4, @air5, @air7])
		test_turn_stack1 = Turn.new(@deck, test_stack1, @list_of_squads)
		test_turn_stack2 = Turn.new(@deck, test_stack2, @list_of_squads)
	
		assert_instance_of(Array, test_turn_stack1.turn_stack_inspect, "Turn.turn_stack_inspect failed")
		assert_equal([@air1, @air2, @air3], test_turn_stack1.turn_stack_inspect, "Turn.turn_stack_inspect failed")
		assert_equal([@air4, @air5, @air7], test_turn_stack2.turn_stack_inspect, "Turn.turn_stack_inspect failed")
  end

  def test_turn_get_cards_from_stack
		expected_list = [@air1, @air2, @air3]
		test_stack1 = Stack.new([@air1, @air2, @air3, @air4, @air5])
		test_turn = Turn.new(@deck, test_stack1, @list_of_squads)
		test_turn2 = Turn.new(@deck, test_stack1, @list_of_squads)
		
    assert_instance_of(Array, test_turn.turn_get_cards_from_stack(3), "Turn.turn_get_cards_from_stack failed")
   	assert_equal(expected_list, test_turn2.turn_get_cards_from_stack(3), "Turn.turn_get_cards_from_stack failed")
  end

  def test_turn_can_attack?
		test_list_of_squads = [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @keep1])]
		test_turn = Turn.new(@deck, @stack, test_list_of_squads)
   		
    assert_instance_of(Array, test_turn.turn_can_attack?(@allies), "Turn.turn_can_attack? failed")
   	assert_instance_of(Array, test_turn.turn_can_attack?(@axis), "Turn.turn_can_attack? failed")
   	assert_equal([Squadron.new([@air1, @air2, @air3])], test_turn.turn_can_attack?(@allies), "Turn.turn_can_attack? failed")
   	assert_equal([], test_turn.turn_can_attack?(@axis), "Turn.turn_can_attack? failed")
  end

  def test_turn_end_fromstack
		from_deck = FromDeck.new
		from_stack = FromStack.new(3)
		
    test_turn = Turn.new(@deck, @stack, @list_of_squads)
		test_turn.turn_get_cards_from_stack(3)
    
    assert_instance_of(FromStack, test_turn.turn_end, "Turn.turn_end failed")
		assert_same(from_stack, test_turn.turn_end, "Turn.turn_end failed")
		assert_not_same(from_deck, test_turn.turn_end, "Turn.turn_end failed")
	end

  def test_turn_end_fromdeck
		from_deck = FromDeck.new
		from_stack = FromStack.new(3)
    
    test_turn = Turn.new(@deck, @stack, @list_of_squads)
    test_turn.turn_get_a_card_from_deck
    
    assert_instance_of(FromDeck, test_turn.turn_end, "Turn.turn_end failed")
		assert_same(from_deck, test_turn.turn_end, "Turn.turn_end failed")
		assert_not_same(from_stack, test_turn.turn_end, "Turn.turn_end failed")
  end

  def test_xml_to_turn
    turn_doc = Document.new File.new("xmltests/xturn_test.xml")

    deck = Deck.list_to_deck([@vic1])
    stack = Stack.new([@vic1])
    list_of_squads =
      [Squadron.new([@air19, @air20, @air21]),
      Squadron.new([@air7, @air8, @air9])]

    expected_turn = Turn.new(deck, stack, list_of_squads)
    assert_same(expected_turn, Turn.xml_to_turn(turn_doc))
  end

  def test_turn_to_xml
    document = Document.new
    turn = document.add_element "TURN"
    turn.add_element "TRUE"
    turn.add_element @stack.stack_to_xml
    turn.add_element XMLHelper.slst_to_xml(@turn.turn_can_attack?(Axis.new))
    turn.add_element XMLHelper.slst_to_xml(@turn.turn_can_attack?(Allies.new))
    
    assert_equal(turn.to_s, @turn.turn_to_xml.to_s)
  end
end
