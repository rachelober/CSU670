# !/arch/unix/bin/ruby

# administrator.rb
# First included in Project 7
# Includes class and methods for Administrator

# Required Files
require 'code/runtimeerror.rb'
#require 'code/war.rb'
#require 'code/battle.rb'

# Required Modles
require 'modules/dbc.rb'

class Administrator
  include DesignByContract

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

end
