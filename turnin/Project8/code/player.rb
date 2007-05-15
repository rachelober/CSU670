# !/arch/unix/bin/ruby

# player.rb
# First included in Project 5
# Includes all of the classes needed for Player

# Required Files
require 'code/hand.rb'
require 'code/observer_player.rb'

# Constructs the Player class
# A Player can pursue many different strategies
# and even switch strategies during a game.
class Player
    attr_accessor :hand, :gui, :discards, :shot_down
    # Create a new Object of type Player
    def initialize(name, gui)
        @name = name                   # String
        @hand = Hand.create(Array.new) # Hand
        @gui = gui                     # Boolean
        @discards = []                 # ArrayOf-Squadron
        @shot_down = []                # ArrayOf-Squadron
        @list_of_observers = []        # ArrayOf-ObserverPlayer
    end

    # Calls the initialize method
    # Creates a new Player, takes a String
    def Player.create(name, gui)
        player = Player.new(name, gui)
        if gui
            ObserverPlayer.new(player)
        end
        player
    end

    # What is the Player's name?
    # Returns the Player's name
    def player_name
        @name
    end

    # What is the Player's hand?
    # Returns the Player's Hand
    def player_hand
        @hand
    end

    # Deals the Player their first Hand
    # Gives this Player a list of Cards
    # Returns a Hand
    def player_first_hand(first_hand)
        @hand = @hand.plus(first_hand)
        if gui
            self.notify
        end
        @hand
    end

    # Allows the Player to take a turn
    # Takes the current turn and lets the Player
    # use it
    # Returns a Done
    def player_take_turn(turn)
        if gui
            self.notify
        end
        num = rand(turn.turn_stack_inspect.size)
        num += 1
        
        if turn.turn_card_on_deck?
        rand_num = rand(2)
        list_of_cards = case
          when rand_num == 0: Array.new.push(turn.turn_get_a_card_from_deck)
          when rand_num == 1: turn.turn_get_cards_from_stack(num)
        end
        else
            list_of_cards = turn.turn_get_cards_from_stack(num)
        end
      output = self.play_hand(list_of_cards, turn.turn_can_attack?(Axis.new), turn.turn_can_attack?(Allies.new))
    end  

    # The user plays his hand
    # Takes a list of Cards taken from the Stack or Deck
    # A List of Squadrons of Allies of other players
    # And a list of Squadrons of Axis
    # Returns a Done
    def play_hand(list_of_cards, list_of_allies, list_of_axis)
        if gui
            self.notify
        end
        @hand = @hand.plus(list_of_cards)
        attacks = self.make_max_fighters(list_of_allies, list_of_axis)
        attacks.each {|x| 
          @shot_down << x.bomber 
          @discards << x.fighter
        }
        discards = self.make_max_bombers
        discards.each {|x| @discards << x }
        @hand = self.update_hand(attacks, discards)

        if @hand.size == 0
            output = End.new(attacks, discards, nil)
        elsif @hand.size == 1
            card = @hand.hand_to_list.first
            @hand = @hand.minus(Array.new.push(card))
            output = End.new(attacks, discards, card)
        else
            rand_index = rand(@hand.size)
            card = @hand.hand_to_list.fetch(rand_index)
            @hand = @hand.minus(Array.new.push(card))
            output = Ret.new(attacks, discards, card)
        end
        if gui
            self.notify
        end
        output
    end
    
    # What attacks can the Player make?
    # Takes the Player's hand
    # A list of Squadrons of Allies
    # A list of Squadrons of Axis
    # Returns a list of Attacks
    def make_max_fighters(list_of_allies, list_of_axis)
      complete_squads = @hand.completes
      complement_squads = @hand.complementable
      all_squads = complete_squads.concat(complement_squads)
      all_squads.flatten!

      attacks = Array.new()
      all_squads.each{|x| 
        if (x.squadron_fighter?)
          if (x.squadron_alliance.class == Allies)
            if (list_of_axis.size > 0)
              attacks.push(Attack.new(x, list_of_axis.shift))
            end
          elsif(x.squadron_alliance.class == Axis)
            if (list_of_allies.size > 0)
              attacks.push(Attack.new(x, list_of_allies.shift))
            end
          end
        end
      }
    
      attacks
    end

    # What bombers can the user play?
    # Takes the users hand
    # Returns a list of Bomber Squadrons
    def make_max_bombers
      complete_squads = @hand.completes
      complement_squads = @hand.complementable
        all_squads = complete_squads.concat(complement_squads)
        
        # Output is a list of Squadrons
        output = Array.new
        
        all_squads.each {|x|
            if x.squadron_bomber?
                output.push(x)
            end
        }
        output
    end

    # Updates the hand to get rid of Squadrons we played
    # Takes a list of Attacks and a list of Discards
    # Returns a new Hand
    def update_hand(list_of_attacks, list_of_discards)
        list_of_cards = Array.new

        list_of_attacks.each{|x| list_of_cards.concat(x.fighter.list_of_cards)}

        list_of_discards.each{|x| list_of_cards.concat(x.list_of_cards)}

        @hand.minus(list_of_cards)
    end

    # notify : Player -> nil
    # Goes through the Player's list of Observers and tells them to update
    def notify
      @list_of_observers.each {|x| x.update }
    end

    # get_state : Player -> Player
    # Called from an Observer
    # Gets the current state of the Player
    def get_state
        self
    end

    # subscribe : Player PlayerObserver -> ListOf-Observer
    # Adds an observer to the list_of_observers
    def subscribe(observer)
        @list_of_observers << observer
    end

    # player_score : Player -> String
    # What is the player's guaranteed score?
    def player_score
       total_score = @shot_down.size * 30
       @discards.each{|x|
           if x.squadron_fighter?
               total_score += 15
           end
       }      
       total_score.to_s
    end
end

# Class method for Attack
class Attack
  attr_accessor :fighter, :bomber
  
  # Creates a new Object of type Attack
  def initialize(fighter, bomber)
    @fighter = fighter
    @bomber = bomber
  end
  
    # Are these two attacks equal?
    # Takes and Attack and finds if these two attacks are equal
    # Returns a Boolean
  def equal?(attack)
    @fighter.equal?(attack.fighter) && @bomber.equal?(attack.bomber)
  end
  
    # Are these two Attack lists equal?
    # Takes two lists of Attacks and compares them
    # Returns a Boolean
  def Attack.same_attack_list?(list1, list2)
    bool = true
    if list1.size != list2.size
      bool = false
    else
      i = 0
      while i < list1.size
        bool2 = list1[i].equal?(list2[i])
        bool = bool && bool2
        i += 1
      end
    end
    bool
  end
end

# Class method for Done
class Done
  attr_accessor :attacks, :discards

    # Creates a new Object of type Done
    def initialize(attacks, discards)
        @attacks = attacks
        @discards = discards
    end
    
    # Are these two Dones equal?
    # Takes a Done and asks this Done if it 
    # is the same as the given Done
    # Returns a Boolean
    def equal?(done)
      return Attack.same_attack_list?(@attacks, done.attacks) &&
          Squadron.same_squad_list?(@discards, done.discards)
  end
end

# Ret inherits from the Done class
class Ret < Done
  attr_accessor :card

    # Creates and new Done of type Ret
    def initialize(attacks, discards, card)
        super(attacks, discards)
        @card = card
    end
    
    # Are these two Rets equal?
    # Returns Boolean
    def equal?(done)
      return Attack.same_attack_list?(@attacks, done.attacks) &&
          Squadron.same_squad_list?(@discards, done.discards) && 
          @card.cards_have_same_name?(done.card)
    end
end

# Class method for End
class End < Done
  attr_accessor :card
    
    # Creates a new Done of type End
    def initialize(attacks, discards, card)
        super(attacks, discards)
        @card = card
    end
    
    # Are these two Ends the same?
    # Returns Boolean
    def equal?(done)
        if (done.card.nil? && self.card.nil?)
          return Attack.same_attack_list?(@attacks, done.attacks) &&
                Squadron.same_squad_list?(@discards, done.discards) 
        else
            return Attack.same_attack_list?(@attacks, done.attacks) &&
          Squadron.same_squad_list?(@discards, done.discards) && 
          @card.cards_have_same_name?(done.card)
        end
    end
end
