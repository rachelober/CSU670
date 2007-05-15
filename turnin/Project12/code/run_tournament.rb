# !arch/unix/bin/ruby

# run_war.rb
# First included in Project 11
# Creates an Administrator and runs a game with different Players

admin = Administrator.new

god_player = Player.create("God", false, TimingBreakerStrategy.new)
budda_player = Player.create("Budda", false)
moses_player = Player.create("Moses", false)
jesus_player = Player.create("Jesus", false, CheaterStrategy.new)
#angel_player = Player.create("Angel", false)
#venus_player = Player.create("Venus", false)

admin.register_player(god_player)
admin.register_player(budda_player)
admin.register_player(moses_player)
admin.register_player(jesus_player)
#admin.register_player(angel_player)
#admin.register_player(venus_player)
admin.run_game
