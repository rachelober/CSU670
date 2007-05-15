# !/arch/unix/bin/ruby

# turn.rb
# First included in Project 5
# Includes all classes for Turn

# Required files
require	'code/cardsfrom.rb'
require 'code/deck.rb'
require 'code/stack.rb'

# Data representation of a Player's Turn.
# A Turn is made up of a Deck, Stack, ListOf-Squadron played by
# other Players and a CardsFrom that keeps track of where the
# Player has taken his card(s) from.
class Turn
  include DesignByContract
  attr_reader :cardsfrom, :deck, :stack, :list_of_squadrons

  # new : Deck Stack ListOf-Squadron -> Turn
  #	
  # Creates a new instance of a turn with the appropriate member data.
  def initialize(deck, stack, list_of_squadrons)
    @deck = deck
    @stack = stack
    @list_of_squadrons = list_of_squadrons
    @cardsfrom = nil
  end

  # turn_card_on_deck? : Turn -> Boolean
  #
  # Determines if there is a card available on the deck for the Player to draw.
  post(:turn_card_on_deck?, "Must return Boolean."){|result| 
    result.kind_of?(FalseClass) || result.instance_of?(TrueClass)}
  def turn_card_on_deck?
    !@deck.empty?
  end

  # turn_get_a_card_from_deck : Turn -> Card
  #
  # Returns the first card on the deck for the Player to add to their hand.
  time(:turn_get_a_card_from_deck, 
    "Either turn_get_cards_from_stack or turn_get_a_card_from_deck has been called already on this Turn."){
    @cardsfrom.nil?}
  post(:turn_get_a_card_from_deck, "Must return a Card."){|result| result.kind_of?(Card)}
  def turn_get_a_card_from_deck
    @cardsfrom = FromDeck.new
    @deck.take
  end
	
  # turn_stack_inspect : Turn -> ListOf-Card
  #
  # Returns the list of cards in the stack for a Player to inspect.
  post(:turn_stack_inspect, "Must return an Array."){|result| result.instance_of?(Array)}
  def turn_stack_inspect
    @stack.list_of_cards
  end

  # turn_get_cards_from_stack : Stack Integer -> ListOf-Card
  #
  # Returns the first n cards from the stack for the Player to add to their hand
  pre(:turn_get_cards_from_stack, "Input must be integer between 1 and depth of Stack."){
    |n| n >= 1 && n <= @stack.depth}
  time(:turn_get_cards_from_stack, 
    "Either turn_get_cards_from_stack or turn_get_a_card_from_deck has been called already on this Turn."){
    |n| @cardsfrom.nil?}
  post(:turn_get_cards_from_stack, "Output must be an instance of Array and all elements must be Cards."){
    |result, n| result.instance_of?(Array) && result.all? {|card| card.kind_of?(Card)}}
  def turn_get_cards_from_stack(n)
    @cardsfrom = FromStack.new(n)
    @stack.take(n)
  end

  # turn_can_attack? : Turn Alliance -> ListOf-Squadron
  #
  # Returns a list of Bomber Squadron that the given Alliance can attack on this turn.
  pre(:turn_can_attack, "Input must be instance of Alliance."){|alliance| a.alliance?}
  post(:turn_can_attack, "Output must be an instance of an Array and all elements must be Squadrons.") {
    |result, alliance| result.instance_of?(Array) && result.all? {|squad| squad.instance_of?(Squadron)}}
  post("Not all returned Squadrons were opposing Alliance."){|result, alliance| result.all? {
    |squadron| squadron.squadron_alliance != alliance}}
  def turn_can_attack?(alliance)
    @list_of_squadrons.find_all {|squadron|
      squadron.squadron_alliance.class != alliance.class && squadron.squadron_bomber?
    }
  end

  # create_turn : Deck Stack ListOf-Squadron -> Turn
  #
  # Turn creation method for Administrator.
  pre(:create_turn, "Input must be instance of Deck."){|deck, stack, list_of_squadrons| 
    deck.instance_of?(Deck)}
  pre(:create_turn, "Input must be instances of Stack."){|deck, stack, list_of_squadrons| 
    stack.instance_of?(Stack)} 
  pre(:create_turn, "Input must be ListOf-Squadron."){|deck, stack, list_of_squadrons| 
    list_of_squadrons.instance_of?(Array) && 
    list_of_squad.all? {|squad| squad.instance_of?(Squadron)}}
  post(:create_turn, "Output was not an instance of Turn.") {
    |result, deck, stack, list_of_squadrons| result.instance_of?(Turn)}
  def Turn.create_turn(deck, stack, list_of_squadrons)
    Turn.new(deck, stack, list_of_squadrons)
  end

  # turn_end : Turn -> CardsFrom
  #
  # Return a CardsFrom specifying how the player drew cards to start the turn.
  # * FromStack(n) is player drew n cards from the stack.
  # * FromDeck if the player drew a card from the deck.
  # This is part of the Administrator Interface.
  time(:turn_end, "Must take place after get-cards-from-stack or get-a-card-from-deck has been called."){
    !@cardsfrom.nil?}
  post(:turn_end, "Output must be a kind of CardsFrom.") {|result| result.kind_of?(CardsFrom)}
  def turn_end
    @cardsfrom
  end
	
  # equal? : Turn Turn -> Boolean
  #
  # Override of the equal? method that determines if two turns are the same.
  # Two turns are said to be the same if they have the same Deck, Stack,
  # ListOf-Squadron and CardsFrom.
  pre(:equal?, "Input must be another Turn."){|other| turn.kind_of?(Turn)}
  post(:equal?, "Output must be a Boolean.") {
    |result, other| result.instance_of?(TrueClass) || result.instance_of?(FalseClass)}
  def equal?(other)
    @deck == other.deck &&
    @stack == other.stack &&
    @list_of_squadrons == other.list_of_squadrons &&
    @cardsfrom == other.cardsfrom
  end

  # turn_to_xml : Turn -> Document
  #
  # Converts a Turn into an XML Document.
  def turn_to_xml
    document = Document.new
    turn = document.add_element "TURN"
    if turn_card_on_deck?
      turn.add_element "TRUE"
    else
      turn.add_element "FALSE"
    end
    turn.add_element @stack.stack_to_xml
    turn.add_element XMLHelper.slst_to_xml(turn_can_attack?(Axis.new))
    turn.add_element XMLHelper.slst_to_xml(turn_can_attack?(Allies.new))

    document
  end

  # Turn.xml_to_turn : Document -> Turn
  #
  # Converts the XML Document into a Turn.
  def Turn.xml_to_turn(doc)
    # Loaded array
    # This will take care of both stack and deck
    # So array has two elements, the first being the deck 
    # and the second taking care of the stack
    stack_and_deck = []
    doc.elements.each('TURN/STACK'){|stack|
      entry = []
      stack.elements.each('*'){|element|
        element = Document.new element.to_s
        entry << Card.xml_to_card(element)
      }
      stack_and_deck << entry
    }
    deck = Deck.list_to_deck(stack_and_deck[0])
    stack = Stack.new(stack_and_deck[1])

    list_of_squads = []
    doc.elements.each('TURN/LIST/SQUADRON'){|element|
      element = Document.new element.to_s
      list_of_squads << Squadron.xml_to_squad(element)
    }

    Turn.new(deck, stack, list_of_squads)
  end
end
