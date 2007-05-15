# !/arch/unix/bin/ruby

# administrator.rb
# First included in Project 7
# Includes class and methods for Administrator

require 'code/runtimeerror.rb'

class Administrator
  
  # new : ? -> Administrator
  #
  # Creates an empty Administator instance
  def initialize
  end

  # play_one_turn : Player Deck Stack ListOf-Squadron
  # -> Boolean (Card or Boolean) ListOf-Squadron ListOf-Attack CardsFrom
  # -> or Error
  #
  # Play one turn with the given player, using the current deck,
  # the current stack, and the list of of discarded squadrons from
  # all other players
  #
  # play_one_turn : Player Deck Stack ListOf-Squadrons -> *
  #   error or:                     ;; is the player cheating?
  #   boolean?                      ;; is the battle over?
  #   (or/c card? boolean?)         ;; the return card (if any)
  #   (listof discard/c)            ;; the discarded squadrons 
  #   (listof attack?)              ;; the attacks 
  #   (or/c from-deck? from-stack?) ;; where were the cards taken from?
  # 
  def play_one_turn(player, deck, stack, discards)
    turn = Turn.create_turn(deck, stack, discards)
    done = player.player_take_turn(turn)
    battle_over = (player.player_hand.size == 0)
    if done.card.nil?
      return_card = false
    else
      return_card = done.card
    end
   list_of_discards =  done.discards
   list_of_attacks = done.attacks
   from_where = turn.turn_end   
   return battle_over, return_card, list_of_discards, list_of_attacks, from_where
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
    hand_list = player.player_hand.list_of_cards
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
    if !done.attacks.all?{|attack|
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
end
