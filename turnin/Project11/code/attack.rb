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

  # attack_to_xml : Attack -> String
  #
  # Converts this Attack into an XML String
  def attack_to_xml
    if (@fighter.list_of_cards.size == 0) && (@bomber.list_of_cards.size == 0)
      result = "<ATTACK />"
    else
      result = "<ATTACK>"
      # Fighter
      result = result + @fighter.squadron_to_xml
      # Bombers
      result = result + @bomber.squadron_to_xml
      result = result + "</ATTACK>"
    end
    return result
  end
end
