# !/arch/unix/bin/ruby

require 'test/unit'
require 'code/proxyturn.rb'

class TestProxyTurn < Test::Unit::TestCase
    def setup
        @okay = '<OKAY />'
        @aircraft = '<AIRCRAFT NAME="Bell P-39D" TAG="1" />'
        @keepem = '<KEEPEM TAG="1" />'
        @victory = '<VICTORY />'
        
        image = Image.new('.jpg')
        axis = Axis.new
        allies = Allies.new
        fighter = Fighter.new
        bomber = Bomber.new
        
        air1 = Aircraft.new(image, "Baku Geki KI-99", axis, bomber, 1)
        air2 = Aircraft.new(image, "Baku Geki KI-99", axis, bomber, 2)
        air3 = Aircraft.new(image, "Baku Geki KI-99", axis, bomber, 3)
        @air4 = Aircraft.new(image, "Bell P-39D", allies, fighter, 1)
        @air5 = Aircraft.new(image, "Bell P-39D", allies, fighter, 2)
        @air6 = Aircraft.new(image, "Dornier Do 26", axis, bomber, 1)
        
        @keepem1 = Keepem.new(image, 1)

        @victory1 = Victory.new(image)
        
        @stack = Stack.new([@air4, @air5, @air6])

        @list_of_squads = [Squadron.new([air1, air2, air3])]
        
        @proxy_turn1 = ProxyTurn.new(true, @stack, @list_of_squads)
        @proxy_turn2 = ProxyTurn.new(false, @stack, @list_of_squads)
    end

    def test_proxyturn_create
        assert_instance_of(ProxyTurn, ProxyTurn.new(true, @stack, @list_of_squads), "ProxyTurn.new failed")
        assert_instance_of(ProxyTurn, ProxyTurn.new(false, @stack, @list_of_squads), "ProxyTurn.new failed")
    end

    def test_turn_get_cards_from_stack
        STDOUT << "\n" + 'Please input: <OKAY /> for the following tests' + "\n"
        assert_equal([@air4], @proxy_turn1.turn_get_cards_from_stack(1))
        assert_equal([@air4, @air5], @proxy_turn1.turn_get_cards_from_stack(2))
        assert_equal([@air4, @air5, @air6], @proxy_turn1.turn_get_cards_from_stack(3))
        assert_equal([@air4], @proxy_turn2.turn_get_cards_from_stack(1))
        assert_equal([@air4, @air5], @proxy_turn2.turn_get_cards_from_stack(2))
        assert_equal([@air4, @air5, @air6], @proxy_turn2.turn_get_cards_from_stack(3))
    end
    
    def test_turn_get_a_card_from_deck_aircraft
        STDOUT << "\n" + 'Please input: <AIRCRAFT NAME="Bell P-39D" TAG="1" />' + "\n"
        assert(@air4.cards_have_same_name?(@proxy_turn1.turn_get_a_card_from_deck))
    end
    
    def test_turn_get_a_card_from_deck_keepem
        STDOUT << "\n" + 'Please input: <KEEPEM TAG="1" />' + "\n"
        assert(@keepem1.cards_have_same_name?(@proxy_turn1.turn_get_a_card_from_deck))
    end
    
    def test_turn_get_a_card_from_deck_victory
        STDOUT << "\n" + 'Please input: <VICTORY />' + "\n"
        assert(@victory1.cards_have_same_name?(@proxy_turn1.turn_get_a_card_from_deck))
    end
end
