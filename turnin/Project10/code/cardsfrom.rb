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
end

# FromStack is the data representation of a Player 
# drawing n cards from the Stack for their Turn.
class FromStack < CardsFrom
  # new : Integer -> FromStack
  #
  # Creates a new FromStack
  def initialize(n)
    @n = n   # Number Cards taken from Stack
  end

  # how_many_cards? : FromStack -> Integer
  #
  # Returns the number of cards the player drew
  # from the Stack.
  def how_many_cards?
    @n
  end

  # cardsfrom_to_xml : FromStack -> String
  #
  # Converts this FromStack into an XML String
  def cardsfrom_to_xml
    "<STACK NO=\"#{self.how_many_cards?}\"/>"
  end

  # equal? : FromStack -> Boolean
  #
  # Overide of equal? method to determing if two FromStack are the same.
  def equal?(other)
    if other.instance_of?(FromStack)
      self.how_many_cards? == other.how_many_cards?
    else
      false
    end
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
  
  # equal? : FromStack -> Boolean
  #
  # Overide of equal? method to determing if two FromStack are the same.
  def equal?(other)
    self.class == other.class
  end
  
  # cardsfrom_to_xml : FromDeck -> String
  #
  # Converts this FromStack into an XML String
  def cardsfrom_to_xml
    "<DECK />"
  end
end
