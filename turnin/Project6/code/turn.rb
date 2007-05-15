# !/arch/unix/bin/ruby

# turn.rb
# First included in Project 5
# Includes all classes for Turn

# Required files
require 'code/card.rb'
require 'code/deck.rb'
require	'code/stack.rb'
require 'code/hand.rb'
require	'code/squadron.rb'

# Data representation of a player's Turn
class Turn
	attr_accessor :deck, :stack, :list_of_squads
	
	# Creates a new instance of a turn with the appropriate member data
	def initialize(deck, stack, list_of_squads)
		@deck = deck
		@stack = stack
		@list_of_squads = list_of_squads
		@card_from = nil
	end

	# Determines if there is a card available on the deck for the Player to draw
	def turn_card_on_deck?
   		!@deck.empty?
   	end

	# Returns the first card on the deck for the Player to add to their hand
	def turn_get_a_card_from_deck
		card = @deck.take
		@card_from = FromDeck.new
		card
	end
	
	# Returns the list of cards in the stack for a Player to insepct
	def turn_stack_inspect
		@stack.list_of_cards
	end

	# Returns the first n cards from the stack for the Player to add to their hand
	def turn_get_cards_from_stack(number)
		list = @stack.take(number)
		@card_from = FromStack.new(number)
		list
	end

	# Return a list of bombers the Player can attack in this turn 
	# List based on the aliiance of a fighter squadron the player has
	# Assumes that the list of squadrons for the turn does not include 
	# squadrons from the player who is taking a turn
	def turn_can_attack?(alliance)
		output = Array.new
		@list_of_squads.each{|x|
            if (x.squadron_alliance.class != alliance.class && x.squadron_bomber?)
                output.push(x)
            end
        }
		output
	end

	# Turn creation method for Administrator
	# Assumption: Administrator will ensure list_of_squads does not include 
	# bombers from the player taking this turn
	def Turn.create_turn(deck, stack, list_of_squads)
		Turn.new(deck, stack, list_of_squads)
	end
	
	# Return a CardsFrom specifying how the player drew cards to start the turn
	# - FromStack(n) is player drew n cards from the stack
	# - FromDeck if the player drew a card from the deck
	def turn_end
		@card_from
	end
	
	# Override of the equal? method that determines if two turns are the same
	# Two turns are said to be the same if the have the same deck, stack
	# and list_of_sqadrons in them
	def equal?(turn)
		return 	@deck.equal?(turn.deck) && 
				@stack.equal?(turn.stack) &&
				Squadron.same_squad_list?(@list_of_squads, turn.list_of_squads)
	end
end

# Data representation of how a player drew cards for their turn
class CardsFrom
	# Creates a new CardsFrom
    def initialize
    end
    
    # Overide of equal? method to determing if two CardsFrom are the same
    def equal?(arg)
    	self.class == arg.class
    end
end

# Data representation of a player drawing n cards from the stack for their turn
class FromStack < CardsFrom
	# Creates a new FromStack
	def initialize(n)
		@n = n
	end
	# Returns the number of cards the player drew
	def how_many_cards?
		return @n
	end
end

# Data representation of a player drawing a card from the deck for their turn
class FromDeck < CardsFrom
	# Creates a new From Deck
    def initialize
    end
end
