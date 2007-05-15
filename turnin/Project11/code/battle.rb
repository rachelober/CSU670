# battle.rb
# First included in Project 11
# Includes class and methods for running a War

# Required Modules
require 'modules/dbc.rb'

class Battle  
  include DesignByContract
  attr_reader :players, :playerstates, :deck, :stack, :table
  
  # new : ListOf-Player -> Battle
  #
  # Create a Battle
  def initialize(players, playerstates)
    @players = players # ListOf-Player
    @playerstates = playerstates # ListOf-PlayerStates
    @deck = Deck.create.shuffle
    @stack = Stack.create(@deck.deck_to_list.first)
    @deck = @deck.pop
    @table = [] # ListOf-SquadronStates
  end

  # Structure for tracking squadrons on the table
  SquadronState = Struct.new( "SquadronState", :squadron, :owner )
  
  # run_battle : -> Battle
  #
  # Play one Battle and return the next Battle that would be played
  def run_battle
    puts "New Battle "
    until self.playerstates.any?{|playerstate| playerstate.hand.empty?} || 
      (self.deck.empty? && (self.stack.depth < 3))
      
      # Play turns for each Player
      puts " New Turn "
      discards = @table.map{|squadstate| squadstate.squadron}
      @players.each{|player|
        is_battle_over, return_card, our_discards, list_of_attacks, from_where =
        self.play_one_turn(player, @deck, @stack, discards)
        # Update Battle bases on Turn results
        if from_where.from_deck?
          @deck = @deck.pop
        elsif from_where.from_stack?
          @stack = @stack.pop!(from_where.how_many_cards?)
        end
        our_discards.each{|squad|@table << SquadronState.new(squad, player.player_name)}
        list_of_attacks.each{|attack|@table << SquadronState.new(attack.bomber, player.player_name)}
        list_of_attacks.each{|attack|@table << SquadronState.new(attack.fighter, player.player_name)}
        shotdowns = list_of_attacks.map{|attack| attack.bomber}
        shotdown_states = shotdowns.map{|bomber| SquardronState.new(bomber, 
          @table.collect{|squad|squad.squadron.equal?(bomber)})}
        @players.each{|player|player.inform_shotdown(
          shotdowns.collect{|bomber| 
          @table.any?{|squad|
            squad.squadron.equal?(bomber) &&
            squad.owner.equal?(player.player_name)}})}
        @stack.push(return_card)
      }
    end
      # Update Score
      @playerstates.each{|playerstate| playerstate.score =
         playerstate.score - playerstate.hand.value} 
      @table.each{|squad| 
        owner = @playerstates.detect{|playerstate|
          playerstate.name == squad.owner}
        owner.score = owner.score + squad.squadron.squadron_value} 
      @playerstates.each{|playerstate|puts playerstate.score}
      puts " End Battle "
        
      @deck = Deck.create.shuffle
      @stack = Stack.create(@deck.deck_to_list.first)
      @deck = @deck.pop
      
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
  # 
  pre(:play_one_turn, "Input must be a Player, Deck, Stack, and ListOf-Squadron"){
    |player, deck, stack, discards| 
    player.instance_of?(Player) &&
    deck.instance_of?(Deck) &&
    stack.instance_of?(Stack) &&
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
    CheatAdmin.new(@playerstates).checker?(player, done)
    battle_over = (player.player_hand.size == 0)
    if done.card.nil?
      return_card = false
    else
      return_card = done.card
    end
    if done.card
      @stack = @stack.push(done.card)
    end
    list_of_discards =  done.discards
    list_of_attacks = done.attacks
    from_where = turn.turn_end   
    return battle_over, return_card, list_of_discards, list_of_attacks, from_where
  end  
end
