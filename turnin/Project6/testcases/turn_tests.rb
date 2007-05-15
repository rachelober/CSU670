# !/arch/unix/bin/ruby

# turn_tests.rb
# Tests cases for turn.rb

# Required files
require 'test/unit'
require 'code/card.rb'
require 'code/deck.rb'
require	'code/stack.rb'
require 'code/hand.rb'
require	'code/squadron.rb'
require 'code/turn.rb'

class TestTurn < Test::Unit::TestCase
	def setup
		image = Image.new("filename.jpg")
		@allies = Allies.new
		@axis = Axis.new
		fighter = Fighter.new
		bomber = Bomber.new
		
		@air1 = Aircraft.new(image, "Baku Geki KI-99", @axis, bomber, 1)
		@air2 = Aircraft.new(image, "Baku Geki KI-99", @axis, bomber, 2)
		@air3 = Aircraft.new(image, "Baku Geki KI-99", @axis, bomber, 3)
		@air4 = Aircraft.new(image, "Bell P-39D", @allies, fighter, 1)
		@air5 = Aircraft.new(image, "Bell P-39D", @allies, fighter, 2)
		@air6 = Aircraft.new(image, "Dornier Do 26", @axis, bomber, 1)
		@keep1 = Keepem.new(image, 1)
		@keep2 = Keepem.new(image, 2)
		@vic1 = Victory.new(image)
        
        # Game Deck for building Turns
		@deck = Deck.create
		
        # Stack used to create a turn
        @stack = Stack.new([@air6, @keep2, @vic1])
            
		# Squadron to be used to build a Turn's list_of_squads
		@list_of_squads = [Squadron.new([@air1, @air2, @air3])]
		
		# Generic turn for method testing
		@turn = Turn.new(@deck, @stack, @list_of_squads)
    end

    def test_CardsFrom_equal?
        from_deck = FromDeck.new
        from_stack = FromStack.new(3)
		
        assert_same(from_deck, from_deck, "CardsFrom.equal? failed")
		assert_not_same(from_deck, from_stack, "CardsFrom.equal? failed")
		assert_same(from_stack, from_stack, "CardsFrom.equal? failed")
		assert_not_same(from_stack, from_deck, "CardsFrom.equal? failed")
    end

    def test_Turn_equal?
		test_deck = Deck.new([@air1, @air2, @air3, @air4, @air5, @air6, @keep1, @keep2, @vic1])
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
		test_deck = Deck.new([@air1, @air2, @air3, @air4, @air5, @air6, @keep1, @keep2, @vic1])
		turn_test = Turn.new(test_deck, @stack, @list_of_squads)
	
        assert_instance_of(Aircraft, turn_test.turn_get_a_card_from_deck, "Turn.turn_get_a_card_from_deck failed")
		assert_same(@air1, turn_test.turn_get_a_card_from_deck, "Turn.turn_get_a_card_from_deck failed")
    end

    def test_turn_stack_inspect
		test_stack1 = Stack.new([@air1, @air2, @air3])
		test_stack2 = Stack.new([@air4, @air5, @air6])
		test_turn_stack1 = Turn.new(@deck, test_stack1, @list_of_squads)
		test_turn_stack2 = Turn.new(@deck, test_stack2, @list_of_squads)
	
		assert_instance_of(Array, test_turn_stack1.turn_stack_inspect, "Turn.turn_stack_inspect failed")
		assert_equal([@air1, @air2, @air3], test_turn_stack1.turn_stack_inspect, "Turn.turn_stack_inspect failed")
		assert_equal([@air4, @air5, @air6], test_turn_stack2.turn_stack_inspect, "Turn.turn_stack_inspect failed")
    end

    def test_turn_get_cards_from_stack
		expected_list = [@air1, @air2, @air3]
		test_stack1 = Stack.new([@air1, @air2, @air3, @air4, @air5])
		test_turn_stack1 = Turn.new(@deck, test_stack1, @list_of_squads)
		
		assert_instance_of(Array, test_turn_stack1.turn_get_cards_from_stack(3), "Turn.turn_get_cards_from_stack failed")
   		assert_equal(expected_list, test_turn_stack1.turn_get_cards_from_stack(3), "Turn.turn_get_cards_from_stack failed")
    end

    def test_turn_can_attack?
		test_list_of_squads = [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @keep1])]
		test_turn = Turn.new(@deck, @stack, test_list_of_squads)
   		
        assert_instance_of(Array, test_turn.turn_can_attack?(@allies), "Turn.turn_can_attack? failed")
   		assert_instance_of(Array, test_turn.turn_can_attack?(@axis), "Turn.turn_can_attack? failed")
   		assert(Squadron.same_squad_list?([Squadron.new([@air1, @air2, @air3])], test_turn.turn_can_attack?(@allies)), "Turn.turn_can_attack? failed")
   		assert_equal([], test_turn.turn_can_attack?(@axis), "Turn.turn_can_attack? failed")
    end

    def test_turn_end
		from_deck = FromDeck.new
		from_stack = FromStack.new(3)
		
        test_turn1 = Turn.new(@deck, @stack, @list_of_squads)
        test_turn1.turn_get_a_card_from_deck
        test_turn2 = Turn.new(@deck, @stack, @list_of_squads)
		test_turn2.turn_get_cards_from_stack(3)
        
        assert_instance_of(FromDeck, test_turn1.turn_end, "Turn.turn_end failed")
        assert_instance_of(FromStack, test_turn2.turn_end, "Turn.turn_end failed")
		assert_same(from_deck, test_turn1.turn_end, "Turn.turn_end failed")
		assert_same(from_stack, test_turn2.turn_end, "Turn.turn_end failed")
		assert_not_same(from_deck, test_turn2.turn_end, "Turn.turn_end failed")
		assert_not_same(from_stack, test_turn1.turn_end, "Turn.turn_end failed")
	end
end
