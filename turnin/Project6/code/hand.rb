# !/arch/unix/bin/ruby

# hand.rb
# First included in Project 3
# Includes all the classes to create a Hand

# Required files
require 'code/card.rb'

class Hand
    attr_accessor :list_of_cards
    # Create Object of type Hand
    # Takes a List of Cards
	def initialize(list_of_cards)
		@list_of_cards = list_of_cards
	end

    # Creates a Hand
    # Takes a List of Cards and returns a Hand
	def Hand.create(list_of_cards)
		Hand.new(list_of_cards)
	end
	
    # Converts this Hand to a List
    # Acts on this Hand and returns a List
    def hand_to_list
		@list_of_cards
	end

    # How many cards are on this Hand?
    # Acts on this Hand and returns an Integer
 	def size
 		@list_of_cards.size
 	end
 	
    # Determines the value of a Hand
    # Acts on this Hand and returns an Integer
	def value
		score = 0
		@list_of_cards.each{|x| score += x.card_value}
		score
	end
	
	# Determines the Squardons on this hand
	# Acts on this Hand and returns a list of Squadrons
	def completes
		temp_list = @list_of_cards.dup
		output = Array.new()
		i = 0
		while i < temp_list.size
			squad = Array.new()
			squad.push(temp_list.shift)
			temp_list.each{|x| if squad[0].cards_have_same_name?(x)
										squad.push(x) 
										end}
			temp_list.each_index{|x| if squad[0].cards_have_same_name?(temp_list[x])
										temp_list.delete_at(x) 
										end}
			if squad.size == 3
				output.push(Squadron.new(squad))
				i+=1
			else
				i+=1
			end
		end
		output
	end
			
    # Determines the available WildCards on a Hand
    # Acts on this Hand and returns a List of WildCards
	def wildcards
		list = @list_of_cards.dup
		list.delete_if{|x| x.class == Aircraft}
		list
	end

    # Which Squadrons can benefit from one or two WildCards
    # Acts on this Hand and returns a List of Squadrons
    def complementable
		temp_hand = self.dup 
        # Get rid of wildcards in hand
        wildcards = temp_hand.wildcards
        temp_hand = temp_hand.minus(wildcards)
        # Get rid of completed squads in hand
        completed_squads = temp_hand.completes
        completed = []
        completed_squads.each{|x|
            completed.push(x.list_of_cards)
        }
        completed.flatten!
        # Now we only have aircrafts of incomplete squadrons in an Array
        only_aircrafts = temp_hand.minus(completed).hand_to_list
        
        output = Array.new()
        only_aircrafts.each{|x|
            squad = Array.new
            squad.push(only_aircrafts.shift)
            only_aircrafts.each{|x|
                if squad[0].cards_have_same_name?(x)
                    squad.push(x)
                    only_aircrafts.shift
                end
            }
            if squad.size < 3
                if squad.size == 2 && wildcards.size >=1
                    squad.push(wildcards.shift)
                elsif squad.size == 1 && wildcards.size >=2
                    squad.push(wildcards.shift).push(wildcards.shift)
                end
                
                if squad.size == 3
                    output.push(Squadron.new(squad))
                end
            end
        }
        
		output = output.sort {|x,y| x.how_many_aircraft? > y.how_many_aircraft?}
	end
	
	# (plus h c) creates a hand from h and c
	# Takes a List of Cards and acts on this Hand
    # Returns a new Hand
    def plus(list)
		Hand.create(@list_of_cards.dup + list)
	end
	
	# (minus h c) creates a hand by removing c from h 
	# Takes a List of Cards and acts on this Hand
    # Returns a new Hand
    def minus(list)
		temp_list = @list_of_cards.dup
		list.each{|x| temp_list.delete_at(temp_list.index(x))}
		Hand.create(temp_list)
	end

    # Are these two hands equal?
    # Takes a Hand and acts on this hand
    # Returns a Boolean
	def equal?(hand)
		@list_of_cards.eql?(hand.hand_to_list)
	end
end
