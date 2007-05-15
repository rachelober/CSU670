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
  include DesignByContract
  attr_reader :fighter, :bomber

  # new : Squadron Squadron -> Attack
  #
  # Creates a new Object of type Attack.
  def initialize(fighter, bomber)
    create(fighter, bomber)
  end

  pre(:create, "Fighter Squadron is not of type Fighter."){|fighter, bomber|
    fighter.squadron_fighter?}
  pre(:create, "Bomber Squadron is not of type Bomber."){|fighter, bomber|
    bomber.squadron_bomber?}
  pre(:create, "Fighter and Bomber Squadrons are same alliance."){|fighter, bomber|
    bomber.enemies?(fighter)}
  # create : Squadron Squadron -> Attack
  #
  # Creates a new Object of type Attack.
  def create(fighter, bomber)
    @fighter = fighter
    @bomber = bomber
  end

  # valid? : Attack -> Boolean
  # 
  # Is this Attack valid?
  def valid?
    @fighter.enemies?(@bomber) &&
    @fighter.squadron_fighter? &&
    @bomber.squadron_bomber? &&
    @fighter.squadron? &&
    @bomber.squadron? &&
    @fighter.squadron_complete? &&
    @bomber.squadron_complete?
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

  # attack_to_xml : Attack -> Document
  #
  # Converts this Attack into an XML String.
  def attack_to_xml
    document = Document.new
    attack = document.add_element "ATTACK"
    attack.add_element @fighter.squadron_to_xml
    attack.add_element @bomber.squadron_to_xml

    document
  end
end
