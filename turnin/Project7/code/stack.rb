# !/arch/unix/bin/ruby

# stack.rb
# First included in Project 4
# Includes all classes that are used in Stack

class Stack
    attr_accessor :list_of_cards

    # Create Object of type Stack
    # Takes a Card
    def initialize(list)
        @list_of_cards = list
    end

    # Calls the method initialize
    # Takes a Card and runs the initialize method
    # Returns a new Stack
    def Stack.create(card)
        Stack.new(Array[card])
    end

    # How many cards are on the stack?
    # Acts on a Stack and returns an Integer
    def depth
        @list_of_cards.size
    end

    # Adds a Card to a Stack
    # Acts on a Stack, takes a Card and returns a Stack
    def push(card)
        Stack.new(@list_of_cards.dup.push(card))
    end

    # Returns the first n Cards from the given stack
    # Acts on a Stack, takes an Interger (n) and
    # Returns the first n cards from this Stack
    def take(n)
        @list_of_cards.first(n)
    end

    # Creates a Stack by removing the first n Cards from this Stack
    # Takes an Integer n and returns a new Stack
    def pop!(n)
        temp_list = @list_of_cards.dup
        while n > 0
            temp_list.shift
            n -= 1
        end
        Stack.new(temp_list)
    end

    # Are these Stacks the same?
    # Takes a Stack and acts on this Stack
    # Returns a Boolean
    def equal?(stack)
        bool = true
        list1 = self.list_of_cards
        list2 = stack.list_of_cards
        
        if list1.size != list2.size
            bool = false
        else
            i = 0
            while i < list1.size
                bool2 = list1[i].cards_have_same_name?(list2[i])
                bool = bool && bool2
                i += 1
            end
        end
        bool
    end
end
