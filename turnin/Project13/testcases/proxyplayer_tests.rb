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
        @keep1 = Keepem.new(Image.new("keepem.gif"), 1)
        @keep2 = Keepem.new(Image.new("keepem.gif"), 2)
        @keep3 = Keepem.new(Image.new("keepem.gif"), 3)
        @keep4 = Keepem.new(Image.new("keepem.gif"), 4)
        @keep5 = Keepem.new(Image.new("keepem.gif"), 5)
        @keep6 = Keepem.new(Image.new("keepem.gif"), 6)
        @vic1 = Victory.new(Image.new("victory.gif"))
        
        @stack = Stack.new([@air4, @air5, @air6])
        @deck = Deck.list_to_deck([@air4, @air5, @air6])
        @list_of_squads = [Squadron.new([@air1, @air2, @air3])]
        
        @turn = Turn.new(@deck, @stack, @list_of_squads)

        @proxyplayer1 = ProxyPlayer.new('Rachel')
        @proxyplayer2 = ProxyPlayer.new('Kait')

        @proxyplayer1.player_first_hand([@air1, @air2, @air3, @keep1, @keep3, @keep4])
        
        @expected_attacks1 = Attack.new(Squadron.new([@air10, @air11, @air12]), Squadron.new([@air1, @air2, @air3]))
        @expected_attacks2 = Attack.new(Squadron.new([@air10, @air11, @air12]), Squadron.new([@air1, @air2, @air3]))
        @expected_attacks3 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))
        @expected_bomber_list = [Squadron.new([@air1, @air2, @keep1])]
        @expected_bomber_list2 = [Squadron.new([@air1, @air2, @keep1])]
    end

    def test_proxyplayer_player_take_turn_deck_end_nil
        mesg = Document.new
        root = mesg.add_element "TURN-GET-A-CARD-FROM-DECK"

        done = Document.new
        root = done.add_element "END"
        root.add_element "FALSE"
        slst = root.add_element "LIST"
        squadron = slst.add_element "SQUADRON"
        squadron.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"1"}
        squadron.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"2"}
        squadron.add_element "KEEPEM", {"TAG"=>"1"}
        attk = root.add_element "ATTACK"
        fighter = attk.add_element "SQUADRON"
        fighter.add_element "AIRCRAFT", {"NAME"=>"Brewster F2A-3", "TAG"=>"1"}
        fighter.add_element "AIRCRAFT", {"NAME"=>"Brewster F2A-3", "TAG"=>"2"}
        fighter.add_element "AIRCRAFT", {"NAME"=>"Brewster F2A-3", "TAG"=>"3"}
        bomber = attk.add_element "SQUADRON"
        bomber.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"1"}
        bomber.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"2"}
        bomber.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"3"}

        STDOUT << "\n" + "Please input: " + mesg.to_s + done.to_s
        
        expected_done = End.new([@expected_attacks1], @expected_bomber_list, nil)
        expected_done2 = End.new([@expected_attacks2], @expected_bomber_list2, nil)

        assert_same(expected_done, expected_done2)
        assert_same(expected_done, @proxyplayer1.player_take_turn(@turn))
    end

    def test_proxyplayer_player_take_turn_stack_end_nil
        mesg = Document.new
        root = mesg.add_element "TURN-GET-CARDS-FROM-STACK", {"no"=>"2"}

        done = Document.new
        root = done.add_element "END"
        root.add_element "FALSE"
        slst = root.add_element "LIST"
        squadron = slst.add_element "SQUADRON"
        squadron.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"1"}
        squadron.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"2"}
        squadron.add_element "KEEPEM", {"TAG"=>"1"}
        attk = root.add_element "ATTACK"
        fighter = attk.add_element "SQUADRON"
        fighter.add_element "AIRCRAFT", {"NAME"=>"Brewster F2A-3", "TAG"=>"1"}
        fighter.add_element "AIRCRAFT", {"NAME"=>"Brewster F2A-3", "TAG"=>"2"}
        fighter.add_element "AIRCRAFT", {"NAME"=>"Brewster F2A-3", "TAG"=>"3"}
        bomber = attk.add_element "SQUADRON"
        bomber.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"1"}
        bomber.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"2"}
        bomber.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"3"}

        STDOUT << "\n" + "Please input: " + mesg.to_s + done.to_s
        
        expected_done = End.new([@expected_attacks1], @expected_bomber_list, nil)
        assert_same(expected_done, @proxyplayer1.player_take_turn(@turn))
    end

    def test_proxyplayer_player_take_turn_deck_end_card
        mesg = Document.new
        root = mesg.add_element "TURN-GET-A-CARD-FROM-DECK"

        done = Document.new
        root = done.add_element "END"
        root.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"1"}
        slst = root.add_element "LIST"
        squadron = slst.add_element "SQUADRON"
        squadron.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"1"}
        squadron.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"2"}
        squadron.add_element "KEEPEM", {"TAG"=>"1"}
        attk = root.add_element "ATTACK"
        fighter = attk.add_element "SQUADRON"
        fighter.add_element "AIRCRAFT", {"NAME"=>"Brewster F2A-3", "TAG"=>"1"}
        fighter.add_element "AIRCRAFT", {"NAME"=>"Brewster F2A-3", "TAG"=>"2"}
        fighter.add_element "AIRCRAFT", {"NAME"=>"Brewster F2A-3", "TAG"=>"3"}
        bomber = attk.add_element "SQUADRON"
        bomber.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"1"}
        bomber.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"2"}
        bomber.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"3"}

        STDOUT << "\n" + "Please input: " + mesg.to_s + done.to_s
        
        expected_done = End.new([@expected_attacks1], @expected_bomber_list, @air1)
        assert_same(expected_done, @proxyplayer1.player_take_turn(@turn))
    end

    def test_proxyplayer_player_take_turn_stack_end_card
        mesg = Document.new
        root = mesg.add_element "TURN-GET-CARDS-FROM-STACK", {"no"=>"2"}

        done = Document.new
        root = done.add_element "END"
        root.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"1"}
        slst = root.add_element "LIST"
        squadron = slst.add_element "SQUADRON"
        squadron.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"1"}
        squadron.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"2"}
        squadron.add_element "KEEPEM", {"TAG"=>"1"}
        attk = root.add_element "ATTACK"
        fighter = attk.add_element "SQUADRON"
        fighter.add_element "AIRCRAFT", {"NAME"=>"Brewster F2A-3", "TAG"=>"1"}
        fighter.add_element "AIRCRAFT", {"NAME"=>"Brewster F2A-3", "TAG"=>"2"}
        fighter.add_element "AIRCRAFT", {"NAME"=>"Brewster F2A-3", "TAG"=>"3"}
        bomber = attk.add_element "SQUADRON"
        bomber.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"1"}
        bomber.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"2"}
        bomber.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"3"}

        STDOUT << "\n" + "Please input: " + mesg.to_s + done.to_s
        
        expected_done = End.new([@expected_attacks1], @expected_bomber_list, @air1)
        assert_same(expected_done, @proxyplayer1.player_take_turn(@turn))
    end

    def test_proxyplayer_player_take_turn_deck_ret
        mesg = Document.new
        root = mesg.add_element "TURN-GET-A-CARD-FROM-DECK"

        done = Document.new
        root = done.add_element "RET"
        root.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"1"}
        slst = root.add_element "LIST"
        squadron = slst.add_element "SQUADRON"
        squadron.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"1"}
        squadron.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"2"}
        squadron.add_element "KEEPEM", {"TAG"=>"1"}
        attk = root.add_element "ATTACK"
        fighter = attk.add_element "SQUADRON"
        fighter.add_element "AIRCRAFT", {"NAME"=>"Brewster F2A-3", "TAG"=>"1"}
        fighter.add_element "AIRCRAFT", {"NAME"=>"Brewster F2A-3", "TAG"=>"2"}
        fighter.add_element "AIRCRAFT", {"NAME"=>"Brewster F2A-3", "TAG"=>"3"}
        bomber = attk.add_element "SQUADRON"
        bomber.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"1"}
        bomber.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"2"}
        bomber.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"3"}

        STDOUT << "\n" + "Please input: " + mesg.to_s + done.to_s
        
        expected_done = Ret.new([@expected_attacks1], @expected_bomber_list, @air1)
        assert_same(expected_done, @proxyplayer1.player_take_turn(@turn))
    end
    
    def test_proxyplayer_player_take_turn_stack_ret
        mesg = Document.new
        root = mesg.add_element "TURN-GET-CARDS-FROM-STACK", {"no"=>"2"}

        done = Document.new
        root = done.add_element "RET"
        root.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"1"}
        slst = root.add_element "LIST"
        squadron = slst.add_element "SQUADRON"
        squadron.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"1"}
        squadron.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"2"}
        squadron.add_element "KEEPEM", {"TAG"=>"1"}
        attk = root.add_element "ATTACK"
        fighter = attk.add_element "SQUADRON"
        fighter.add_element "AIRCRAFT", {"NAME"=>"Brewster F2A-3", "TAG"=>"1"}
        fighter.add_element "AIRCRAFT", {"NAME"=>"Brewster F2A-3", "TAG"=>"2"}
        fighter.add_element "AIRCRAFT", {"NAME"=>"Brewster F2A-3", "TAG"=>"3"}
        bomber = attk.add_element "SQUADRON"
        bomber.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"1"}
        bomber.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"2"}
        bomber.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"3"}

        STDOUT << "\n" + "Please input: " + mesg.to_s + done.to_s
        
        expected_done = Ret.new([@expected_attacks1], @expected_bomber_list, @air1)
        assert_same(expected_done, @proxyplayer1.player_take_turn(@turn))
    end
end
