# !/arch/unix/bin/ruby

# attack.rb
# First included in Project 5
# Includes Attack Class

# Class method for Attack.
# An attack is made up of a Fighter Squadron
# and a Bomber Squadron. The two opposing Squadron
# needs to be of opposite Alliance.
class Attack
    include Comparable
    attr_reader :fighter, :bomber

    # new : Squadron Squadron -> Attack
    #
    # Creates a new Object of type Attack.
    def initialize(fighter, bomber)
        @fighter = fighter
        @bomber = bomber
    end

    # equal? : Attack Attack -> Boolean
    #
    # Are these two attacks equal?
    def equal?(attack)
        @fighter == attack.fighter &&
        @bomber == attack.bomber
    end

    # <=>: Attack Attack -> (-1, 0 or +1)
    #
    # Compares two Attacks.
    def <=>(attack)
        @fighter <=> attack.fighter
    end
end
