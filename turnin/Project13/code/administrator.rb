# !/arch/unix/bin/ruby

# administrator.rb
# First included in Project 7
# Includes class and methods for Administrator

class Administrator
  include DesignByContract
  attr_reader :playerstates, :players 
  # new : -> Administrator
  #
  # Creates an empty Administator instance.
  def initialize
    @players = []         # ListOf-Player
    @playerstates = []    # ListOf-PlayerState
    @banned = []          # ListOf-PlayerState
    @started = false      # Boolean
  end

  # register_player : Administrator Player -> Boolean
  #
  # Adds a player to the game
  def register_player(player)
    if registration_closed?(player)
      false
    else
      @players << player
      playerstate = PlayerState.new( player.player_name, Hand.new([]), 0, true )
      @playerstates << playerstate
      true
    end
  end

  # run_war : Administrator -> Integer ListOf-PlayerState ListOf-PlayerState
  #
  # Run a war according to Squadron Scramble rules.
  # Returns two lists, one of all the banned PlayerStates and
  # one with the rest of the PlayerStates.
  def run_war
    @started = true
    battle_count = 0
    
    battle = Battle.new(@players, @playerstates, @banned)
    until (war_over?)
      battle = battle.run_battle
      STDOUT.puts "Battle end, below are current scores:"
      playerstates.each{|playerstate| STDOUT.puts "#{playerstate.name}: #{playerstate.score}"}
      battle_count +=1
    end

    return battle_count, @banned, @playerstates
  end

  private
  # registration_closed? : Administrator Player -> Boolean
  #
  # Is the registration for this game closed?
  def registration_closed?(player)
    @players.any? {|x| x.player_name == player.player_name} ||
    @banned.any? {|x| x.name == player.player_name} ||
    @started == true || 
    @players.size >= 6
  end

  # war_over? : Administrator -> Boolean
  #
  # Decides if the Tournament is over or not.
  def war_over?
    @playerstates.any?{|playerstate| playerstate.score > 250} || @players.size < 2
  end
end
