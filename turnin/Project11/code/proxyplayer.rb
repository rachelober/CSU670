# !/arch/unix/bin/ruby

# proxyplayer.rb
# First included in Project 7
# This is an abstracted class of Player

# Required Modules
require 'modules/rtparser.rb'

# Required files
require 'code/player.rb'
require 'code/hand.rb'
require 'code/xmlhelper.rb'
require 'rexml/document'
include REXML

# ProxyPlayer tests the Player class.
class ProxyPlayer < Player
  attr_reader :hand

  # new : Name -> Player
  #
  # Create a new Object of type Player.
  def initialize(name)
    @name = name            # String
    @hand = Hand.create([]) # Hand
  end
  
  # player_take_turn  : Player Turn -> Done
  #
  # Grant this player a Turn.
  def player_take_turn(turn)
    mesg = Document.new
    mesg_parser = RealTimeParser.new(STDIN, mesg)
    mesg_parser.parse

    run_message(mesg, turn)

    mesg2 = Document.new
    mesg2_parser = RealTimeParser.new(STDIN, mesg2)
    mesg2_parser.parse

    run_message(mesg2, turn)
  end

  # run_message : Document Turn -> Any
  #
  # Runs either the turn_get_a_card_from_deck or turn_get_cards_from_stack
  # depending on which message was received.
  def run_message(doc, turn)
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
