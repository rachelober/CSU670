# !/arch/unix/bin/ruby

# cheatadmin.rb
# First included in Project 11
# Includes class and methods for Administrator

# Required Files
#require 'code/administrator.rb'
require 'code/runtimeerror.rb'

class CheatAdmin

  # new : -> CheatAdmin
  #
  # Creates an Admin to monitor Cheating in the game
  def initialize(playerstates)
    @playerstates = playerstates
  end

  # checker? : Player Done -> Boolean
  #
  # Determines whether the actions during the turn and the results of the turn 
  # are consistent with the rules of the game
  def checker?(player, done) 
    if !(check_discards_in_hand?(player, done) &&
      check_only_play_once?(player, done) &&
      check_valid_squadrons?(done) &&
      check_valid_attacks?(done))
      raise Cheating, "Player is cheating"
    else
      true
    end
  end

  # check_discards_in_hand? : Player Done -> Boolean
  #
  # Determines whether the cards discarded this turn were part of the player's hand
  def check_discards_in_hand?(player, done)
  #  puts player.player_name
  #  puts @playerstates
    my_player = @playerstates.detect{|playerstate|
      playerstate.name.to_s == player.player_name}
    hand_list = my_player.hand.list_of_cards
    discard_list = done.discards.map{|squad|
      squad.list_of_cards
    }.flatten
    if !discard_list.all?{|card| hand_list.include?(card)}
      raise Cheating, "Player is discarding cards not in his/her hand"
    else
      true
    end
  end

  # check_only_play_once? : Player Done -> Boolean
  #
  # Determines if any cards are being played by the player more than one time
  def check_only_play_once?(player, done)
    discard_list = done.discards.map{|squad|
      squad.list_of_cards
    }.flatten
    discard_list << done.card
    valid_discards = discard_list.uniq
    if discard_list != valid_discards
      raise Cheating, "Player is using cards more than once"
    else
      true
    end
  end
  
  # check_valid_squadrons? : Done -> Boolean
  #
  # Determines if the squadrons discarded have valid format
  def check_valid_squadrons?(done)
    if !done.discards.all?{|squad|
      squad.squadron? &&
      squad.list_of_cards.nitems == 3}
      raise Cheating, "Player is discarding invalid Squadrons"
    else
      true
    end
  end

  # check_valid_attacks? : Done -> Boolean
  #
  # Determines if the attacks made this turn are valid
  def check_valid_attacks?(done)
    if !done.attacks.nil? && !done.attacks.all?{|attack|
      attack.fighter.squadron? &&
      attack.bomber.squadron? &&
      attack.fighter.list_of_cards.nitems == 3 &&
      attack.bomber.list_of_cards.nitems == 3 &&
      attack.bomber.squadron_alliance != attack.fighter.squadron_alliance &&
      attack.bomber.squadron_bomber? &&
      attack.fighter.squadron_fighter?}
      raise Cheating, "Player making invalid Attacks"
    else
      true
    end
  end

  # check_valid_borc? : Player Done -> Boolean
  #
  # Determines if the player returns a card to the stack correctly
  def check_valid_borc(player, done)
    if !player.player_hand.include?(done.card)
      raise Cheating, "Player is not discarding onto Stack corectly"
      # Add more checks here, don't compare against the player's hand
    else
      true
    end
  end
end
