# !/arch/unix/bin/ruby

# deck.rb
# First included in Project 4.
# Includes all of the class needed to create a Deck.

# The Deck class controls everything about creating cards to go into the initial Deck.
# The Administrator pulls all cards from the original (shuffled) Deck before handing the
# Players their first Hand.
class Deck
  include Comparable

  # initialize : List -> Deck
  #
  # Create Object of type Deck.
  # If the list is nil, it builds the standard directory of cards.
  # If it is given a list, it sets the list of cards to the given list.
  def initialize(list)
    if list.nil?
      @list_of_cards = build_deck
    else
      @list_of_cards = list
    end
  end

  # create : -> Deck
  #
  # Creates a new Deck by running the Deck.new method.
  def Deck.create
    Deck.new(nil)
  end

  # shuffle : Deck -> Deck
  #
  # Shuffles the Deck.
  def shuffle
    Deck.new(deck_to_list.shuffle!)
  end

  # empty? : Deck -> Boolean
  #
  # Is this Deck empty?
  def empty?
    deck_to_list.empty?
  end

  # take : Deck -> Card
  #
  # Look at the top Card from this Deck.
  def take
    deck_to_list.first
  end

  # pop : Deck -> Deck
  #
  # Removes the top Card from this Deck.
  def pop
    new_list = deck_to_list.dup
    new_list.shift
    Deck.list_to_deck(new_list)
  end

  # list_to_deck : ListOf-Card -> Deck
  #
  # Creates a Deck from a List of Cards.
  def Deck.list_to_deck(list)
    Deck.new(list) 
  end

  # deck_to_list : Deck -> ListOf-Card
  #
  # Converts this Deck to a List of Cards.
  def deck_to_list
    @list_of_cards
  end

  # equal? : Deck Deck -> Boolean
  #
  # Are these Decks equal?
  def equal?(other)
    self == other
  end
  
  # <=> : Deck Deck -> (-1, 0 or +1)
  #
  # Comparable method that compares the list of cards
  # in the Deck.
  def <=>(other)
    @list_of_cards <=> other.deck_to_list
  end
  
  private
  # build_deck : Deck -> ListOf-Card
  #
  # Creates the standard directory order of cards.
  # This method parses the aircrafts/index.xml to create the
  # standard directory order of cards.
  def build_deck
    list_of_cards = []
    
    file = File.new('aircrafts/index.xml')
    doc = Document.new file
    
    allies = Allies.new
    axis = Axis.new
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
        nation = allies
      elsif(element.attributes['nation'] == 'allies')
        nation = axis
      end

      count = 0
      while count < 3
        count += 1
        temp_aircraft = Aircraft.new(image, name, nation, category, count)
        list_of_cards.push(temp_aircraft)
      end
    }

    victory = Victory.new(victory_img)
    list_of_cards.push(victory)
    
    count = 1
    while count < Keepem.max
      keepem = Keepem.new(keepem_img,count)
      list_of_cards.push(keepem)
      count += 1
    end

    list_of_cards.sort
  end
end

# Help from: http://www.whomwah.com/2006/11/10/shuffling-an-array-in-ruby/
# Defining a few more methods for the Array class.
class Array
  # Creating a shuffle method for Array.
  def shuffle
    sort_by { rand }  
  end  
  
  # We use this method in our Deck.shuffle method. It shuffles the
  # list_of_cards attribute of the Deck so that it is different
  # from the standard order of the cards.
  def shuffle!
    size.downto(1) { |n| push delete_at(rand(n)) }  
    self
  end  
end
