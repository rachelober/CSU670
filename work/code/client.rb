# !/arch/unix/bin/ruby

# client.rb
# First included in Project 13
# Client for connecting to server and playing a game

require 'code/code.rb'
require 'code/proxyadmin.rb'
require 'socket'

player_name = STDIN.gets 
player_name.chomp!
player_strategy = STDIN.gets
player_strategy.chomp!

case
when player_strategy == "Default"
  player_strategy = Strategy.new()
when player_strategy == "Timid"
  player_strategy = TimidStrategy.new()
when player_strategy == "Slow"
  player_strategy = SlowStrategy.new()
when player_strategy == "TimingBreaker"
  player_strategy = TimingBreakerStrategy.new()
when player_strategy == "Inspector"
  player_strategy = InspectorStrategy.new()
when player_strategy == "NoFighters"
  player_strategy = NoFightersStrategy.new()
when player_strategy == "Cheater"
  player_strategy = CheaterStrategy.new()
end

socket = TCPSocket.new('129.10.110.40', 8080)
STDOUT.puts "Connection Made"
player = Player.create(player_name, false, player_strategy)
proxyadmin = ProxyAdmin.new(socket)
bool = proxyadmin.register_player(player)
if bool
  STDOUT.puts "#{player.player_name} registered with Server."
else
  STDOUT.puts "#{player.player_name} could not register with Server."
  socket.close
end
while(msg = socket.gets)
  proxyadmin.run(msg)
end
  
