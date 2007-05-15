# !/arch/unix/bin/ruby

# done.rb
# First included in Project 5
# Includes classes for Done.

# Class method for Done. There are two different
# types of Done used in the program:
# * Ret
# * End
# A Ret is used when the game keeps playing and the
# Player returns a Card to the Stack. An End is used when
# the Player is ending the Battle. The Player can either return
# a Card to the Stack or return nil because they played their
# last Card in an Attack or discard.
class Done
    attr_reader :attacks, :discards

    # new : ListOf-Attack ListOf-Squadron -> Done
    #
    # Creates a new Object of type Done.
    def initialize(attacks, discards)
        @attacks = attacks
        @discards = discards
    end
end

# Ret inherits from the Done class. A Ret means that the Player
# has not finished the Battle and is returning a Card to the Stack.
class Ret < Done
    attr_reader :card

    # new : ListOf-Attack ListOf-Squadron Card -> Ret
    #
    # Creates a new Done of type Ret.
    def initialize(attacks, discards, card)
        super(attacks, discards)
        @card = card
    end

    # equal? : Ret Done -> Boolean
    #
    # Are these two Rets equal?
    def equal?(other)
        other.instance_of?(Ret) &&
        @attacks == other.attacks &&
        @discards == other.discards &&
        @card == other.card
    end
end

# End inherits from the Done class. An End is used
# whenever the Battle ends because the Player does not
# have any cards left in their Hand. They can either return
# a Card to the Stack or return nil because they played their
# last Card in an Attack or discard.
class End < Done
    attr_reader :card

    # new : ListOf-Attack ListOf-Squadron Card -> End
    #
    # Creates a new Done of type End.
    def initialize(attacks, discards, card)
        super(attacks, discards)
        @card = card
    end
    
    # equal? End Done -> Boolean
    #
    # Are these two Ends the same?
    def equal?(other)
        other.instance_of?(End) &&
        @attacks == other.attacks &&
        @discards == other.discards &&
        @card == other.card
    end
end
