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

  # run_war : War Boolean -> War
  #
  # Run a war according to Squadron Scramble rules
  def run_war
    battle = Battle.new(@players, @playerstates)
    count = 0
    until (@playerstates.any?{|playerstate| playerstate.score > 250} || @players.size < 2)
      battle = battle.run_battle
      count +=1
    end
   
    puts "War took #{count} battles."
    battle.banned.each{|banned|
      puts banned.name + ": " + banned.status.to_s
    }
    battle.playerstates.each{|playerstate|
      puts playerstate.name + ": " + playerstate.score.to_s
    }
  end
end
