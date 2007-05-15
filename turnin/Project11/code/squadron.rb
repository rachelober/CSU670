# !/arch/unix/bin/ruby

# squadron.rb
# First included in Project 3
# Includes all the classes to create a Squadron

# Required files
require 'code/card.rb'
require 'modules/dbc.rb'

class Squadron
  include Comparable
  include DesignByContract
  attr_reader :list_of_cards
	
  # new : ListOf-Card -> Squadron
  #
  # Create Object of type Squadron.
  def initialize(list_of_cards)
    @list_of_cards = list_of_cards.sort
  end

  # squadron_first_aircraft : Squadron -> Aircraft
  #
  # Finds the first Aircraft Card from this Squadron.
  post(:squadron_first_aircraft, "Must return an Aircraft"){|result| result.instance_of?(Aircraft)}
  def squadron_first_aircraft
    @list_of_cards.detect{|card| card.instance_of?(Aircraft)}
  end

  # squadron_alliance : Squadron -> Alliance
  #
  # To which Alliance does this Squadron belong?
  post(:squadron_alliance, "must return an Alliance"){|result| result.kind_of?(Alliance)}
  def squadron_alliance
    self.squadron_first_aircraft.a
  end

  # squadron_name : Squadron -> String
  #
  # What is the name of this Squadron?
  post(:squadron_name, "must return a String"){|result| result.instance_of?(String)}
  def squadron_name
    self.squadron_first_aircraft.name
  end

  # squadron_complete : Squadron -> Boolean
  #
  # Is this Squadron complete?
  # A Squadron is complete if it includes exactly 3 cards.
  post(:squadron_complete?, "must return a Boolean"){|result| result.instance_of?(FalseClass) || result.instance_of?(TrueClass)}
  def squadron_complete?
    @list_of_cards.size == 3
  end

  # squadron_incomplete : Squadron -> Boolean
  #
  # Is this Squadron incomplete?
  # A Squadron is incomplete if is has less than 3 cards.
  post(:squadron_incomplete?, "must return a Boolean"){|result| result.instance_of?(FalseClass) || result.instance_of?(TrueClass)}
  def squadron_incomplete?
    @list_of_cards.size < 3 && @list_of_cards.size > 0
  end

  # squadron_figher? : Squadron -> Boolean
  #
  # Is this a Fighter Squadron?
  post(:squadron_fighter?, "must return a Boolean"){|result| result.instance_of?(FalseClass) || result.instance_of?(TrueClass)}
  def squadron_fighter?
    self.squadron_first_aircraft.forb.instance_of?(Fighter)
  end

  # squadron_bomber? : Squadron -> Boolean
  #
  # Is this a Bomber Squadron?
  post(:squadron_bomber?, "must return a Boolean"){|result| result.instance_of?(FalseClass) || result.instance_of?(TrueClass)}
  def squadron_bomber?
    self.squadron_first_aircraft.forb.instance_of?(Bomber)
  end
	
  # squadron_value : Squadron -> Integer
  #
  # What is the value of this Squadron?
  # The value of the Squadron is determined firstly if the Squadron is complete
  # and then determines the value depending on whether it is a Fighter or a
  # Bomber Squadron.
  post(:squadron_value, "must return an Integer"){|result| result.kind_of?(Integer)}
  def squadron_value
    if self.squadron_complete?
      return self.squadron_first_aircraft.forb.squadron_value
    else
      return 0
    end
  end
	
  # how_many_aircraft? : Squadron -> Integer
  #
  # Returns the number of Aircraft cards in the Squadron.
  post(:how_many_aircraft?, "must return an Integer"){|result| result.kind_of?(Integer)}
  def how_many_aircraft?
    @list_of_cards.find_all do |card|
      card.instance_of?(Aircraft)
    end.size
  end
	
  # push! : Squadron Card -> Squadron
  #
  # This pushes a card onto the Squadron Array. Note that this changes the Squadron.
  pre(:push!,"must take a Card"){|card| card.kind_of?(Card)}
  post(:push!,"must return a Squadron"){|result, card| result.squadron?}
  def push!(card)
    @list_of_cards = @list_of_cards.push(card).sort
    Squadron.new(@list_of_cards)
  end

  # squadron? : Squadron -> Boolean
  #
  # Is this a valid Squadron?
  # Valid Squadrons must only contain Cards and each Aircraft Card must share the
  # name of the Squadron.
  def squadron?
    self.list_of_cards.instance_of?(Array) &&
    self.list_of_cards.each{|card| card.kind_of?(Card)} &&
    self.list_of_cards.all?{|card| card.kind_of?(WildCard) || card.name == self.squadron_name} &&
    self.list_of_cards.map{|card| card.instance_of?(Aircraft)}.include?(true)
  end

  # equal? : Squadron Squadron -> Boolean
  #
  # Are these two Squadrons equal?
  pre(:equal?, "must take a squadron to compare"){|other| other.squadron?}
  post(:equal?, "must return a Boolean"){|result, other| result.instance_of?(TrueClass) || result.instance_of?(FalseClass)}
  def equal?(other)
    self.list_of_cards == other.list_of_cards
  end

  # <=> : Squadron Squadron -> (-1, 0 or +1)
  #
  # Comparable method that compares the list of cards in the Squadron.
  def <=>(other)
    @list_of_cards <=> other.list_of_cards
  end

  # squadron_to_xml : Squadron -> String
  #
  # Converts this Squadron into an XML String.
  def squadron_to_xml
    if @list_of_cards.size == 0
      result = "<SQUADRON />"
    else
      result = "<SQUADRON>"
      @list_of_cards.each{|card|
      result = result + card.card_to_xml
      }
      result = result + "</SQUADRON>"
    end
    result
  end

  # Squadron.xml_to_squad : Document -> Squadron
  #
  # Converts an XML Document into a Squadron.
  def Squadron.xml_to_squad(doc)
    squad_list = []
    doc.elements.each('SQUADRON/*') {|element|
      input = Document.new element.to_s
      squad_list << Card.xml_to_card(input)
    }
    Squadron.new(squad_list)
  end
end
