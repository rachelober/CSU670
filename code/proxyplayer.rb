# !/arch/unix/bin/ruby

# proxyplayer.rb
# First included in Project 7
# This is an abstracted class of Player

# Required files
require 'code/player.rb'
require 'code/hand.rb'
require 'code/xmlhelper.rb'
require 'timeout'

# ProxyPlayer tests the Player class.
class ProxyPlayer < Player

  # new : Name -> Player
  #
  # Create a new Object of type Player.
  def initialize(name, session)
    @name = name            # String
    @hand = Hand.create([]) # Hand
    @session = session      # TCP Session Information
  end

  # player_first_hand : ProxyPlayer ListOf-Card -> Boolean
  #
  # Deals the Player their first Hand.
  def player_first_hand(hand_list)
    hand = Hand.create(hand_list)
    hand = hand.hand_to_xml
    @session.puts hand
    puts "Gave hand to #{player_name}"
    begin
      Timeout::timeout(5) do
        bool = @session.gets
        bool_doc = Document.new bool
        bool_doc.root.name == "TRUE"
      end
    rescue Timeout::Error
      return false
    end
  end

  # player_take_turn  : ProxyPlayer Turn -> Done
  #
  # Grant this player a Turn.
  def player_take_turn(turn)
    @session.puts turn.turn_to_xml
    mesg = @session.gets      # What they want from deck/stack
    borc = run_message(mesg, turn)
    if borc.kind_of?(Card)
      @session.puts borc.card_to_xml
    else
      @session.puts "<OKAY />"
    end
    mesg2 = @session.gets
    done = run_message(mesg2, turn)
  end

  # inform : ProxyPlayer Squadron -> Boolean
  #
  # Inform the Sessioned Player that a Bomber Squadron was shot down.
  def inform(squadron)
    document = Document.new
    inform = document.add_element "INFORM"
    inform.add_element squadron.squadron_to_xml
    @session.puts document
    begin
      Timeout::timeout(5) do
        bool = @session.gets
        bool_doc = Document.new bool
        bool_doc.root.name == "TRUE"
      end
    rescue Timeout::Error
      STDOUT.puts "#{player_name} timed out when trying to inform squadron shot down."
      false
    end
  end

  # tend : ProxyPlayer String -> nil
  #
  # Informs the Player that the Game is over.
  def tend(mesg)
    document = Document.new
    document.add_element "TEND", {"msg"=>"#{mesg}"}
    @session.puts document
    @session.close
    nil
  end

  private
  # run_message : ProxyPlayer String Turn -> Any
  #
  # Runs either the turn_get_a_card_from_deck or turn_get_cards_from_stack
  # depending on which message was received.
  def run_message(mesg, turn)
    doc = Document.new mesg
    if doc.root.name == "TURN-GET-CARDS-FROM-STACK"
      num = doc.root.attributes['no'].to_i
      turn.turn_get_cards_from_stack(num)
    elsif doc.root.name == "TURN-GET-A-CARD-FROM-DECK"
      turn.turn_get_a_card_from_deck
    elsif (doc.root.name == "RET" || doc.root.name == "END")
      Done.xml_to_done(doc)
    end
  end
end  
