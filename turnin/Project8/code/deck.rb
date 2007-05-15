# !/arch/unix/bin/ruby

# deck.rb
# First included in Project 3
# Includes all of the class needed to create a Deck

# Requiring Files
require 'code/card.rb'
require 'rexml/document'
include REXML

class Deck
    attr_accessor :list_of_cards

    # Create Object of type Deck
    # Takes a List
    def initialize(list)
        if list.nil?
            @list_of_cards = self.build_deck
        else
            @list_of_cards = list
        end
    end

    # Creates a new Deck by making an empty array
    # And then building the empty Deck from the default directory
    # Creates a Deck using the standard (directory) order of cards
    # Returns a Deck
    def Deck.create
        Deck.new(nil)
    end

    # shuffle : Deck -> Deck
    # Shuffles the Deck
    def shuffle
        Deck.new(self.deck_to_list.shuffle!)
    end

    # empty? : Deck -> boolean
    # Is this Deck empty?
    def empty?
        self.deck_to_list.empty?
    end

    # take : Deck -> Card
    # Look at the top Card from this Deck
    def take
        self.deck_to_list.first
    end

    # pop : Deck -> Deck
    # Remove the top Card from this Deck
    def pop
        new_list = @list_of_cards.dup
        new_list.shift
        Deck.list_to_deck(new_list)
    end

    # list_to_deck : (listof Card) -> Deck
    # Creates a Deck from a List of Cards
    def Deck.list_to_deck(list)
        Deck.new(list) 
    end

    # deck_to_list : Deck -> (listof Card)
    # Converts this Deck to a List of Cards
    # Returns a List
    def deck_to_list
        @list_of_cards
    end
    
    # equal? : Deck Deck -> boolean
    # Are these two Decks equal?
    # Is this Deck equal to the given Deck?
    # Returns a Boolean
    def equal?(deck)
        bool = true
        
        list1 = self.deck_to_list
        list2 = deck.deck_to_list
        
        if
            list1.length != list2.length
            bool = false
        else
            i = 0
            while i < list1.length
                bool2 = list1[i].cards_have_same_name?(list2[i])
                bool = bool && bool2
                i += 1
            end
        end
        
        bool
    end
    
    protected
    # Creates the standard directory order of cards
    # Does not return anything
    def build_deck
        list_of_cards = []
        
        file = File.new('aircrafts/index.xml')
        doc = Document.new file
        
        allies = Allies.new()
        axis = Axis.new()
        fighter = Fighter.new()
        bomber = Bomber.new
        victory_img = Image.new('victory.gif')
        keepem_img = Image.new('keepem.gif')
        
        doc.elements.each('deck/aircraft') { |element| 
            name = element.attributes['name']
            image = Image.new(element.attributes['image'])
        
            if(element.attributes['category'] == 'fighter')
                category = fighter
            elsif(element.attributes['category'] == 'bomber')
                category = bomber
            end

            if(element.attributes['nation'] == 'axis')
                nation = axis
            elsif(element.attributes['nation'] == 'allies')
                nation = allies
            end

            count = 0
            while count < 3
                count += 1
                temp_aircraft = Aircraft.new(image,name,nation,category,count)
                list_of_cards.push(temp_aircraft)
            end
        }

        victory = Victory.new(victory_img)
        list_of_cards.push(victory)
        
        count = 0
        while count < Keepem.new(nil,nil).max
            keepem = Keepem.new(keepem_img,count)
            list_of_cards.push(keepem)
            count += 1
        end

        list_of_cards
    end
end

# Help from: http://www.whomwah.com/2006/11/10/shuffling-an-array-in-ruby/
# Defining a few more methods for the Array class
class Array
    # Creating a shuffle method for Array
    def shuffle
        sort_by { rand }  
    end  
    
    def shuffle!
        size.downto(1) { |n| push delete_at(rand(n)) }  
        self
    end  
end
