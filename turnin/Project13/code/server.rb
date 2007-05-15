# !arch/unix/bin/ruby

# server.rb
# First included in Project 13
# Creates the Server to host a Game.

require 'socket'
require 'code/code.rb'
require 'code/proxyplayer.rb'

class GameServer
  def initialize(admin, server)
    @admin = admin

    puts "Server is ready."
    while(session = server.accept)
      register_thread = Thread.new{register_players(session)}
      start_thread = Thread.new{wait_for_start}
    end

  end

  def register_players(session)
    mesg = session.gets
    document = Document.new mesg

    proxyplayer = ProxyPlayer.new(document.root.attributes['name'], session)
    if @admin.register_player(proxyplayer)
      session.puts "<TRUE />"
      STDOUT.puts "Player #{proxyplayer.player_name} registered."
    else
      session.puts "<FALSE />"
      STDOUT.puts "Player #{proxyplayer.player_name} tried to register, but was rejected."
    end
  end

  def wait_for_start
    while(ref = STDIN.readline)
      ref.chomp!
      if ref == "Start Game"
        battle_count, banned, playerstates = @admin.run_war
        STDOUT.puts "War ended in #{battle_count} battles."
        banned.each{|banned| STDOUT.puts "#{banned.name}: #{banned.status}"}
        playerstates.each{|playerstate| STDOUT.puts "#{playerstate.name}: #{playerstate.score}"}
      end
    end
  end
end

admin = Administrator.new()
server = TCPServer.new(8080)
game = GameServer.new(admin, server)
