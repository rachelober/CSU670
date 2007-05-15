# !/arch/unix/bin/ruby

# war.rb
# First included in Project 11
# Includes class and methods for running a War

class War
  
  # new : ListOf-Player -> War
  #
  # Creates a War
  def initialize(players, playerstates)
    @players = players # ListOf-Player
    @playerstates = playerstates # ListOf-PlayerState
  end

  # run_war : -> War
  #
  # Run a war according to Squadron Scramble rules
  def run_war
    until @playerstates.any?{|playerstate| playerstate.score < 250}
      next_battle = run_battle(@players, @playerstates)
      @players = next_battle.players
      @playerstates = next_battle.playerstates
    end
  end
end
