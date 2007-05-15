# !/arch/unix/bin/ruby

# cardsfrom.rb
# First included in Project 5
# Includes all classes for CardsFrom

# CardsFrom is the data representation of how a Player 
# drew cards for their Turn.
class CardsFrom
    # new : -> CardsFrom
    #
    # Creates a new CardsFrom
    def initialize
    end

    # Overide of equal? method to determing if two CardsFrom are the same
    def equal?(other)
        self.class == other.class
    end
end

# FromStack is the data representation of a Player 
# drawing n cards from the Stack for their Turn.
class FromStack < CardsFrom
    # new : Integer -> FromStack
    #
    # Creates a new FromStack
    def initialize(n)
        @n = n
    end

    # how_many_cards? : FromStack -> Integer
    #
    # Returns the number of cards the player drew
    # from the Stack.
    def how_many_cards?
        @n
    end
end

# FromDeck is the data representation of a Player 
# drawing a Card from the Stack for their Turn.
class FromDeck < CardsFrom
    # new : -> FromDeck
    #
    # Creates a new FromDeck
    def initialize
    end
end
