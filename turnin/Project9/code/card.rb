# !/arch/unix/bin/ruby

# card.rb
# First included in Project 3
# This file includes all classes that are used in creating Cards
# Dependant on:
# + Alliance
# + Category
# + Image

# Required files
require 'code/alliance.rb'
require 'code/category.rb'
require 'code/image.rb'
require 'modules/dbc.rb'
# This class creates cards that will be played in the game.
# There are three different cards types:
# * Aircraft
# * Keepem
# * Victory
class Card
	include Comparable
    include DesignByContract
    attr_reader :image

    pre("image must be of class Image") {|i| i.instance_of?(Image)}
    # Create a new Object of type Card.
    # All Cards require an Image file_name.
    def initialize(image)
        @image = image      # Image
    end
           
    # Super method for comparing different cards.
    def cards_have_same_name?(card)
    end

    # Super method for assigning a value to a card for sorting purposes.
    def card_value
    end

    # card_less_than? : Card Card -> Boolean
    #
    # Evaluates if This is less than Card.
    # If This Card is less than given the Card, returns true.
    # Else, returns false.
    # This depends on the <=> method found in the subclasses.
    def card_less_than?(card)
        self < card
    end
end

# The Aircraft class holds all information about Aircraft cards.
# It inherits from the Card class and inherits the image attribute.
# Aircrafts include a name, an Alliance, a Category and a tag.
# The Alliance can either be Axis or Allies, and the Category can either be
# Fighter or Bomber. The tag can be 1, 2, or 3 and represents the different
# "sides" of the Aircraft.
class Aircraft < Card
    include DesignByContract
    attr_reader :name, :a, :forb, :tag

    pre(:new, "image must be of class Image") {|image, name, a, forb, tag| 
        image.instance_of?(Image) && name.instance_of?(String) && a.kind_of?(Alliance) && forb.kind_of?(Category)
        tag.kind_of?(Integer) && tag < 3 && tag < 0}
    # initialize : Image String Alliance Category Integer -> Aircraft
    #
    # Create a new Card of type Aircraft.
    # All Aircraft Cards require an image of type Image, name, a of type Alliance, and forb of type Category
    # Image is inherited from the Card class.
    def initialize(image, name, a, forb, tag)
        super(image)
        @name = name    # String
        @a = a          # Alliance
        @forb = forb    # Category
        @tag = tag      # Integer
    end
    
    pre("input must be of class Card") {|i| i.kind_of?(Card)}
    # cards_have_same_name? : Aircraft Card -> Boolean
    #
    # Takes a Card and checks to see if it has a name attribute.
    # If it has a name property, then checks to see if the this has the same
    # name as the Card.
    # Otherwise, it returns false because the name attributes can't be compared.
    def cards_have_same_name?(card)
        if(card.respond_to?("name"))
            self.name == card.name
        else
            false
        end
    end

    post{|i| i.kind_of?(Integer) && i >= 0}
    # card_value : Aircraft -> Integer
    #
    # Gets the Aircraft's value from the Category class.
    def card_value
        @forb.value
    end

    # equal? : Aircraft Card -> Boolean
    #
    # Are these two cards equal?
    def equal?(other)
        self == other
    end
    
    # <=> : Aircraft Card -> (-1, 0 or +1)
    #
    # This method helps us to compare Aircraft cards to other cards.
    # If the other Card is an Aircraft Card with the same name, it compares
    # by the "tag" attribute. If they are both Aircraft cards but do not
    # share the same name, they are compared alphabetically. Otherwise,
    # the cards are compared by their card values.
    def <=>(other)
        if self.cards_have_same_name?(other)
            self.tag <=> other.tag
        elsif other.instance_of?(Aircraft)
            self.name.downcase <=> other.name.downcase
        else
            self.card_value <=> other.card_value
        end
    end
end

# A WildCard can be either a Victory or a Keepem Card.
# This class is a parent to both Victory and Keepem.
class WildCard < Card
    include DesignByContract
    
    # initialize : Image -> WildCard
    #
    # Create a new Card of type Wildcard.
    # All WildCards require a file_name.
    # Image is inherited from the Card class.
    def initialize(image)
        super(image)        # Image
    end
end

# There is only one Victory Card for the Deck. The Victory Card includes an Image
# and has a card value of 0.
class Victory < WildCard
    include DesignByContract
    
    # initialize : Image -> Victory
    #
    # Create a new WildCard of type Victory
    # All Victory WildCards require a file_name
    # Image is inherited from the Card class
    def initialize(image)
        super(image)        # Image
    end
   
    # cards_have_same_name? : Victory Card -> Boolean
    #
    # Takes a Card and checks to see if its type is Victory.
    def cards_have_same_name?(card)
        card.instance_of?(Victory)
    end

    # card_value : Victory -> Integer
    #
    # Victory WildCards are given the card value of 0, worth no points.
    def card_value
        return 0
    end

    # equal? : Victory Card -> Boolean
    #
    # Are these two cards equal?
    def equal?(other)
        self == other
    end
    
    # <=> : Victory Card -> (-1, 0 or +1)
    #
    # This is the method that helps us compare the Victory Card to other cards.
    # We want to order hands based upon the value of our cards, therefore Victory
    # cards are ordered as the first. In this method we organize it so that Victory is always the first.
    def <=>(other)
        if other.instance_of?(Aircraft)
            return -1
        elsif other.instance_of?(Keepem)
            return -1
        else
            return 0
        end
    end
end

# There are up to 6 Keepem cards in the Deck. Each Keepem Card has an index to keep
# track of them. The Keepem cards inherit the Image attribute from the Card class.
class Keepem < WildCard
    include DesignByContract
    
    attr_reader :index

    # initialize : Image Integer -> Keepem
    #
    # Create a new WildCard of type Keepem.
    # All Keepem WildCards require a file_name and index.
    # Image is inherited from the Card class.
    def initialize(image, index)
        super(image)        # Image
        @index = index      # Integer
    end
   
    # cards_have_same_name? Keepem Card -> Boolean
    #
    # Takes a Card and checks to see if its type is Keepem.
    def cards_have_same_name?(card)
        card.instance_of?(Keepem)
    end

    # card_value : Keepem -> Integer
    #
    # Keepem WildCards are given the card value of 0, worth no points.
    def card_value
        return 0
    end

    # max : Keepem -> Integer
    #
    # Returns the max amount of Keepems allowed to be made in a Deck.
    def Keepem.max
        return 6
    end

    # equal? : Keepem Card -> Boolean
    #
    # Are these two cards equal?
    def equal?(other)
        self == other
    end

    # <=> : Keepem Card -> (-1, 0 or +1)
    #
    # This method helps us to order the cards in our Hand. Generally we want Keepem
    # cards to follow the Victory Card (if it exists.) Therefore, if the Victory Card exists,
    # the Keepem Card is placed after. If it compares against another Victory Card, 
    # they are compared on their index number. If it compares against an Aircraft Card, the Keepem
    # Card always preceeds an Aircraft Card.
    def <=>(other)
        if self.cards_have_same_name?(other)
            self.index <=> other.index
        elsif other.instance_of?(Aircraft)
            return -1
        elsif other.instance_of?(Victory)
            return +1
        end
    end
end
