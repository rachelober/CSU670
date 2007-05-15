# !/arch/unix/bin/ruby

# proxyturn.rb
# First included in Project 6
# This is an abstracted class of Turn

# Required files
require 'code/turn.rb'
require 'code/xmlhelper.rb'
require 'rexml/document'
require 'code/rtparser.rb'
include REXML

class ProxyTurn < Turn    
    def initialize(is_card_on_deck, stack, list_of_squads)
        @is_card_on_deck = is_card_on_deck
        @stack = stack
        @list_of_squads = list_of_squads
        @card_from = nil
    end

    # Is there a Card on the Deck?
    # turn_card_on_deck? : ProxyTurn -> Boolean
    def turn_card_on_deck?
        @is_card_on_deck
    end
    
    # Get n number of Cards from the Stack
    # turn_get_cards_from_stack : ProxyTurn NaturalNumber -> List-of-Cards
    def turn_get_cards_from_stack(nat)
        mesg = "<TURN-GETS-CARDS-FROM-STACK no=#{nat} />"
        @card_from = FromStack.new(nat)
        STDOUT << mesg
        STDOUT.flush

        doc = Document.new
        parser = Parsers::RealTimeParser.new(STDIN, doc)
        parser.parse

        if XMLHelper.xml_okay?(doc)
            @stack.take(nat)
        end
    end

    # Get the top card from the Deck
    # turn_get_a_card_from_deck : ProxyTurn -> Card
    def turn_get_a_card_from_deck
        mesg = "<TURN-GET-A-CARD-FROM-DECK />"
        @card_from = FromDeck.new
        STDOUT << mesg
        STDOUT.flush
        
        doc = Document.new
        parser = Parsers::RealTimeParser.new(STDIN, doc)
        parser.parse
        
        output = XMLHelper.xml_to_card(doc)
    end
end
