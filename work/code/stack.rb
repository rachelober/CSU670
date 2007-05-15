# !/arch/unix/bin/ruby

# stack.rb
# First included in Project 4
# Includes all classes that are used in Stack

# A Stack is made up of the discarded cards from Players.
# After each turn they are required to discard one card from their Hand.
# This is not to be confused with discarded squadrons which are used to gain
# points in the game.
class Stack
  include Comparable
  attr_reader :list_of_cards

  # initialize : ListOf-Card -> Stack
  #
  # Create Object of type Stack.
  def initialize(list_of_cards)
    @list_of_cards = list_of_cards   # ListOf-Card
  end

  # create : Card -> Stack
  #
  # Calls the method initialize.
  # Takes a Card and runs the initialize method.
  def Stack.create(card)
    Stack.new([card])
  end

  # depth : Stack -> Integer
  #
  # How many cards are on the stack?
  def depth
    @list_of_cards.size
  end

  # push : Stack Card -> Stack
  #
  # Adds a Card to top of the Stack.
  def push(card)
    Stack.new(@list_of_cards.dup.unshift(card))
  end

  # take : Stack Integer -> ListOf-Card
  #
  # Returns the first n Cards from the given stack.
  def take(n)
    #@list_of_cards.first(n)
    @list_of_cards[0...(n)]
  end

  # pop! : Stack Integer -> Stack
  #
  # Creates a Stack by removing the first n Cards from this Stack.
  def pop!(n)
    length = @list_of_cards.length
    popped = @list_of_cards.dup[(n)..length]
    Stack.new(popped)
  end

  # equal? : Stack Stack -> Boolean
  #
  # Are these Stacks the same?
  # Uses the Comparable method.
  def equal?(other)
    self == other
  end

  # <=> : Stack Stack -> (-1, 0 or +1)
  #
  # This is the comparable method we use to compare two Stacks. We compare the
  # two Stacks by comparing the Stacks' list_of_cards. If their arrays are the same,
  # then the two Stacks are the same.
  def <=>(other)
    self.list_of_cards <=> other.list_of_cards
  end

  # stack_to_xml : Stack -> Document
  #
  # Converts a Stack into an XML Document.
  def stack_to_xml
    document = Document.new
    stack = document.add_element "STACK"
    @list_of_cards.each{|card|
      stack.add_element card.card_to_xml
    }
    document
  end
end
