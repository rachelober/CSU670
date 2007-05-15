# !/arch/unix/bin/ruby

# battle.rb
# First included in Project 11
# Includes class and methods for running a War

class Battle  
  include DesignByContract
  attr_reader :table 
  # new : ListOf-Player -> Battle
  #
  # Create a Battle.
  def initialize(players, playerstates, banned)
    @players = players                                # ListOf-Player
    @playerstates = playerstates                      # ListOf-PlayerState
    @deck = Deck.create.shuffle                       # Deck
    @stack = Stack.create(@deck.deck_to_list.first)   # Stack
    @deck = @deck.pop                                 # Deck
    @table = []                                       # ListOf-SquadronState
    @banned = banned                                  # ListOf-PlayerState
  end

  # run_battle Battle : -> Battle
  #
  # Play one Battle and return the next Battle that would be played.
  def run_battle
    STDOUT.puts "Battle Started"
    deal_hands

    until (battle_over?)
      player = next_player
      playerstate = get_playerstate(player)
      maintain_deck(@deck, @stack)
      attackable_squads = attackable_squads(player)

      # Let the Player take their Turn
      thread = Thread.new do
        begin
          is_battle_over, return_card, turn_discards, turn_attacks, from_where = 
            play_one_turn(player, @deck, @stack, attackable_squads)
        rescue TimingError => mesg
          kick_player(player, playerstate, mesg)
          Thread.kill(self)
        rescue ContractViolation => mesg
          kick_player(player, playerstate, mesg)
          Thread.kill(self)
        rescue Cheating => mesg
          kick_player(player, playerstate, mesg)
          Thread.kill(self)
        end
        update_battle(return_card, turn_discards, turn_attacks, from_where, player, playerstate)
      end
      sleep_thread = Thread.new{sleep(5)}
      first_ended_thread = ThreadsWait.new(thread, sleep_thread).next_wait
      if first_ended_thread == sleep_thread
        Thread.kill(thread)
        kick_player(player, playerstate, "TIMED OUT")
      end
    end
    # Close out the Battle by updating score and setting up the next Battle
    update_score
    setup_next_battle
    STDOUT.puts "Battle Over"
    self
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
  pre(:play_one_turn, "Input must be a Player."){|player, deck, stack, discards| 
    player.kind_of?(Player)}
  pre(:play_one_turn, "Input must be a Deck."){|player, deck, stack, discards| 
    deck.instance_of?(Deck)}
  pre(:play_one_turn, "Input must be a Stack."){|player, deck, stack, discards| 
    stack.instance_of?(Stack)}
  pre(:play_one_turn, "Input must be a ListOf-Squadron"){|player, deck, stack, discards|
    discards.instance_of?(Array) &&
    discards.all?{|squad| squad.instance_of?(Squadron)}}
  post(:play_one_turn, "Must return Error or Boolean, Card/Boolean, ListOf-Squadron, ListOf-Attack, CardsFrom"){
    |result, player, deck, stack, discards|
    (result[0].instance_of?(TrueClass) || result [0].instance_of?(FalseClass)) &&
    (result[1].kind_of?(Card) || result[1].instance_of?(TrueClass) || result[1].instance_of?(FalseClass)) &&
    result[2].instance_of?(Array) &&
    result[2].all?{|squad| squad.instance_of?(Squadron)} &&
    result[3].instance_of?(Array) &&
    result[3].all?{|attack| attack.instance_of?(Attack)} &&
    result[4].kind_of?(CardsFrom)}
  def play_one_turn(player, deck, stack, discards)
    turn = Turn.create_turn(deck, stack, discards)
    done = player.player_take_turn(turn)
    CheatAdmin.new(@playerstates).checker?(player, turn, done)
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

  # equal_squadronstructs? : SquadronStruct SquadronStruct -> Boolean
  #
  # Determines if these two SquadronStructs are equal.
  def equal_squadronstructs?(struct1, struct2)
    struct1.squadron == struct2.squadron && 
    struct2.owner == struct2.owner
  end

  # equal_squadronstructs_list? : ListOf-SquadronStruct ListOf-SquadronStruct -> Boolean
  #
  # Determines if these two lists of SquadronStructs are equal.
  def equal_squadronstructs_list?(list1, list2)
    if list1.size != list2.size
      false
    else
      list1.each{|x|
        list2.include?(x)
      }
    end
  end

  private
  # maintain_deck : Battle Deck Stack -> Deck Stack
  #
  # If the Deck is empty, take the top card off the
  # Stack and make it the new Stack and shuffle the remaining 
  # Cards and make that the Deck.
  def maintain_deck(deck, stack)
    if deck.empty?
      temp_stack = stack.take(1)
      @deck = Deck.new(stack.pop!(1).list_of_cards)
      @deck = @deck.shuffle
      @stack = Stack.new(temp_stack)
    end

    return @deck, @stack
  end
  
  # attackable_squads : Battle Player -> ListOf-Squadron
  #
  # Find all the Squadrons that this Player may be able to attack.
  def attackable_squads(player)
    @table.find_all{|squadstate| 
      (squadstate.owner != player) && squadstate.attackable
    }.map{|squadstate|
      squadstate.squadron
    }
  end
  
  # update_score : Battle -> nil
  #
  # Update the player's score based on the results of the Battle.
  def update_score
    @table.each{|squad| 
      owner = @playerstates.detect{|playerstate| playerstate.name == squad.owner.player_name}
      owner.score = owner.score + squad.squadron.squadron_value} 
    @playerstates.each{|playerstate| playerstate.score =
      playerstate.score - playerstate.hand.value} 
    nil
  end
  
  # update_table : Battle ListOf-Squadron ListOf-Attack Player -> nil
  # 
  # Update table from the list_of_attacks and our_discards 
  # produced by running a turn
  def update_table(turn_discards, turn_attacks, player) 
    turn_discards.each{|squad|@table << SquadronState.new(squad, player, true)}
    
    turn_attacks.each{|attack|@table << SquadronState.new(attack.fighter, player, false)}
    
    turn_attacks.each{|attack|
      @table.each{|squadstate|
        if attack.bomber.equal?(squadstate.squadron)
          previous_owner = squadstate.owner
          previous_owner.inform(squadstate.squadron)
          squadstate.owner = player
          squadstate.attackable = false
        end
      }
    }
    nil
  end
  
  # deal_hands : Battle -> Battle
  # 
  # Deal hands at the begining of the Battle
  def deal_hands
    @playerstates.each{|playerstate|
      7.times{
        playerstate.hand = playerstate.hand.plus([@deck.take])
        @deck = @deck.pop
      } 
      player = @players.detect{|player| player.player_name == playerstate.name}
      bool = player.player_first_hand(playerstate.hand.hand_to_list)
      if !bool
        kick_player(player, playerstate, "Timed Out")
      end
    }
  end
  
  # update_battle : Battle -> nil
  #
  # Updates the Battle after a successful Turn.
  def update_battle(return_card, turn_discards, turn_attacks, from_where, player, playerstate)
    if from_where.from_deck?
      playerstate.hand = playerstate.hand.plus([@deck.take])
      @deck = @deck.pop
    elsif from_where.from_stack?
      playerstate.hand = playerstate.hand.plus(@stack.take(from_where.how_many_cards?))
      @stack = @stack.pop!(from_where.how_many_cards?)
    end
    update_playerstate(playerstate, turn_discards, turn_attacks, return_card)
    @stack = @stack.push(return_card)
    update_table(turn_discards, turn_attacks, player)
    nil
  end

  # next_player : Battle -> Player
  #
  # Goes through and picks the next Player to take their turn.
  def next_player
    last_player = @players.first
    @players.push(last_player)
    @players.shift
    @players.first
  end
   
  # get_playerstate : Battle Player -> PlayerState
  #
  # Gets the PlayerState of the given Player.
  def get_playerstate(player)
    state = @playerstates.detect{|playerstate|
      playerstate.name == player.player_name
    }
  end

  # kick_player : Battle Player PlayerState String -> nil
  #
  # Kicks the player from the Game.
  def kick_player(player, playerstate, mesg)
    STDOUT.puts "Kicked " + player.player_name + " for #{mesg}"
    player.tend(mesg)
    @players = @players.delete_if{|from_list| from_list.player_name == player.player_name}
    playerstate.status = "#{mesg}"
    @banned << playerstate
    @playerstates = @playerstates.delete_if{|from_list| from_list.name == playerstate.name}
  end
  
  # reset_playerstates : Battle -> nil
  #
  # Goes through and resets all PlayerStates' Hands to empty
  # and runs the player_reset method for each Player.
  def reset_playerstates
    @playerstates.each{|playerstate|
      playerstate.hand = Hand.new([])
    }
    nil
  end
  
  # setup_next_battle : Battle -> nil
  #
  # Sets up the next Battle to be run.
  # The table is cleared. A new Deck is created and shuffled. Then the 
  # first Card on the Deck is pushed onto the Stack and popped off 
  # the Deck. Then each PlayerState and Player are reset
  def setup_next_battle
    @table = []
    @deck = Deck.create.shuffle
    @stack = Stack.create(@deck.deck_to_list.first)
    @deck = @deck.pop
    reset_playerstates
    nil
  end
  
  # update_playerstate : Battle PlayerState ListOf-Squadron ListOf-Attack Card -> Hand
  #
  # Returns the PlayerState's Hand with what happened during the Turn.
  def update_playerstate(playerstate, turn_discards, turn_attacks, return_card)
    discard_list = turn_discards.map{|squad|
      squad.list_of_cards
    }.flatten
    
    fighter_list = turn_attacks.map{|attack|
      attack.fighter.list_of_cards
    }.flatten

    bomber_list = turn_attacks.map{|attack|
      attack.bomber.list_of_cards
    }.flatten
    
    played_cards = discard_list + fighter_list + bomber_list
    if return_card
      played_cards = played_cards + [return_card]
    end
    
    playerstate.hand = playerstate.hand.minus(played_cards)
  end

  # battle_over? : Battle -> Boolean
  #
  # Determines if the Battle should be ended. This happens if one of the
  # Players has no cards left in their Hand, there is only one player left
  # or if the Deck is empty and there are less than 3 Cards left on the Stack.
  def battle_over?
    @playerstates.any?{|playerstate| playerstate.hand.empty?} || 
    @players.size == 1 ||
    (@deck.empty? && (@stack.depth < 3))
  end
end
