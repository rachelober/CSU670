# !/arch/unix/bin/ruby

# proxyturn.rb
# First included in Project 6
# This is an abstracted class of Turn

# Required modules
require 'modules/dbc.rb'
require 'modules/rtparser.rb'
require 'rexml/document'
include REXML

# Required files
require 'code/stack.rb'
require 'code/turn.rb'
require 'code/xmlhelper.rb'

class ProxyTurn < Turn  
  include DesignByContract
  attr_reader :stack, :list_of_squads
  
  def initialize(is_card_on_deck, stack, list_of_squadrons)
    @is_card_on_deck = is_card_on_deck      # Boolean
    @stack = stack                          # Stack
    @list_of_squadrons = list_of_squadrons  # Array
    @cardsfrom = nil                        # Nil when initialized, CardsFrom later
  end

  # Is there a Card on the Deck?
  #
  # turn_card_on_deck? : ProxyTurn -> Boolean
  post("Output must be kind of Boolean") {|result| result.kind_of?(FalseClass) || result.instance_of?(TrueClass)}
  def turn_card_on_deck?
    @is_card_on_deck
  end

  # Get n number of Cards from the Stack
  #
  # turn_get_cards_from_stack : ProxyTurn NaturalNumber -> List-of-Cards
  pre("Input must be integer between 1 and depth of Stack"){
    |nat| nat >= 1 && nat <= @stack.depth}
  time("Either turn_get_cards_from_stack or turn_get_a_cardsfrom_deck has been called already on this Turn"){
    |nat| @cardsfrom.nil?}
  post("Output must be an instance of Array and all elements must be Cards"){
    |result, nat| result.instance_of?(Array) && result.all? {|card| card.kind_of?(Card)}}
  def turn_get_cards_from_stack(nat)
    mesg = "<TURN-GET-CARDS-FROM-STACK no=\"#{nat}\" />"
    @cardsfrom = FromStack.new(nat)
    puts mesg
    STDOUT.flush

    doc = Document.new
    parser = RealTimeParser.new(STDIN, doc)
    parser.parse
    
    if XMLHelper.xml_okay?(doc)
      @stack.take(nat)
    end
  end

  # turn_get_a_card_from_deck : ProxyTurn -> Card
  #
  # Get the top card from the Deck.
  time("Either turn_get_cards_from_stack or turn_get_a_cardsfrom_deck has been called already on this Turn"){
    @cardsfrom.nil?}
  post("Output must be kind of Card") {|result| result.kind_of?(Card)}
  def turn_get_a_card_from_deck
    mesg = "<TURN-GET-A-CARD-FROM-DECK />"
    @cardsfrom = FromDeck.new
    puts mesg
    STDOUT.flush
    
    doc = Document.new
    parser = RealTimeParser.new(STDIN, doc)
    parser.parse
    
    return Card.xml_to_card(doc)
  end

  # equal? : Turn Turn -> Boolean
  #
  # Override of the equal? method that determines if two turns are the same.
  # Two turns are said to be the same if they have the same Deck, Stack,
  # ListOf-Squadron and CardsFrom.
  def equal?(other)
    @is_card_on_deck == other.turn_card_on_deck? &&
    @stack == other.stack &&
    @list_of_squadrons == other.list_of_squadrons &&
    @cardsfrom == other.cardsfrom
  end

  # ProxyTurn.xml_to_proxyturn : Document -> ProxyTurn
  #
  # Converts the XML into a ProxyTurn.
  def ProxyTurn.xml_to_proxyturn(doc)
    if XPath.match(doc, "//TRUE")
      bool = true
    else
      bool = false
    end
    
    stck = []
    doc.elements.each('TURN/STACK/*'){ |element|
      element = Document.new element.to_s
      stck << Card.xml_to_card(element)
    }
    stck = Stack.new(stck)
    slist = []
    doc.elements.each('TURN/LIST/SQUADRON') {|element|
      element = Document.new element.to_s
      slist << Squadron.xml_to_squad(element)
    }
    
    ProxyTurn.new(bool, stck, slist)
  end
end
