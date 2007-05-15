# !/arch/unix/bin/ruby

# card.rb
# First included in Project 3
# This file includes all classes that are used in creating Cards

class Card
	attr_accessor :image
	
    # Create a new Object of type Card
    # All Cards require an Image file_name
    def initialize(image)
        @image = image
    end
           
    # Super method for comparing different cards
    def cards_have_same_name?(card)
    end

    # Super method for assigning a value to a card for sorting purposes
    def card_value
    end

    # Takes a Card
    # Evaluates if This is less than Card
    # If This is less than given Card, returns true
    # Else, returns false
    # Returns a Boolean
    def card_less_than?(card)
        self.card_value < card.card_value
    end
end

class Aircraft < Card
    attr_accessor :name, :a, :forb, :tag

    # Create a new Card of type Aircraft
    # All Aircraft Cards require an image of type Image, name, a of type Alliance, and forb of type Category
    # Image is inherited from the Card class
    def initialize(image, name, a, forb, tag)
        super(image)
        @name = name
        @a = a
        @forb = forb
        @tag = tag
    end
    
    # Takes a Card and checks to see if it has a name attribute
    # If it has a name property, then checks to see if the this has the same
    # name as the Card
    # Else, it returns false because the name attributes can't be compared
    # Returns a Boolean
    def cards_have_same_name?(card)
        if(card.respond_to?("name"))
            self.name == card.name
        else
            false
        end
    end

    # Gets the Aircraft's value from the Category class
    def card_value
        return @forb.value
    end
end

class WildCard < Card
    # Create a new Card of type Wildcard
    # All WildCards require a file_name
    # Image is inherited from the Card class
    def initialize(image)
        super(image)
    end
end

class Victory < WildCard
    # Create a new WildCard of type Victory
    # All Victory WildCards require a file_name
    # Image is inherited from the Card class
    def initilize(image)
        super(image)
    end
    
    # Takes a Card and checks to see if its type is Victory
    # Returns a Boolean
    def cards_have_same_name?(card)
        card.class == Victory
    end

    # Victory WildCards are given the card value of 0, worth no points
    def card_value
        return 0
    end
end

class Keepem < WildCard
	attr_accessor :index, :max
    
    # Create a new WildCard of type Keepem
    # All Keepem WildCards require a file_name and index
    # Image is inherited from the Card class
    def initialize(image, index)
        super(image)
        @index = index
        @max = 6
    end
    
    # Takes a Card and checks to see if its type is Keepem
    # Returns a Boolean
    def cards_have_same_name?(card)
        card.class == Keepem
    end

    # Keepem WildCards are given the card value of 0, worth no points
    def card_value
        return 0
    end
end

class Image
    # Create a new Object of type Image
    def initialize(file_name)
        @file_name = file_name
    end
end

class Alliance
    # Creates a new Object of type Alliance
    def initialize
    end
end

class Allies < Alliance
    # Creates a new Alliace named Allies
    def initialize
    end
end

class Axis < Alliance
    # Creates a new Alliance named Axis
    def initialize
    end
end

class Category
	attr_accessor :value
    
    # Creates a new Object of type Category
    # Has a value of 0
    def initialize
    	@value = 0
    end
end

class Fighter < Category
	attr_accessor :squadron_value
    
    # Creates a new Category of type Fighter
    # Has a value of 5
    # When the Squadron is complete, it has a Squadron value of 15
    def initialize
    	@value = 5
        @squadron_value = 15
    end
end

class Bomber < Category
	attr_accessor :squadron_value
    
    # Creates a new Category of type Bomber
    # Has a value of 10
    # When the Squadron is complete, it has a Squadron value of 30
    def initialize
    	@value = 10
        @squadron_value = 30
    end
end
