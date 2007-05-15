# !/arch/unix/bin/ruby

# alliance.rb
# First included in Project 3
# This file includes all classes that are used in creating a Card Alliance

# The Alliance class keeps track of which side the 
# Bomber/Fighter is on. They can either be a part of the
# Axis or Allies.
class Alliance
  # Creates a new Object of type Alliance.
  def initialize
  end

  # alliance? : Alliance -> Boolean
  #
  # Is this an Alliance?
  def alliance?
    true
  end

  # allies? : Alliance -> Boolean
  #
  # Is this Alliance an Allies?
  def allies?
    false
  end

  # axis? : Alliance -> Boolean
  #
  # Is this Alliance an Axis?
  def axis?
    false
  end
end

# Allies inherits from the Alliance class.
# This is used to set certain cards to the Allies
# if their nation is set to US, UK, or Soviet Union.
class Allies < Alliance
  # Creates a new Alliace named Allies.
  def initialize
  end
  
  # allies : Alliance -> Boolean
  #
  # Is this Alliance an Allies?
  def allies?
    true
  end

  # to_s : Allies -> String
  #
  # Print the Alliance
  def to_s
    'Allies'
  end
end

# Axis inherits from the Alliance class.
# This is used to set certain cards to the Axis
# if their nation is set to Germany, Italy or Japan.
class Axis < Alliance
  # Creates a new Alliance named Axis.
  def initialize
  end

  # axis? : Alliance -> Boolean
  #
  # Is this Alliance an Axis?
  def axis?
    true
  end
  
  # to_s : Axis -> String
  #
  # Print the Alliance
  def to_s
    'Axis'
  end
end
