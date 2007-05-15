# !/arch/unix/bin/ruby

# player_tests.rb
# Test cases for player.rb

# Required Files
require 'test/unit'
require 'code/player.rb'
require 'code/card.rb'
require 'code/deck.rb'
require	'code/stack.rb'
require 'code/hand.rb'
require	'code/squadron.rb'
require 'code/turn.rb'

class TestPlayer < Test::Unit::TestCase
    def setup
		# Necessary objects to build cards
        image = Image.new("filename.jpg")
        allies = Allies.new
        axis = Axis.new
        fighter = Fighter.new
        bomber = Bomber.new
        
        # Cards to be used for testing
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

		# Player for general testing
        @player1 = Player.create("Rachel")
        @player1.player_first_hand([@air1, @air2, @air3, @keep1, @keep3, @keep4])
        
        expected_attacks1 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))
        expected_attacks2 = Attack.new(Squadron.new([@air7, @air8, @air9]), Squadron.new([@air1, @air2, @air3]))
        expected_attacks3 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))
    
        @list_of_attacks1 = [expected_attacks1, expected_attacks2, expected_attacks3]
        @list_of_attacks2 = [expected_attacks3, expected_attacks1, expected_attacks2]
        @list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    end

    def test_Attack_equal?
        expected_attacks1 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))
        expected_attacks2 = Attack.new(Squadron.new([@air7, @air8, @air9]), Squadron.new([@air1, @air2, @air3]))
        expected_attacks3 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))
        
        assert(expected_attacks1.equal?(expected_attacks1), "Attack.equal? failed")
        assert(!expected_attacks1.equal?(expected_attacks2), "Attack.equal? failed")
        assert(expected_attacks1.equal?(expected_attacks3), "Attack.equal? failed")
    end

    def test_same_attack_list?
        attack1 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))
        attack2 = Attack.new(Squadron.new([@air7, @air8, @air9]), Squadron.new([@air1, @air2, @air3]))
        
        attack_list1 = [attack1, attack2]
        attack_list2 = [attack2, attack1] 
        
        assert(Attack.same_attack_list?(attack_list1, attack_list1), "Attack.same_attack_list? failed")
        assert(!Attack.same_attack_list?(attack_list1, attack_list2), "Attack.same_attack_list? failed")
        assert(!Attack.same_attack_list?(attack_list2, attack_list1), "Attack.same_attack_list? failed")
    end

    def test_Done_equal?
		test_done1 = Done.new(@list_of_attacks1, @list_of_squads)
		test_done2 = Done.new(@list_of_attacks2, @list_of_squads)
        
        assert_same(test_done1, test_done1, "Done.equal? Failed")
        assert_not_same(test_done2, test_done1, "Done.equal? Failed")
    end

    def test_Ret_equal?
		test_ret1 = Ret.new(@list_of_attacks1, @list_of_squads, @air1)
		test_ret2 = Ret.new(@list_of_attacks2, @list_of_squads, @air6)
		test_ret3 = Ret.new(@list_of_attacks1, @list_of_squads, @air1)

        assert_same(test_ret1, test_ret1, "Ret.equal? Failed")
        assert_not_same(test_ret2, test_ret1, "Ret.equal? Failed")
        assert_same(test_ret1, test_ret3, "Ret.equal? Failed")
    end

    def test_End_equal?
		test_end1 = End.new(@list_of_attacks1, @list_of_squads, @air1)
		test_end2 = End.new(@list_of_attacks2, @list_of_squads, @air6)
		test_end3 = End.new(@list_of_attacks1, @list_of_squads, @air1)
        
        assert_same(test_end1, test_end1, "End.equal? Failed")
        assert_not_same(test_end2, test_end1, "End.equal? Failed")
        assert_same(test_end1, test_end3, "End.equal? Failed")
    end
    
    def test_End_nilcard_equal?
        test_end1 = End.new(@list_of_attacks1, @list_of_squads, nil)
		test_end2 = End.new(@list_of_attacks2, @list_of_squads, nil)
		test_end3 = End.new(@list_of_attacks1, @list_of_squads, nil)
        
        assert_same(test_end1, test_end1, "End.equal? Failed")
        assert_not_same(test_end2, test_end1, "End.equal? Failed")
        assert_same(test_end1, test_end3, "End.equal? Failed")
    end

    def test_create
        assert_instance_of(Player, Player.create("Test Player"), "Player.create failed")
    end

    def test_player_name
        assert_instance_of(String, @player1.player_name, "Player.player_name failed")
        assert_equal("Rachel", @player1.player_name, "Player.player_name failed")
    end

    def test_player_hand
        player2 = Player.create("Player 2")
        player2_first_hand_list = [@air1, @air2, @air3]
        
        assert_instance_of(Hand, player2.player_hand, "Player.player_hand failed")
        assert_same(Hand.create(Array.new), player2.player_hand, "Player.player_hand failed")
    end

    def test_player_first_hand
        player2 = Player.create("Player 2")
        player2_first_hand_list = [@air1, @air2, @air3]
        
        assert_instance_of(Hand, @player1.player_first_hand([@air1]), "Player.player_first_hand failed")
        assert_same(Hand.new([]), player2.player_hand, "Player.player_first_hand failed")
        assert_same(Hand.new([@air1, @air2, @air3]), player2.player_first_hand(player2_first_hand_list), 
        "Player.player_first_hand failed")
        assert_same(Hand.new(player2_first_hand_list), player2.player_hand, "Player.player_first_hand failed")
    end

    def test_make_max_fighters_no_wildcards
    	player2 = Player.new("Player 2")
        player2.player_first_hand([@air4, @air5, @air6])

        list_of_allies = [Squadron.new([@air7, @air8, @air9])]
        list_of_axis = [Squadron.new([@air1, @air2, @air3])]

        expected_fighters = Squadron.new([@air4, @air5, @air6])
        expected_bombers = Squadron.new([@air1, @air2, @air3])

        expected_attack_list = [Attack.new(expected_fighters, expected_bombers)]
        
        result = player2.make_max_fighters(list_of_allies, list_of_axis)

        assert_instance_of(Array, result, "Player.make_max_fighters failed")
        assert(Attack.same_attack_list?(expected_attack_list, result), "Player.make_max_fighters failed")
    end


    def test_make_max_fighters_one_wildcard
    	player2 = Player.new("Player 2")
        player2.player_first_hand([@air4, @air5, @keep1])

        list_of_allies = [Squadron.new([@air7, @air8, @air9])]
        list_of_axis = [Squadron.new([@air1, @air2, @air3])]

        expected_fighters = Squadron.new([@air4, @air5, @keep1])
        expected_bombers = Squadron.new([@air1, @air2, @air3])
        
        expected_attack_list = [Attack.new(expected_fighters, expected_bombers)]
        
        result = player2.make_max_fighters(list_of_allies, list_of_axis)
        assert_instance_of(Array, result, "Player.make_max_fighters failed")
        assert(Attack.same_attack_list?(expected_attack_list, result), "Player.make_max_fighters failed")
    end

    def test_make_max_fighters_two_wildcards
    	player2 = Player.new("Player 2")
        player2.player_first_hand([@air4, @keep1, @vic1])

        list_of_allies = [Squadron.new([@air7, @air8, @air9])]
        list_of_axis = [Squadron.new([@air1, @air2, @air3])]

        expected_fighters = Squadron.new([@air4, @keep1, @vic1])
        expected_bombers = Squadron.new([@air1, @air2, @air3])
        
        expected_attack_list = [Attack.new(expected_fighters, expected_bombers)]
        
        result = player2.make_max_fighters(list_of_allies, list_of_axis)
        assert_instance_of(Array, result, "Player.make_max_fighters failed")
        assert(Attack.same_attack_list?(expected_attack_list, result), "Player.make_max_fighters failed")
    end

    def test_make_max_bombers_no_wildcards
    	player2 = Player.new("Player 2")
        player2.player_first_hand([@air1, @air2, @air3])
        expected_bomber_list = [Squadron.new([@air1, @air2, @air3])]
        
        assert_instance_of(Array, player2.make_max_bombers, "Player.make_max_bombers failed")
        assert(Squadron.same_squad_list?(expected_bomber_list, player2.make_max_bombers), 
        "Player.make_max_bombers failed")
    end

    def test_make_max_bombers_one_wildcard
    	player2 = Player.new("Player 2")
        player2.player_first_hand([@air1, @air2, @keep1])
        expected_bomber_list = [Squadron.new([@air1, @air2, @keep1])]
        
        assert_instance_of(Array, player2.make_max_bombers, "Player.make_max_bombers failed")
        assert(Squadron.same_squad_list?(expected_bomber_list, player2.make_max_bombers), 
        "Player.make_max_bombers failed")
    end

    def test_make_max_bombers_two_wildcards
    	player2 = Player.new("Player 2")
        player2.player_first_hand([@air1, @keep1, @vic1])
        expected_bomber_list = [Squadron.new([@air1, @keep1, @vic1])]
        
        assert_instance_of(Array, player2.make_max_bombers, "Player.make_max_bombers failed")
        assert(Squadron.same_squad_list?(expected_bomber_list, player2.make_max_bombers), 
        "Player.make_max_bombers failed")
    end

    def test_update_hand
    	player2 = Player.new("Player 2")
        player2.player_first_hand([@air4, @keep1, @vic1, @air7, @air8, @keep2, @keep6])

        expected_fighters = Squadron.new([@air4, @keep1, @vic1])
        expected_bombers = Squadron.new([@air1, @air2, @air3])
        list_of_attacks = [Attack.new(expected_fighters, expected_bombers)]
        list_of_discards = [Squadron.new([@air7, @air8, @keep2])]
        
        assert_same(Hand.new([@keep6]), player2.update_hand(list_of_attacks, list_of_discards), 
        "Player.update_hand failed")
    end

    def test_play_turn_end_return_card
    	player2 = Player.new("Player 2")
        player2.player_first_hand([@air4, @air5, @keep1])

        list_of_allies = [Squadron.new([@air7, @air8, @air9])]
        list_of_axis = [Squadron.new([@air1, @air2, @air3])]
        list_of_attacks = player2.make_max_fighters(list_of_allies.dup, list_of_axis.dup)
        list_of_discards = player2.make_max_bombers
        
        from_deck_or_stack = [@keep6]
        expected_done = End.new(list_of_attacks, list_of_discards, @keep6)

        assert_same(expected_done, player2.play_hand(from_deck_or_stack, list_of_allies, list_of_axis), 
        "Player.play_turn failed")
    end

    def test_play_turn_end_return_nil
    	player2 = Player.new("Player 2")
        player2.player_first_hand([@air4, @air5])

        list_of_discards = []
        list_of_attacks = [Attack.new(Squadron.new([@air4, @air5, @air6]),Squadron.new([@air1, @air2, @air3]))]
        card = nil 
        expected_done = End.new(list_of_attacks, list_of_discards, card)

		from_deck_or_stack = [@air6]
        list_of_allies = []
        list_of_axis = [Squadron.new([@air1, @air2, @air3])]

        assert_same(expected_done, player2.play_hand(from_deck_or_stack, list_of_allies, list_of_axis), 
        "Player.play_turn failed")
    end

    def test_play_turn_ret
    	player2 = Player.new("Player 2")
        player2.player_first_hand([@air4])

        list_of_discards = []
        list_of_attacks = []
        card = @air4
        expected_done = Ret.new(list_of_attacks, list_of_discards, card)

		from_deck_or_stack = [@air4]
        list_of_allies = []
        list_of_axis = [Squadron.new([@air1, @air2, @air3])]

        assert_instance_of(Ret, player2.play_hand(from_deck_or_stack, list_of_allies.dup, list_of_axis.dup), 
        "Player.play_turn failed")
        assert_same(expected_done, player2.play_hand(from_deck_or_stack, list_of_allies, list_of_axis), 
        "Player.play_turn failed")
    end

    def test_player_take_turn_kind_of
    	player2 = Player.new("Player 2")
        player2.player_first_hand([@air4])

        list_of_discards = []
        list_of_attacks = []
        card = @air4
        expected_done = Ret.new(list_of_attacks, list_of_discards, card)

		deck = Deck.list_to_deck([@air4])
        stack = Stack.create(@air4)
        list_of_squads = [Squadron.new([@air1, @air2, @air3])]
        example_turn = Turn.new(deck, stack, list_of_squads)

        assert_kind_of(Done, player2.player_take_turn(example_turn), "Player.player_take_turn failed")
    end

    def test_player_take_turn
    	player2 = Player.new("Player 2")
        player2.player_first_hand([@air4])

        list_of_discards = []
        list_of_attacks = []
        card = @air4
        expected_done = Ret.new(list_of_attacks, list_of_discards, card)

		deck = Deck.list_to_deck([@air4])
        stack = Stack.create(@air4)
        list_of_squads = [Squadron.new([@air1, @air2, @air3])]
        example_turn = Turn.new(deck, stack, list_of_squads)

        assert_same(expected_done, player2.player_take_turn(example_turn), "Player.player_take_turn failed")
    end
end
