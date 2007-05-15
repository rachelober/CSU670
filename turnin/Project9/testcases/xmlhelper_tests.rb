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

        # Game Deck for building Turns
        @deck = Deck.create

        # Stack used to create a turn
        @stack = Stack.new([@air6, @keep2, @vic1])

        # Squadron to be used to build a Turn's list_of_squads
        @list_of_squads = [Squadron.new([@air1, @air2, @air3])]

        # Generic turn for method testing
        @turn = Turn.new(@deck, @stack, @list_of_squads)
    end

    def test_xml_to_card_aircraft
        aircraft = "<AIRCRAFT NAME=\"Baku Geki KI-99\" TAG=\"1\" />"
        doc = Document.new aircraft
        assert_same(@air1, XMLHelper.xml_to_card(doc))
    end

    def test_xml_to_card_keepem
        keepem = "<KEEPEM TAG=\"1\" />"
        doc = Document.new keepem
        assert_same(@keep1, XMLHelper.xml_to_card(doc))
    end

    def test_xml_to_card_victory
        victory = "<VICTORY />"
        doc = Document.new victory
        assert_same(@vic1, XMLHelper.xml_to_card(doc))
    end

    def test_xml_okay?
        okay = "<OKAY />"
        not_okay = "<NOTOKAY />"

        doc = Document.new okay
        ndoc = Document.new not_okay
        
        assert(XMLHelper.xml_okay?(doc))
        assert(!XMLHelper.xml_okay?(ndoc))
    end

    def test_xml_to_done
        ret_doc = Document.new File.new("xmltests/ret_test.xml")
        end_doc = Document.new File.new("xmltests/end_test.xml")

        expected_ret = Ret.new(
            [Attack.new(Squadron.new([@air13, @air14, @air15]), Squadron.new([@air7, @air8, @air9])),
            Attack.new(Squadron.new([@air16, @air17, @air18]), Squadron.new([@air19, @air20, @air21]))],
            [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @air6])], @vic1)
        expected_end = End.new(
            [Attack.new(Squadron.new([@air13, @air14, @air15]), Squadron.new([@air7, @air8, @air9])),
            Attack.new(Squadron.new([@air16, @air17, @air18]), Squadron.new([@air19, @air20, @air21]))],
            [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @air6])], nil)
        
        assert_same(expected_ret, XMLHelper.xml_to_done(ret_doc))
        assert_same(expected_end, XMLHelper.xml_to_done(end_doc))
    end

    def test_xml_to_squadron
        squad_xml = "<SQUADRON>
        <AIRCRAFT NAME=\"Bell P-39D\" TAG=\"1\" />
        <AIRCRAFT NAME=\"Bell P-39D\" TAG=\"2\" />
        <AIRCRAFT NAME=\"Bell P-39D\" TAG=\"3\" />
        </SQUADRON>"
        
        squad_test = Document.new squad_xml
        
        assert_equal(Squadron.new([@air4, @air5, @air6]), XMLHelper.xml_to_squad(squad_test))
    end

    def test_xml_to_fsth
        fsth_doc = Document.new File.new("xmltests/fsth_test.xml")

        expected_fsth = Hand.new([@vic1, @keep1, @keep3, @keep5, @air1, @air2, @air3])

        assert_same(expected_fsth, XMLHelper.xml_to_fsth(fsth_doc))
    end

    def test_xml_to_pturn
        turn_doc = Document.new File.new("xmltests/turn_test.xml")

        ex_bool = true
        ex_stck = Stack.new([@vic1])
        ex_slist = 
            [Squadron.new([@air19, @air20, @air21]),
            Squadron.new([@air7, @air8, @air9])]
        
        bool, stck, slist = XMLHelper.xml_to_pturn(turn_doc)
    
        assert_same(ex_bool, bool)
        assert_same(ex_stck, stck)
        assert_equal(ex_slist, slist)
    end

    def test_xml_to_turn
        turn_doc = Document.new File.new("xmltests/xturn_test.xml")

        deck = Deck.new([@vic1])
        stack = Stack.new([@vic1])
        list_of_squads = 
            [Squadron.new([@air19, @air20, @air21]),
            Squadron.new([@air7, @air8, @air9])]
        
        expected_turn = Turn.new(deck, stack, list_of_squads)

        assert_same(expected_turn, XMLHelper.xml_to_turn(turn_doc))
    end

    def test_card_to_xml
        ex_air = '<AIRCRAFT NAME="Baku Geki KI-99" TAG="1" />'
        ex_keep = '<KEEPEM TAG="1" />'
        ex_vic = "<VICTORY />"

        assert_equal(ex_air, XMLHelper.card_to_xml(@air1))
        assert_equal(ex_keep, XMLHelper.card_to_xml(@keep1))
        assert_equal(ex_vic, XMLHelper.card_to_xml(@vic1))
    end

#    def test_done_to_xml
#        ex_ret = Document.new File.new("xmltests/ret_test.xml")
#        ex_ret = ex_ret.to_s
#        ex_end = Document.new File.new("xmltests/end_test.xml")
#        ex_end = ex_end.to_s
#
#        list_of_discards = [Squadron.new([@air1, @air2, @air3]), 
#            Squadron.new([@air4, @air5, @air6])]
#        list_of_attacks = 
#            [Attack.new(Squadron.new([@air13, @air14, @air15]), Squadron.new([@air7, @air8, @air9])),
#            Attack.new(Squadron.new([@air16, @air17, @air18]), Squadron.new([@air19, @air20, @air21]))]
#            
#        ret_test = Ret.new(list_of_attacks, list_of_discards, @vic1)
#        end_test = End.new(list_of_attacks, list_of_discards, @vic1)
#
#        assert_equal(ex_ret, XMLHelper.done_to_xml(ret_test))
#        assert_equal(ex_end, XMLHelper.done_to_xml(end_test))
#    end

    def test_boolean_to_xml
        ex_true = "<TRUE />"
        ex_false = "<FALSE />"

        assert_equal(ex_true, XMLHelper.boolean_to_xml(true))
        assert_equal(ex_false, XMLHelper.boolean_to_xml(false))
    end

    def test_squadron_to_xml
        ex_norm = "<SQUADRON><AIRCRAFT NAME=\"Baku Geki KI-99\" TAG=\"1\" /><AIRCRAFT NAME=\"Baku Geki KI-99\" TAG=\"2\" /><AIRCRAFT NAME=\"Baku Geki KI-99\" TAG=\"3\" /></SQUADRON>"
        ex_empty = "<SQUADRON />"

        norm = Squadron.new([@air1, @air2, @air3])
        empty = Squadron.new([])

        assert_equal(ex_norm, XMLHelper.squadron_to_xml(norm))
        assert_equal(ex_empty, XMLHelper.squadron_to_xml(empty))
    end

    def test_attack_to_xml
        ex_norm = "<ATTACK><SQUADRON><AIRCRAFT NAME=\"Curtiss P-40E\" TAG=\"1\" /><AIRCRAFT NAME=\"Curtiss P-40E\" TAG=\"2\" /><AIRCRAFT NAME=\"Curtiss P-40E\" TAG=\"3\" /></SQUADRON><SQUADRON><AIRCRAFT NAME=\"Dornier Do 26\" TAG=\"1\" /><AIRCRAFT NAME=\"Dornier Do 26\" TAG=\"2\" /><AIRCRAFT NAME=\"Dornier Do 26\" TAG=\"3\" /></SQUADRON></ATTACK>"
        ex_empty = "<ATTACK />"

        norm = Attack.new(Squadron.new([@air13, @air14, @air15]), Squadron.new([@air7, @air8, @air9]))
        empty = Attack.new(Squadron.new([]), Squadron.new([]))

        assert_equal(ex_norm, XMLHelper.attack_to_xml(norm))
        assert_equal(ex_empty, XMLHelper.attack_to_xml(empty))
    end

    def test_cardsfrom_to_xml
        ex_stack =  "<STACK NO=\"3\"/>"
        ex_deck = "<DECK />"

        from_stack = FromStack.new(3)
        from_deck = FromDeck.new()

        assert_equal(ex_stack, XMLHelper.cardsfrom_to_xml(from_stack))
        assert_equal(ex_deck, XMLHelper.cardsfrom_to_xml(from_deck))
    end
end
