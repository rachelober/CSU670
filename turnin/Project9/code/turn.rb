# !/arch/unix/bin/ruby

# turn.rb
# First included in Project 5
# Includes all classes for Turn

# Required files
require	'code/cardsfrom.rb'

# Required Modules
require 'modules/dbc.rb'

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

    post(:turn_card_on_deck?, "Must return true or false"){|result| result.kind_of?(FalseClass) || result.instance_of?(TrueClass)}
    # turn_card_on_deck? : Turn -> Boolean
    #
	# Determines if there is a card available on the deck for the Player to draw.
	def turn_card_on_deck?
   		!@deck.empty?
   	end

    pre(:turn_get_a_card_from_deck, "Either turn_get_cards_from_stack or turn_get_a_card_from_deck has been called already on this Turn"){@cardsfrom.nil?}
    post(:turn_get_a_card_from_deck, "Must return a Card"){|result| result.kind_of?(Card)}
    # turn_get_a_card_from_deck : Turn -> Card
    #
	# Returns the first card on the deck for the Player to add to their hand.
	def turn_get_a_card_from_deck
		@cardsfrom = FromDeck.new
		@deck.take
    end
	
    post(:turn_stack_inspect, "Must return an Array"){|result| result.instance_of?(Array)}
    # turn_stack_inspect : Turn -> ListOf-Card
    #
	# Returns the list of cards in the stack for a Player to inspect.
	def turn_stack_inspect
		@stack.list_of_cards
	end

    pre(:turn_get_cards_from_stack, "Input must be integer between 1 and depth of Stack"){|n| n >= 1 && n <= @stack.depth}
    pre(:turn_get_cards_from_stack, "Either turn_get_cards_from_stack or turn_get_a_card_from_deck has been called already on this Turn"){|n| @cardsfrom.nil?}
    post(:turn_get_cards_from_stack, "Output must be an instance of Array and all elements must be Cards"){|result, n| result.instance_of?(Array) && result.all? {|card| card.kind_of?(Card)}}
    # turn_get_cards_from_stack : Stack Integer -> ListOf-Card
    #
	# Returns the first n cards from the stack for the Player to add to their hand
	def turn_get_cards_from_stack(n)
		@cardsfrom = FromStack.new(n)
        @stack.take(n)
	end

    pre(:turn_can_attack, "Input must be instance of Alliance"){|alliance| a.kind_of?(Alliance)}
    post(:turn_can_attack, "Output must be an instance of an Array and all elements must be Squadrons") {|result, alliance| result.instance_of?(Array) && result.all? {|squad| squad.instance_of?(Squadron)}}
    post("Not all returned Squadrons were opposing Alliance"){|result, alliance| result.all? {|squadron| squadron.squadron_alliance != alliance}}
    # turn_can_attack : Turn Alliance -> ListOf-Squadron
    #
	# Return a list of Bomber Squadron the Player can attack on this turn. 
	# The list returned is based on the Alliance of Fighter Squadrons
    # the Player has in his Hand.
	def turn_can_attack?(alliance)
		@list_of_squadrons.find_all {|squadron|
        squadron.squadron_alliance.class != alliance.class && squadron.squadron_bomber?
    }
	end

    pre(:create_turn, "Input must be instances of Deck, Stack and Array of Squadron"){
    |deck, stack, list_of_squadrons| deck.instance_of?(Deck) && 
    stack.instance_of?(Stack) && 
    list_of_squadrons.instance_of?(Array) && 
    list_of_squad.all? {|squad| squad.instance_of?(Squadron)}}
    post(:create_turn, "Output was not an instance of Turn") {|result, deck, stack, list_of_squadrons| result.instance_of?(Turn)}
    # create_turn : Deck Stack ListOf-Squadron -> Turn
    #
	# Turn creation method for Administrator.
	def Turn.create_turn(deck, stack, list_of_squadrons)
		Turn.new(deck, stack, list_of_squadrons)
	end

    pre(:turn_end, "Must take place after get-cards-from-stack or get-a-card-from-deck has been called"){!@cardsfrom.nil?}
    post(:turn_end, "Output must be a kind of CardsFrom") {|result| result.kind_of?(CardsFrom)}
    # turn_end : Turn -> CardsFrom
    #
	# Return a CardsFrom specifying how the player drew cards to start the turn.
	# * FromStack(n) is player drew n cards from the stack
	# * FromDeck if the player drew a card from the deck
	def turn_end
		@cardsfrom
	end
	
    pre(:equal?, "Input must be another Turn"){|other| turn.kind_of?(Turn)}
    post(:equal?, "Output must be a Boolean") {|result, other| result.instance_of?(TrueClass) || result.instance_of?(FalseClass)}
    # equal? : Turn Turn -> Boolean
    #
	# Override of the equal? method that determines if two turns are the same.
	# Two turns are said to be the same if they have the same Deck, Stack,
    # ListOf-Squadron and CardsFrom.
	def equal?(other)
		@deck == other.deck &&
        @stack == other.stack &&
        @list_of_squadrons == other.list_of_squadrons &&
        @cardsfrom == other.cardsfrom
	end
end
