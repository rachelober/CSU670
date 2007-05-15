# !/arch/unix/bin/ruby

# squadron.rb
# First included in Project 3
# Includes all the classes to create a Squadron

# Required files
require 'code/card.rb'

class Squadron
	attr_accessor :list_of_cards
	
	# Create Object of type Squadron
    # Takes a List
	def initialize(list_of_cards)
		@list_of_cards = list_of_cards
	end

    # Extract a Aircraft Card from this Squadron
    # Acts on this Squadron and returns an Aircraft Card
	def squadron_first_aircraft
		temp_list = []
        @list_of_cards.each{|x|
            if x.class == Aircraft
                temp_list << x
            end
        }
        temp_list[0]
	end

    # To which Alliance does this Squadron belong?
    # Acts on this Squadron and returns an Alliance
	def squadron_alliance
        self.squadron_first_aircraft.a
	end

    # What is the name of this Squadron?
    # Acts on this Squardon and returns a String
    def squadron_name
        self.squadron_first_aircraft.name
    end

	# Is this Squadron complete?
    # Acts on this Squadron and returns a Boolean
    def squadron_complete?
        @list_of_cards.size == 3
	end

    # Is this Squadron incomplete?
    # Acts on this Squadron and returns a Boolean
	def squadron_incomplete?
		!self.squadron_complete?
	end

    # Is this a Fighter Squadron?
    # Acts on this Squadron and returns a Boolean
    def squadron_fighter?
	    self.squadron_first_aircraft.forb.class == Fighter
	end
	
    # Is this a Bomber Squadron?
    # Acts on this Squadron and returns a Boolean
	def squadron_bomber?
        self.squadron_first_aircraft.forb.class == Bomber
	end
	
    # What is the value of this Squadron?
    # Acts on this Squadron and returns a natural number
	def squadron_value
		if self.squadron_complete?
			return self.squadron_first_aircraft.forb.squadron_value
		else
			return 0
		end
	end
	
	# Returns the number of aircraft cards in the squadron
	def how_many_aircraft?
		count = 0
		@list_of_cards.each{|x|
            if x.class == Aircraft
                count += 1
            end
        }
		count
	end
	
	def add_card(card)
		if (card.class == Aircraft)
			if (card.name == self.squadron_name && @list_of_cards.size < 3)
				return Squadron.new(@list_of_cards.dup.push(card))
			else
				return self
			end
		elsif ((card.class == Keepem or card.class == Victory) && @list_of_cards.size < 3)
			return Squadron.new(@list_of_cards.dup.push(card))
		else
			return self
		end
	end
	
    # Are the Squadrons equal?
    # Acts on a Squadron and takes a Squadron
    # Returns a Boolean
	def equal?(squad)
		result = true
        count = 0
        @list_of_cards.each {|x|
            bool = x.cards_have_same_name?(squad.list_of_cards[count])
            result = result && bool
            count += 1
        }
	    result
    end
	
	# Checks to determine if two lists of squadrons are the same
	def Squadron.same_squad_list?(list1, list2)
		bool = true
		if list1.size != list2.size
			bool = false
		else
			i = 0
			while i < list1.size
				bool2 = list1[i].equal?(list2[i])
				bool = bool && bool2
				i += 1
			end
		end
		return bool
	end
end
