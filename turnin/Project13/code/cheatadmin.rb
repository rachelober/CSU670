# !/arch/unix/bin/ruby

# cheatadmin.rb
# First included in Project 11
# Includes class and methods for CheatAdmin.

class CheatAdmin
  # new : ListOf-PlayerState -> CheatAdmin
  #
  # Creates an Admin to monitor Cheating in the game
  def initialize(playerstates)
    @playerstates = playerstates
  end

  # checker? : Player Turn Done -> Boolean
  #
  # Determines whether the actions during the turn and the results of the turn 
  # are consistent with the rules of the game
  def checker?(player, turn, done) 
    if done.end?
      check_battle_really_over?(player, turn, done)
    end

    if !(check_attack_fighters_in_hand?(player, turn, done) &&
      check_attack_bombers_from_table?(turn, done) &&
      check_discards_in_hand?(player, turn, done) &&
      check_borc_in_hand?(player, turn, done) &&
      check_only_play_once?(player, turn, done) &&
      check_discards_removed_from_hand?(player, turn, done) &&
      check_valid_squadrons?(done)
      check_all_discards_valid?(done))
      raise Cheating, "Player is cheating!"
    else
      true
    end
  end

  # check_battle_really_over? : Player Turn Done : Boolean
  #
  # Determines if the Battle is really over or if the Player is Lying.
  def check_battle_really_over?(player, turn, done)
    expected_hand = expected_hand(player, turn)
    expected_discards = all_discards(done)

    if !(expected_hand - expected_discards).empty? || 
      (!turn.turn_card_on_deck? && turn.turn_stack_inspect < 3)
      raise Cheating, "Player is lying, battle not really over!"
    else
      true
    end
  end

  # check_attack_fighters_in_hand? : Player Turn Done -> Boolean
  #
  # Determines whether the Fighter cards they are playing in Attacks are valid.
  def check_attack_fighters_in_hand?(player, turn, done)
    expected_hand = expected_hand(player, turn)

    fighter_list = done.attacks.map{|attack|
      attack.fighter.list_of_cards
    }.flatten

    if !fighter_list.all?{|card| expected_hand.include?(card)}
      raise Cheating, "Player is using fighter cards not in his/her hand!"
    else
      true
    end
  end

  # check_attack_bombers_from_table? : Turn Done -> Boolean
  #
  # Determines whether the Bomber cards they are playing in Attacks are valid.
  def check_attack_bombers_from_table?(turn, done)
    from_table = turn.list_of_squadrons.map{|squadron|
      squadron.list_of_cards
    }.flatten

    bomber_list = done.attacks.map{|attack|
      attack.bomber.list_of_cards
    }.flatten

    if !bomber_list.all?{|card| from_table.include?(card)}
      raise Cheating, "Player is not using Bombers from the table!"
    else
      true
    end
  end

  # check_discards_in_hand? : Player Turn Done -> Boolean
  #
  # Determines whether the cards discarded this Turn were part of the Player's Hand
  # or picked up from the Deck or Stack.
  def check_discards_in_hand?(player, turn, done)
    expected_hand = expected_hand(player, turn)

    discard_list = done.discards.map{|squad|
      squad.list_of_cards
    }.flatten
    
    if !discard_list.all?{|card| expected_hand.include?(card)}
      raise Cheating, "Player is discarding cards not in his/her hand!"
    else
      true
    end
  end

  # check_borc_in_hand? : Player Turn Done -> Boolean
  #
  # Determines if the player returns a card to the stack correctly
  def check_borc_in_hand?(player, turn, done)
    expected_hand = expected_hand(player, turn)
    
    if !done.card.nil? && !expected_hand.include?(done.card)
      raise Cheating, "Player is discarding card not in his/her hand!"
    else
      true
    end
  end
  
  # check_only_play_once? : Player Turn Done -> Boolean
  #
  # Determines if any cards are being played by the Player more than one time.
  def check_only_play_once?(player, turn, done)
    played_cards = all_discards(done)

    valid_discards = played_cards.uniq

    if played_cards != valid_discards
      raise Cheating, "Player is using cards more than once!"
    else
      true
    end
  end

  # check_discards_removed_from_hand? : Player Turn Done -> Boolean
  #
  # Determines if the Player has really removed the cards from their Hand.
  def check_discards_removed_from_hand?(player, turn, done)
    played_cards = all_discards(done)

    player_hand = player.player_hand.hand_to_list

    played_cards.each{|card|
      if player_hand.include?(card)
        raise Cheating, "Played is not discarding the cards he/she is playing!"
      end
    }
    true
  end
  
  # check_valid_squadrons? : Done -> Boolean
  #
  # Determines if the Squadrons discarded have valid format.
  def check_valid_squadrons?(done)
    if !done.discards.all?{|squad|
      squad.squadron? &&
      squad.squadron_complete?}
      raise Cheating, "Player is discarding invalid Squadrons!"
    else
      true
    end
  end

  # check_valid_tags? : Card -> Boolean
  #
  # Determines if the Aircrafts and Keepems the Player is playing have valid tags.
  def check_valid_tags?(card)
    if card.aircraft? 
      if card.tag > 3 || card.tag < 0
        raise Cheating, "Player has an Aircraft with an invalid tag!"
      end
    elsif card.keepem?
      if card.index > 6 || card.index < 0
        raise Cheating, "Player has a Keepem with an invalid tag!"
      end
    else
      true
    end
  end

  # check_all_discards_valid? : Done -> Boolean
  #
  # Determines if all the cards the Player is playing are valid.
  def check_all_discards_valid?(done)
    all_discards = all_discards(done)

    all_discards.each{|card|
      check_valid_tags?(card)
    }
    true
  end

  private
  # expected_hand : Player Turn -> ListOf-Cards
  #
  # Figures out what the Player should have available in their Hand.
  def expected_hand(player, turn)
    my_player = @playerstates.detect{|playerstate| playerstate.name == player.player_name}
    expected_hand = my_player.hand.hand_to_list
    cardsfrom = turn.turn_end
    if cardsfrom.from_deck?
      new_cards = [turn.deck.take]
    elsif cardsfrom.from_stack?
      new_cards = turn.stack.take(cardsfrom.how_many_cards?)
    end
    expected_hand = expected_hand + new_cards
  end

  # all_discards : Done -> ListOf-Cards
  #
  # Returns all the Cards the Player is playing this Turn.
  def all_discards(done)
    discard_list = done.discards.map{|squad|
      squad.list_of_cards
    }.flatten
    
    fighter_list = done.attacks.map{|attack|
      attack.fighter.list_of_cards
    }.flatten

    bomber_list = done.attacks.map{|attack|
      attack.bomber.list_of_cards
    }.flatten
    
    played_cards = discard_list + fighter_list + bomber_list + [done.card]
    played_cards.sort
  end
end
