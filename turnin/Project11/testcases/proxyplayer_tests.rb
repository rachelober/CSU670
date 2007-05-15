# !/arch/unix/bin/ruby

require 'test/unit'
require 'code/proxyplayer.rb'
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

class TestProxyPlayer < Test::Unit::TestCase
    def setup
        axis = Axis.new
        allies = Allies.new
        fighter = Fighter.new
        bomber = Bomber.new

        # Cards to be used for testing
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
        @keep1 = Keepem.new(Image.new("keepem.jpg"), 1)
        @keep2 = Keepem.new(Image.new("keepem.jpg"), 2)
        @keep3 = Keepem.new(Image.new("keepem.jpg"), 3)
        @keep4 = Keepem.new(Image.new("keepem.jpg"), 4)
        @keep5 = Keepem.new(Image.new("keepem.jpg"), 5)
        @keep6 = Keepem.new(Image.new("keepem.jpg"), 6)
        @vic1 = Victory.new(Image.new("victory.jpg"))
        
        @stack = Stack.new([@air4, @air5, @air6])
        @deck = Deck.list_to_deck([@air4, @air5, @air6])
        @list_of_squads = [Squadron.new([@air1, @air2, @air3])]
        
        @turn = Turn.new(@deck, @stack, @list_of_squads)

        @proxyplayer1 = ProxyPlayer.new('Rachel')
        @proxyplayer2 = ProxyPlayer.new('Kait')

        @proxyplayer1.player_first_hand([@air1, @air2, @air3, @keep1, @keep3, @keep4])
        
        @expected_attacks1 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))
        @expected_attacks2 = Attack.new(Squadron.new([@air7, @air8, @air9]), Squadron.new([@air1, @air2, @air3]))
        @expected_attacks3 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))
        @expected_bomber_list = [Squadron.new([@air1, @air2, @keep1])]
        @expected_bomber_list2 = [Squadron.new([@air1, @air2, @keep1])]
    end

    def test_proxyplayer_player_take_turn_deck_end_nil
        STDOUT << "\n" + 'Please input: <TURN-GET-A-CARD-FROM-DECK />
        <END><FALSE /><LIST><SQUADRON><AIRCRAFT NAME="Baku Geki KI-99" TAG="1" />
        <AIRCRAFT NAME="Baku Geki KI-99" TAG="2" /><KEEPEM TAG="1" /></SQUADRON></LIST><ATTACK><SQUADRON>
        <AIRCRAFT NAME="Bell P-39D" TAG="1" /><AIRCRAFT NAME="Bell P-39D" TAG="2" />
        <AIRCRAFT NAME="Bell P-39D" TAG="3" /></SQUADRON><SQUADRON>
        <AIRCRAFT NAME="Baku Geki KI-99" TAG="1" /><AIRCRAFT NAME="Baku Geki KI-99" TAG="2" />
        <AIRCRAFT NAME="Baku Geki KI-99" TAG="3" /></SQUADRON></ATTACK></END>'  + "\n"
        expected_done = End.new([@expected_attacks1], @expected_bomber_list, nil)
        expected_done2 = End.new([@expected_attacks3], @expected_bomber_list2, nil)

        assert_same(expected_done, expected_done2)
        assert_same(expected_done, @proxyplayer1.player_take_turn(@turn))
    end
    
    def test_proxyplayer_player_take_turn_stack_end_nil
        STDOUT << "\n" + 'Please input: <TURN-GET-CARDs-FROM-STACK no="1" />
        <END><FALSE /><LIST><SQUADRON><AIRCRAFT NAME="Baku Geki KI-99" TAG="1" />
        <AIRCRAFT NAME="Baku Geki KI-99" TAG="2" /><KEEPEM TAG="1" /></SQUADRON></LIST><ATTACK><SQUADRON>
        <AIRCRAFT NAME="Bell P-39D" TAG="1" /><AIRCRAFT NAME="Bell P-39D" TAG="2" />
        <AIRCRAFT NAME="Bell P-39D" TAG="3" /></SQUADRON><SQUADRON>
        <AIRCRAFT NAME="Baku Geki KI-99" TAG="1" /><AIRCRAFT NAME="Baku Geki KI-99" TAG="2" />
        <AIRCRAFT NAME="Baku Geki KI-99" TAG="3" /></SQUADRON></ATTACK></END>'  + "\n"
        expected_done = End.new([@expected_attacks1], @expected_bomber_list, nil)

        assert_same(expected_done, @proxyplayer1.player_take_turn(@turn))
    end
   
    def test_proxyplayer_player_take_turn_deck_end_card
        STDOUT << "\n" + 'Please input: <TURN-GET-A-CARD-FROM-DECK />
        <END><AIRCRAFT NAME="Baku Geki KI-99" TAG="1" /><LIST><SQUADRON>
        <AIRCRAFT NAME="Baku Geki KI-99" TAG="1" />
        <AIRCRAFT NAME="Baku Geki KI-99" TAG="2" /><KEEPEM TAG="1" /></SQUADRON></LIST><ATTACK><SQUADRON>
        <AIRCRAFT NAME="Bell P-39D" TAG="1" /><AIRCRAFT NAME="Bell P-39D" TAG="2" />
        <AIRCRAFT NAME="Bell P-39D" TAG="3" /></SQUADRON><SQUADRON>
        <AIRCRAFT NAME="Baku Geki KI-99" TAG="1" /><AIRCRAFT NAME="Baku Geki KI-99" TAG="2" />
        <AIRCRAFT NAME="Baku Geki KI-99" TAG="3" /></SQUADRON></ATTACK></END>'  + "\n"
        expected_done = End.new([@expected_attacks1], @expected_bomber_list, @air1)
        assert_same(expected_done, @proxyplayer1.player_take_turn(@turn))
    end

    def test_proxyplayer_player_take_turn_stack_end_card
        STDOUT << "\n" + 'Please input: <TURN-GET-CARDS-FROM-STACK no="2" />
        <END><AIRCRAFT NAME="Baku Geki KI-99" TAG="1" /><LIST><SQUADRON>
        <AIRCRAFT NAME="Baku Geki KI-99" TAG="1" />
        <AIRCRAFT NAME="Baku Geki KI-99" TAG="2" /><KEEPEM TAG="1" /></SQUADRON></LIST><ATTACK><SQUADRON>
        <AIRCRAFT NAME="Bell P-39D" TAG="1" /><AIRCRAFT NAME="Bell P-39D" TAG="2" />
        <AIRCRAFT NAME="Bell P-39D" TAG="3" /></SQUADRON><SQUADRON>
        <AIRCRAFT NAME="Baku Geki KI-99" TAG="1" /><AIRCRAFT NAME="Baku Geki KI-99" TAG="2" />
        <AIRCRAFT NAME="Baku Geki KI-99" TAG="3" /></SQUADRON></ATTACK></END>'  + "\n"
        expected_done = End.new([@expected_attacks1], @expected_bomber_list, @air1)
        assert_same(expected_done, @proxyplayer1.player_take_turn(@turn))
    end

    def test_proxyplayer_player_take_turn_deck_ret
        STDOUT << "\n" + 'Please input: <TURN-GET-A-CARD-FROM-DECK />
        <RET><AIRCRAFT NAME="Baku Geki KI-99" TAG="1" /><LIST><SQUADRON>
        <AIRCRAFT NAME="Baku Geki KI-99" TAG="1" /><AIRCRAFT NAME="Baku Geki KI-99" TAG="2" />
        <KEEPEM TAG="1" /></SQUADRON></LIST><ATTACK><SQUADRON><AIRCRAFT NAME="Bell P-39D" TAG="1" />
        <AIRCRAFT NAME="Bell P-39D" TAG="2" /><AIRCRAFT NAME="Bell P-39D" TAG="3" /></SQUADRON>
        <SQUADRON><AIRCRAFT NAME="Baku Geki KI-99" TAG="1" /><AIRCRAFT NAME="Baku Geki KI-99" TAG="2" />
        <AIRCRAFT NAME="Baku Geki KI-99" TAG="3" /></SQUADRON></ATTACK></RET>'  + "\n"
        expected_done = Ret.new([@expected_attacks1], @expected_bomber_list, @air1)
        assert_same(expected_done, @proxyplayer1.player_take_turn(@turn))
    end
    
    def test_proxyplayer_player_take_turn_stack_ret
        STDOUT << "\n" + 'Please input: <TURN-GET-CARDS-FROM-STACK no="2" />
        <RET><AIRCRAFT NAME="Baku Geki KI-99" TAG="1" /><LIST><SQUADRON>
        <AIRCRAFT NAME="Baku Geki KI-99" TAG="1" /><AIRCRAFT NAME="Baku Geki KI-99" TAG="2" />
        <KEEPEM TAG="1" /></SQUADRON></LIST><ATTACK><SQUADRON><AIRCRAFT NAME="Bell P-39D" TAG="1" />
        <AIRCRAFT NAME="Bell P-39D" TAG="2" /><AIRCRAFT NAME="Bell P-39D" TAG="3" /></SQUADRON>
        <SQUADRON><AIRCRAFT NAME="Baku Geki KI-99" TAG="1" /><AIRCRAFT NAME="Baku Geki KI-99" TAG="2" />
        <AIRCRAFT NAME="Baku Geki KI-99" TAG="3" /></SQUADRON></ATTACK></RET>'  + "\n"
        expected_done = Ret.new([@expected_attacks1], @expected_bomber_list, @air1)
        assert_same(expected_done, @proxyplayer1.player_take_turn(@turn))
    end
end
