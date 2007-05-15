# !arch/unix/bin/ruby

# run_tournament.rb
# First included in Project 11
# Creates an Administrator and runs a game with different Players
require 'code/code.rb'

admin = Administrator.new

god_player = Player.create("God", false)
budda_player = Player.create("Budda", false)
#moses_player = Player.create("Moses", false)
jesus_player = Player.create("Jesus", false, CheaterStrategy.new)
#angel_player = Player.create("Angel", false)
#venus_player = Player.create("Venus", false)

admin.register_player(god_player)
admin.register_player(budda_player)
#admin.register_player(moses_player)
admin.register_player(jesus_player)
#admin.register_player(angel_player)
#admin.register_player(venus_player)

# Run the war
battle_count, banned, playerstates = admin.run_war

# Print the results to screen
puts "War took #{battle_count} battles." 
banned.each{|banned| puts banned.name + ": " + banned.status.to_s }
playerstates.each{|playerstate| puts playerstate.name + ": " + playerstate.score.to_s }
