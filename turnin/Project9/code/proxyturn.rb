# !/arch/unix/bin/ruby

# proxyturn.rb
# First included in Project 6
# This is an abstracted class of Turn

# Required modules
require 'modules/rtparser.rb'

# Required files
require 'code/turn.rb'
require 'code/xmlhelper.rb'
require 'rexml/document'
include REXML

class ProxyTurn < Turn    
    include DesignByContract
    attr_reader :list_of_squads
    def initialize(is_card_on_deck, stack, list_of_squadrons)
        @is_card_on_deck = is_card_on_deck
        @stack = stack
        @list_of_squadrons = list_of_squadrons
        @card_from = nil
    end

    post("Output must be kind of Boolean") {|result| result.kind_of?(FalseClass) || result.instance_of?(TrueClass)}
    # Is there a Card on the Deck?
    # turn_card_on_deck? : ProxyTurn -> Boolean
    def turn_card_on_deck?
        @is_card_on_deck
    end

    pre(:turn_get_cards_from_stack, "Input must be integer between 1 and depth of Stack"){
        |nat| nat >= 1}
    pre(:turn_get_cards_from_stack, "Either turn_get_cards_from_stack or turn_get_a_card_from_deck has been called already on this Turn"){|nat| @card_from.nil?}
    post("Output must be an instance of Array and all elements must be Cards"){|result, nat| result.instance_of?(Array) && result.all? {|card| card.kind_of?(Card)}}
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

    pre(:turn_get_a_card_from_deck, "Either turn_get_cards_from_stack or turn_get_a_card_from_deck has been called already on this Turn"){@card_from.nil?}
    post("Output must be kind of Card") {|result| result.kind_of?(Card)}
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
