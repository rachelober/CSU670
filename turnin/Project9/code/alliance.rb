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
end

# Allies inherits from the Alliance class.
# This is used to set certain cards to the Allies
# if their nation is set to US, UK, or Soviet Union.
class Allies < Alliance
    # Creates a new Alliace named Allies.
    def initialize
    end
end

# Axis inherits from the Alliance class.
# This is used to set certain cards to the Axis
# if their nation is set to Germany, Italy or Japan.
class Axis < Alliance
    # Creates a new Alliance named Axis.
    def initialize
    end
end
