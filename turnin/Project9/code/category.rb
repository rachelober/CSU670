# !/arch/unix/bin/ruby

# category.rb
# First included in Project 3
# This file includes the Category class
# Card is dependant on this class

# A Category keeps track of whether the Aircraft Card is a Fighter or a Bomber.
# Each Category has a value and a squadron_value. These numbers determines what the 
# value of the cards is. If the card is in a Squadron, the program chooses the 
# squadron_value, but if it is in the Hand it determines the amount of points to subtract from
# the Player's score from the value attribute.
class Category
    attr_reader :value, :squadron_value

    # Creates a new Object of type Category.
    # Has a value and squadron_value of 0.
    def initialize
        @value = 0              # Integer
        @squadron_value = 0     # Integer
    end
end

# The Fighter Category has a value of 10 and a squadron_value of 30. Fighter Squadrons
# can be discarded for points. The Player can discard them for more points if another Player
# has placed an opposing Alliance Bomber Squadron already on the table. Other Players cannot
# attack the Fighter Squadron.
# Each Category has a value and a squadron_value. These numbers determines what the 
# value of the cards is. If the card is in a Squadron, the program chooses the 
# squadron_value, but if it is in the Hand it determines the amount of points to subtract from
# the Player's score from the value attribute.
class Fighter < Category
    # Creates a new Category of type Fighter.
    # Has a value of 5.
    # When the Squadron is complete, it has a Squadron value of 15.
    def initialize
        @value = 5              # Integer
        @squadron_value = 15    # Integer
    end 
end

# The Bomber Category has a value of 5 and a squadron_value of 15. Bomber Squadrons can be 
# discarded for points, however may be shot down by other players using Fighters.
# Each Category has a value and a squadron_value. These numbers determines what the 
# value of the cards is. If the card is in a Squadron, the program chooses the 
# squadron_value, but if it is in the Hand it determines the amount of points to subtract from
# the Player's score from the value attribute.
class Bomber < Category
    # Creates a new Category of type Bomber.
    # Has a value of 10.
    # When the Squadron is complete, it has a Squadron value of 30.
    def initialize
        @value = 10             # Integer
        @squadron_value = 30    # Integer
    end
end
