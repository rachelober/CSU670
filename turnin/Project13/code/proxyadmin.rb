# !arch/unix/bin/ruby

# proxyadmin.rb
# First included in Project 13
# This is an abstracted class of Administrator.

require 'code/code.rb'
require 'code/proxyturn.rb'
require 'timeout'

class ProxyAdmin

  # Creates a ProxyAdmin to talk to Server
  def initialize(socket)
    @socket = socket    # TCPSocket
    @player = nil       # Player
  end

  # register_player : ProxyAdmin Player -> Boolean
  #
  # Adds a player to ProxyAdmin, to be added to Game
  def register_player(player)
    @player = player
    document = Document.new 
    document.add_element "REGISTER", {"name"=>"#{player.player_name}"}
    @socket.puts document
    begin
      Timeout::timeout(5) do
        bool = @socket.readline
        bool.chomp!
        bool_doc = Document.new bool
        bool_doc.root.name == "TRUE"
      end
    rescue Timeout::Error
      return false
    end
  end

  # run : ProxyAdmin String -> Any
  #
  # Connect to server
  def run(msg)
    doc = Document.new msg
    case
    when doc.root.name == "SQUADRON"
      squad = Squadron.xml_to_squad(doc)
      hand_list = squad.list_of_cards
      @player.player_first_hand(hand_list)
      @socket.puts "<TRUE />"
      STDOUT.puts "Recieved first hand from Server."
    when doc.root.name == "TURN"
      proxyturn = ProxyTurn.xml_to_proxyturn(doc, @socket)
      done = @player.player_take_turn(proxyturn)
      done.discards.each{|discard|
        STDOUT.puts "Discarded: #{discard.to_s}"
      }
      done.attacks.each{|attack|
        STDOUT.puts "Attacked: #{attack.to_s}"
      }
      done = done.done_to_xml
      @socket.puts done
    when doc.root.name == "INFORM"
      squadron = XMLHelper.inform_to_squadron(doc)
      bool = @player.inform(squadron)
      STDOUT.puts "Squadron was shot down."
      @socket.puts XMLHelper.boolean_to_xml(bool)
    when doc.root.name == "TEND"
      kick = doc.elements[1].attributes["msg"]
      STDOUT.puts "Game Over: #{kick}."
    end
  end
end
