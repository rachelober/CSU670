# !/arch/unix/bin/ruby

# administrator_tests.rb
# Tests all methods from administrator.rb

# Required files
require 'test/unit'
require 'code/administrator.rb'

class TestAdministrator < Test::Unit::TestCase
    def setup
        image = Image.new("filename.jpg")
        allies = Allies.new
        axis = Axis.new
        fighter = Fighter.new
        bomber = Bomber.new

        @air1 = Aircraft.new(image, "Baku Geki KI-99", axis, bomber, 1)
        @air2 = Aircraft.new(image, "Baku Geki KI-99", axis, bomber, 2)
        @air3 = Aircraft.new(image, "Baku Geki KI-99", axis, bomber, 3)
        @air4 = Aircraft.new(image, "Bell P-39D", allies, fighter, 1)
        @air5 = Aircraft.new(image, "Bell P-39D", allies, fighter, 2)
        @air6 = Aircraft.new(image, "Bell P-39D", allies, fighter, 3)
        @air7 = Aircraft.new(image, "Dornier Do 26", axis, bomber, 1)
        @air8 = Aircraft.new(image, "Dornier Do 26", axis, bomber, 2)
        @air9 = Aircraft.new(image, "Dornier Do 26", axis, bomber, 3)
        @air10 = Aircraft.new(image, "Brewster F2A-3", allies, fighter, 1)
        @air11 = Aircraft.new(image, "Brewster F2A-3", allies, fighter, 2)
        @air12 = Aircraft.new(image, "Brewster F2A-3", allies, fighter, 3)
        @keep1 = Keepem.new(image, 1)
        @keep2 = Keepem.new(image, 2)
        @keep3 = Keepem.new(image, 3)
        @keep4 = Keepem.new(image, 4)
        @keep5 = Keepem.new(image, 5)
        @keep6 = Keepem.new(image, 6)
        @vic1 = Victory.new(image)
    end

    def test_play_one_turn_1
        player = Player.create("God", false)
        player.player_first_hand([@air4, @air5, @air6, @air10, @air11, @keep1])
        deck = Deck.list_to_deck([@vic1])
        stack = Stack.new([@vic1])
        list_of_discards = [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air7, @air8, @keep3])]
        admin = Administrator.new

        is_battle_over, return_card, our_discards, list_of_attacks, from_where = 
        admin.play_one_turn(player, deck, stack, list_of_discards)

        assert(is_battle_over, "play_one_turn is_battle_over failed")
        assert_same(@keep1, return_card, "play_one_turn return_card failed")
        assert_equal([], our_discards, "play_one_turn our_discards failed")
        assert_equal(
            [Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3])),
            Attack.new(Squadron.new([@air10, @air11, @vic1]), Squadron.new([@air7, @air8, @keep3]))],
            list_of_attacks, "play_one_turn list_of_attacks failed")
        assert_kind_of(CardsFrom, from_where, "play_one_turn from_where failed")

    end

    def test_play_one_turn_2
        player = Player.create("Moses", false)
        player.player_first_hand([@air1, @air2, @air3, @air7, @air8, @air9])
        deck = Deck.list_to_deck([@vic1])
        stack = Stack.new([@vic1])
        list_of_discards = [Squadron.new([@air4, @air5, @air6]), Squadron.new([@air10, @air11, @keep3])]
        admin = Administrator.new
        
        is_battle_over, return_card, our_discards, list_of_attacks, from_where =
        admin.play_one_turn(player, deck, stack, list_of_discards)

        assert(is_battle_over, "play_one_turn is_battle_over failed")
        assert_same(@vic1, return_card, "play_one_turn return_card failed")
        assert_equal([Squadron.new([@air1, @air2, @air3]), 
            Squadron.new([@air7, @air8, @air9])],
            our_discards, 
            "play_one_turn our_discards failed")
        assert_equal([], list_of_attacks, "play_one_turn list_of_attacks failed")
        assert_kind_of(CardsFrom, from_where, "play_one_turn from_where failed")
    end

    def test_play_one_turn_3
        player = Player.create("Budda", false)
        player.player_first_hand([@air1, @air2, @air3, @air7, @air8, @air9, @air12])   
        deck = Deck.list_to_deck([@vic1, @air12, @keep4, @keep5, @keep6])
        stack = Stack.new([@vic1])
        list_of_discards = [Squadron.new([@air4, @air5, @air6]), Squadron.new([@air10, @air11, @keep3])]
        admin = Administrator.new
        
        is_battle_over, return_card, our_discards, list_of_attacks, from_where =
        admin.play_one_turn(player, deck, stack, list_of_discards)
            
        assert(!is_battle_over, "play_one_turn is_battle_over failed")
        if return_card.instance_of?(Aircraft)
            assert_same(@air12, return_card, "play_one_turn return_card failed")
        elsif return_card.instance_of?(Victory)
            assert_same(@vic1, return_card, "play_one_turn return_card failed")
        end
        assert_equal([Squadron.new([@air1, @air2, @air3]), 
            Squadron.new([@air7, @air8, @air9])],
            our_discards,
            "play_one_turn our_discards failed")
        assert_equal([], list_of_attacks, "play_one_turn list_of_attacks failed")
        assert_kind_of(CardsFrom, from_where, "play_one_turn from_where failed")
    end

end
