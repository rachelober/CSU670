# !/arch/unix/bin/ruby

# hand.rb
# First included in Project 4
# Includes all the classes to create a Hand

# The Hand class holds many methods that deal with how a Player
# organizes his/her Hand. At the end of a battle, any cards left in the
# Player's hand cost him points.
class Hand
  include Comparable
  attr_reader :list_of_cards

  # initialize : ListOf-Card -> Hand
  #
  # Create Object of type Hand.
  def initialize(list_of_cards)
    @list_of_cards = list_of_cards.sort
  end

  # create : ListOf-Card -> Hand
  #
  # Creates a Hand.
  def Hand.create(list_of_cards)
    Hand.new(list_of_cards)
  end

  # hand_to_list : Hand -> ListOf-Card
  #
  # Converts this Hand to a ListOf-Card.
  def hand_to_list
    @list_of_cards
  end

  # size : Hand -> Integer
  #
  # How many cards are on this Hand?
  def size
    @list_of_cards.size
  end
 
  # value : Hand -> Integer
  #
  # Determines the value of a Hand. The value
  # is determined by the different cards in the Hand.
  # WildCards are currently worth 0 points each, whereas Bomber cards 
  # are worth 5 points each and Fighter cards are worth 10 points each.
  def value
    score = 0
    @list_of_cards.each{|x| score += x.card_value}
    score
  end
	
  # completes : Hand -> ListOf-Squadron
  #
  # Determines the complete Squardons on this hand. This returns complete Squadrons
  # that are made up of ONLY Aircrafts. Squadrons made up of only Aircrafts must be
  # made up of exactly 3 cards.
  def completes
    temp_list = self.minus(self.wildcards).hand_to_list

    # Finds all Squadrons
    list_of_squadrons = temp_list.map do |card|
      card.name
    end.uniq.map do |name|
      Squadron.new(temp_list.find_all {|card| card.name == name})
    end

    # We only want COMPLETED Squadrons of 3 cards
    list_of_squadrons = list_of_squadrons.find_all {|squadron| squadron.squadron_complete?}
  end
		
  # wildcards : Hand -> ListOfCard
  #
  # Determines the available WildCard on a Hand.
  def wildcards
    @list_of_cards.dup.delete_if{|x| x.class == Aircraft}
  end

  # complementable : Hand -> ListOf-Squadron
  #
  # Which Squadrons can benefit from one or two WildCard?
  # A complementable Squadron can be made up of either:
  # * Two Aircraft and one WildCard
  # * Two Aircraft and two WildCard
  # However, we deal with assigning the appropriate WildCard in the
  # Player class because he will eventually decide which Squadrons
  # to complete.
  def complementable
    temp_list = self.minus(self.wildcards).hand_to_list

    # Finds all Squadrons
    list_of_squadrons = temp_list.map do |card|
      card.name
    end.uniq.map do |name|
      Squadron.new(temp_list.find_all {|card| card.name == name})
    end
    
    # We only want INCOMPLETE Squadrons of 1 or 2 Aircraft cards
    list_of_squadrons = list_of_squadrons.find_all {|squadron| 
      squadron.squadron_incomplete? && squadron.how_many_aircraft? < 3}
    
    list_of_squadrons.sort
  end
	
  # plus : Hand ListOf-Card -> Hand
  #
  # Plus adds a list of cards to the current Hand.
  def plus(list)
    Hand.create(@list_of_cards.dup + list)
  end
	
  # minus : Hand ListOf-Card -> Hand
  #
  # Minus subtracts a list of cards from the current Hand.
  # Returns a new Hand
  def minus(list)
    Hand.create(@list_of_cards.dup - list)
  end

  # equal? : Hand Hand -> Boolean
  #
  # Are these two hands equal?
  def equal?(other)
    self == other
  end

  #<=> : Hand Hand -> (-1, 0 or +1)
  #
  # Comparable method that compares the list of cards in the Hand.
  def <=>(other)
    @list_of_cards <=> other.list_of_cards
  end

  # Hand.xml_to_fsth : Document -> Hand
  def Hand.xml_to_fsth(doc)
    hand_list = []
    doc.elements.each('SQUADRON/*') {|element|
      input = Document.new element.to_s
      hand_list << Card.xml_to_card(input)
    }
    
    Hand.new(hand_list)
  end
end
