# !/arch/unix/bin/ruby

# administrator.rb
# First included in Project 7
# Includes class and methods for Administrator

# Required Files
#require 'code/war.rb'
#require 'code/battle.rb'

class Administrator
  include DesignByContract
  attr_reader :players
  # new : ? -> Administrator
  #
  # Creates an empty Administator instance
  def initialize
    @players = [] # ListOf-Player, remove and change play_one_turn to take a PlayerState
    @playerstates = [] # ListOf-PlayerStates
  end

  # Stucture for Admin to track Player information
  PlayerState = Struct.new( "PlayerState", :name, :hand, :score, :status )
  
  # register_player : Administrator Player -> ListOf-PlayerState
  #
  # Adds a player to the game
  def register_player(player)
    @players << player
    playerstate = PlayerState.new( player.player_name, 
      Hand.new([]), 0, true )
    @playerstates << playerstate
    @players
  end

  # run_game : Administrator Boolean -> War
  #
  # Creates a war and runs the game
  # With or without printing the results
  def run_game
    war = War.new(@players, @playerstates)
    war.run_war
  end
end
