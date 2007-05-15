# !/arch/unix/bin/ruby

# player.rb
# First included in Project 5
# Includes all of the classes needed for Player

# Required Files
require 'code/attack.rb'
require 'code/done.rb'
require 'code/hand.rb'
require 'code/observer_player.rb'

# Constructs the Player class.
# A Player can pursue many different strategies
# and even switch strategies during a game.
class Player
  include DesignByContract
  attr_reader :gui, :discards, :shot_down

  # new : String Boolean -> Player
  #
  # Create a new Object of type Player.
  def initialize(name, gui)
    @name = name                   # String
    @hand = Hand.create(Array.new) # Hand
    @gui = gui                     # Boolean
    @discards = []                 # ArrayOf-Squadron
    @shot_down = []                # ArrayOf-Squadron
    @list_of_observers = []        # ArrayOf-ObserverPlayer
  end

  # create : String Boolean -> Player
  #
  # Calls the initialize method.
  def Player.create(name, gui)
    player = Player.new(name, gui)
    if gui
      ObserverPlayer.new(player)
    end
    player
  end

  # player_name : Player -> String
  #
  # What is the Player's name?
  def player_name
    @name
  end

  # player_hand : Player -> Hand
  #
  # What is the Player's Hand?
  def player_hand
    @hand
  end

  # player_first_hand : Player Hand -> Hand
  #
  # Deals the Player their first Hand.
  def player_first_hand(first_hand)
    @hand = @hand.plus(first_hand)
    self.notify
    @hand
  end

  # player_take_turn : Player Turn -> Done
  #
  # Allows the Player to take a turn.
  # This method first chooses where to pick a Card from (Deck or Stack)
  # and then runs the play_hand method that goes through
  # and decides which cards to play. After that is done,
  # this method decides which Card to return (if any).
  pre(:player_take_turn, 
    "Input must be an instance of Turn and there needs to be at least one card on the Deck or one card on the Stack") {
    |turn| (turn.instance_of?(Turn)||turn.instance_of?(ProxyTurn)) && 
    (turn.turn_stack_inspect.size > 0 || 
     turn.turn_card_on_deck?)}
  post(:player_take_turn, "Result must be a kind of Done") {|result, turn| result.kind_of?(Done)}
  def player_take_turn(turn)
    self.notify
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
    
    attacks, discards = self.play_hand(list_of_cards, 
                       turn.turn_can_attack?(Axis.new), 
                       turn.turn_can_attack?(Allies.new))
    if @hand.size == 0
      self.notify
      return End.new(attacks, discards, nil)
    elsif @hand.size == 1
      card = @hand.hand_to_list.first
      @hand = @hand.minus(Array.new.push(card))
      self.notify
      return End.new(attacks, discards, card)
    else
      rand_index = rand(@hand.size)
      card = @hand.hand_to_list.fetch(rand_index)
      @hand = @hand.minus(Array.new.push(card))
      self.notify
      return Ret.new(attacks, discards, card)
    end
  end  

  # play_hand : Player ListOf-Card ListOf-Squadron ListOf-Squadron -> ListOf-Attack ListOf-Squadron
  #
  # The user plays his hand. The Player takes a list of cards 
  # taken from the Stack or Deck, a list of Squadrons of Allies of other 
  # players and a list of Squadrons of Axis from other players.
  # This method runs the make_max_attacks and make_max_discards methods
  # to play cards. After the max squadrons can be made, it updates the hand.
  def play_hand(list_of_cards, list_of_allies, list_of_axis)
    @hand = @hand.plus(list_of_cards)
    self.notify
     
    # Go through and make the maximum amount of attacks. Then we need
    # to keep track of which ones were shot down and which one are considered
    # "discards". Finally, update the Hand.
    attacks = self.make_max_attacks(list_of_allies, list_of_axis)
    fighters = []
    attacks.each {|x|
      @shot_down << x.bomber 
      @discards << x.fighter
      fighters << x.fighter
    }
    self.update_hand(fighters)
    self.notify
    
    # Now we go through and make the miximum amount of discards.
    # We keep track again of which we play in our discarded pile.
    # Then we update our Hand.
    discards = self.make_max_discards(list_of_allies, list_of_axis)
    discards.each {|x| @discards << x }
    self.update_hand(discards)
    self.notify

    # We return the attacks and discards so that they can be used to make
    # a Done.
    return attacks, discards
  end
  
  # make_max_attacks : Player ListOf-Squadron ListOf-Squadron -> ListOf-Attack
  #
  # What attacks can the Player make?
  # This method takes into consideration the different squadrons played
  # by other players and tries to make the maximum amount of attacks
  # from their cards.
  def make_max_attacks(list_of_allies, list_of_axis)
    complete_fighter_squads = @hand.completes.find_all {|squad| squad.squadron_fighter?}
    complement_fighter_squads = @hand.complementable.find_all {|squad| squad.squadron_fighter?}

    # We need to make sure that we don't make attacks with squadrons that have already been used
    complete_fighter_squads = self.remove_used_squads(complete_fighter_squads, list_of_allies, list_of_axis)
    complement_fighter_squads = self.remove_used_squads(complement_fighter_squads, list_of_allies, list_of_axis)
    
    wildcards = @hand.wildcards
    attacks = []
    # First we'll go through and make attacks from our known completed squadrons.
    # Then we can go back over and decide which incomplete squadrons we should
    # add wildcards to.
    complete_fighter_squads.dup.each{|squad|
      if squad.squadron_alliance.instance_of?(Allies) && list_of_axis.size > 0
        attacks << Attack.new(squad, list_of_axis.shift)
      elsif squad.squadron_alliance.instance_of?(Axis) && list_of_allies.size > 0
        attacks << Attack.new(squad, list_of_allies.shift)
      end
    }

    # What we need to look at is whether we should add a WildCard to
    # the incomplete Squadron or not. We SHOULD if there is an opposing 
    # Squadron we can fight but we SHOULD NOT if there is not an opposing
    # Bomber to attack. If we decide to add a WildCard, we then make an 
    # attack with that Fighter Squadron and the opposing Bomber Squadron.
    complement_fighter_squads.dup.each{|squad|
      if wildcards.size > 0
        if squad.squadron_alliance.instance_of?(Allies) && list_of_axis.size > 0
          if wildcards.size >= 2 && squad.list_of_cards.size == 1
            attacks << Attack.new(squad.push!(wildcards.shift).push!(wildcards.shift), 
                        list_of_axis.shift)
          else
            attacks << Attack.new(squad.push!(wildcards.shift), list_of_axis.shift)
          end
        elsif squad.squadron_alliance.instance_of?(Axis) && list_of_allies. size > 0
          if wildcards.size >= 2 && squad.list_of_cards.size == 1
            attacks << Attack.new(squad.push!(wildcards.shift).push!(wildcards.shift), 
                        list_of_allies.shift)
          else
            attacks << Attack.new(squad.push!(wildcards.shift), list_of_allies.shift)
          end
        end
      end
    }

    # Now return all the attacks we've made
    attacks
  end

  # make_max_discards : Player ListOf-Squadron ListOf-Squadron -> ListOf-Squadron
  #
  # What squadrons can the user play? This method looks at the player's 
  # Hand and determines what other squadrons can be discarded. This method 
  # is usually called after analyzing which attacks can be played
  # so the maximum amount of points can be aquired.
  def make_max_discards(list_of_allies, list_of_axis)
    complete_squads = @hand.completes
    complement_squads = @hand.complementable
    wildcards = @hand.wildcards
     
    # We need to make sure that we don't make attacks with squadrons that have already been used
    complete_squads = self.remove_used_squads(complete_squads, list_of_allies, list_of_axis)
    complement_squads = self.remove_used_squads(complement_squads, list_of_allies, list_of_axis)

    # Look through complement squadrons and go ahead and add
    # WildCards to them.
    complement_squads.each{|squadron|
      if wildcards.size > 0
        if wildcards.size >= 2 && squadron.list_of_cards.size == 1
          squadron.push!(wildcards.shift)
          squadron.push!(wildcards.shift)
        else
          squadron.push!(wildcards.shift)
        end
      end
    }

    # Combine the two lists of Squadrons
    all_squads = complete_squads.dup.concat(complement_squads)
    
    # Now we go through and make sure all the Squadrons
    # are complete.
    all_squads.find_all {|squadron|
      squadron.squadron_complete?
    }
  end

  # remove_used_squads : ListOf_Squadron ListOf-Squadron ListOf-Squadron -> ListOf-Squadron
  #
  # Goes through and removes everything that has been played already so
  # we can still make the max amount of squadrons without repeating.
  def remove_used_squads(our_squads, list_of_allies, list_of_axis)
    used_squads = list_of_allies.dup.concat(list_of_axis.dup).concat(@discards.dup).concat(@shot_down.dup)
    
    our_squads.delete_if {|squad|
      used_squads.any? {|used| used.squadron_name == squad.squadron_name}
    }
  end
  
  # update_hand : Player ListOf-Attack ListOfDiscard -> Hand
  #
  # Updates the hand to get rid of Squadrons we've played.
  # This way, each time we run methods like make_max_attacks
  # and make_max_discards, we'll always be working with an updated hand.
  def update_hand(list_of_squadrons)
    # This handy line of code goes through and first picks out
    # each squadron and then goes into each squadron
    # and retrieves each card to add to the list.
    list_of_cards = list_of_squadrons.map do |squad| 
      squad.list_of_cards
    end.map do |card|
      card
    end
    list_of_cards.flatten!

    # The we return a Hand and update our Hand to reflect the new changes.
    @hand = @hand.minus(list_of_cards)
  end

  # notify : Player -> nil
  #
  # Goes through the Player's list of Observers and tells them to update.
  def notify
    if @gui
      @list_of_observers.each {|x| x.update }
      sleep(5)
    end
  end

  # get_state : Player -> Player
  #
  # Called from an Observer. This method gets the current state of the Player.
  def get_state
    self
  end

  # subscribe : Player PlayerObserver -> ListOf-Observer
  #
  # Adds an observer to the list_of_observers
  def subscribe(observer)
    @list_of_observers << observer
  end

  # player_score : Player -> String
  #
  # What is the player's guaranteed score?
  # This takes into account of all Squadrons shot down of type Bomber as well as
  # Fighters the Player has put down. It does not take into account the Bombers
  # the player has played because these could potentially be shot down
  # by other players and therefore not part of the guaranteed score.
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
