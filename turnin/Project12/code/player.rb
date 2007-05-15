# !/arch/unix/bin/ruby

# player.rb
# First included in Project 5
# Includes all of the classes needed for Player

# Required Files
require 'code/attack.rb'
require 'code/done.rb'
require 'code/hand.rb'
require 'code/observer_player.rb'
require 'code/strategy.rb'

# Constructs the Player class.
# A Player can pursue many different strategies
# and even switch strategies during a game.
class Player
  include DesignByContract
  attr_reader :gui, :discards, :shot_down

  # new : String Boolean Strategy -> Player
  #
  # Create a new Object of type Player.
  def initialize(name, gui, strategy)
    @name = name                    # String
    @hand = Hand.create(Array.new)  # Hand
    @gui = gui                      # Boolean
    @strategy = strategy            # Strategy
    @discards = []                  # ArrayOf-Squadron
    @shot_down = []                 # ArrayOf-Squadron
    @list_of_observers = []         # ArrayOf-ObserverPlayer
  end

  # create : String Boolean Strategy -> Player
  #
  # Calls the initialize method.
  def Player.create(name, gui, strategy = Strategy.new)
    player = Player.new(name, gui, strategy)
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

  # player_first_hand : Player ListOf-Card -> Hand
  #
  # Deals the Player their first Hand.
  def player_first_hand(hand_list)
    @hand = Hand.new(hand_list)
    @shot_down = []
    @discards = []
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
  pre(:player_take_turn, "Input must be an instance of Turn."){|turn| 
    (turn.instance_of?(Turn)||turn.instance_of?(ProxyTurn))} 
  pre(:player_take_turn, "There needs to be at least one card on the Deck or 
      one card on the Stack."){|turn| (turn.turn_stack_inspect.size > 0 || turn.turn_card_on_deck?)}
  post(:player_take_turn, "Result must be a kind of Done") {|result, turn| result.kind_of?(Done)}
  def player_take_turn(turn)
    self.notify
    list_of_cards = @strategy.choose_cards(turn, self)
    attacks, discards = self.play_hand(list_of_cards, 
                       turn.turn_can_attack?(Axis.new), 
                       turn.turn_can_attack?(Allies.new))
    card = @strategy.discard_card(self)
    done = @strategy.make_done(self, attacks, discards, card)
    @hand = @hand.minus([card])
    self.notify
    done
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
     
    # Go through and make our attacks. Then we need to keep track of which
    # ones were shot down and which one are considered
    # "discards". Finally, update the Hand.
    attacks = @strategy.make_attacks(self, list_of_allies, list_of_axis)
    fighters = []
    attacks.each {|x|
      @shot_down << x.bomber 
      @discards << x.fighter
      fighters << x.fighter
    }
    self.update_hand(fighters)
    self.notify
    
    # Now we go through and make our discards.
    # We keep track again of which we play in our discarded pile.
    # Then we update our Hand.
    discards = @strategy.make_discards(self, list_of_allies, list_of_axis)
    discards.each {|x| @discards << x }
    self.update_hand(discards)
    self.notify

    # We return the attacks and discards so that they can be used to make
    # a Done.
    return attacks, discards
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
  
  # update_hand : Player ListOf-Squadron -> Hand
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
    # Sleep if it is a gui because we don't want our tests to be sloooow
    if gui
      @list_of_observers.each {|x| x.update }
      sleep(3)
    end
    nil
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

  # inform_shotdown : Player ListOf-Squadron -> ?
  def inform_shotdown(list_of_squadrons)
    @discards = @discards - list_of_squadrons
    self.notify
  end
end
