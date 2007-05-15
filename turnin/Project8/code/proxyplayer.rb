# !/arch/unix/bin/ruby

# proxyplayer.rb
# First included in Project 7
# This is an abstracted class of Player

# Required files
require 'code/player.rb'
require 'code/hand.rb'
require 'code/xmlhelper.rb'
require 'code/rtparser.rb'
require 'rexml/document'
include REXML

class ProxyPlayer < Player
  attr_accessor :hand
  def initialize(name)
    @name = name            # String
    @hand = Hand.create([]) # Hand
  end
  
  # player-take-turn  : Player Turn -> Done
  # grant this player a turn
  def player_take_turn(turn)
    mesg = Document.new
    mesg_parser = Parsers::RealTimeParser.new(STDIN, mesg)
    mesg_parser.parse

    if mesg.root.name = 'TURN-GET-CARDS-FROM-STACK'
      num = mesg.root.attributes['no'].to_i
      turn.turn_get_cards_from_stack(num)
    elsif mesg.root.name = 'TURN-GET-A-CARD-FROM-DECK'
      turn.turn_get_a_card_from_deck
    end

    done = Document.new
    done_parser = Parsers::RealTimeParser.new(STDIN, done)
    done_parser.parse
    
    XMLHelper.xml_to_done(done)
  end
end  
