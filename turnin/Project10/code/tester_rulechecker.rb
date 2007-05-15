# !/arch/unix/bin/ruby

# Required Files
require 'code/administrator.rb'
require 'code/turn.rb'
require 'code/proxyplayer.rb'
require 'modules/dbc.rb'
require 'modules/rtparser.rb'

# Include for writing XML Messages
require 'rexml/document'
include REXML
          
# I/O 1: TESTER reads a _xtrn_ and a _hand_ 
# with all the necessary items for the 
# Administrator from standard input.
doc = Document.new
parser = RealTimeParser.new(STDIN, doc)
parser.parse
xtrn = Turn.xml_to_turn(doc)
deck = xtrn.deck
stack = xtrn.stack
table_discards = xtrn.list_of_squadrons

hand_doc = Document.new
parser = RealTimeParser.new(STDIN, hand_doc)
parser.parse
hand = Hand.xml_to_fsth(hand_doc)

# Create Proxy Player
player = ProxyPlayer.new("God")

# Give the player their first hand.
player.player_first_hand(hand.hand_to_list)

# Create Admin
admin = Administrator.new

# Run one turn, returns several results
begin
is_battle_over, return_card, list_of_discards, list_of_attacks, cardsfrom = admin.play_one_turn(player, deck, stack, table_discards)
rescue ContractViolation => msg
  result = Document.new
  contract = result.add_element "CONTRACT", {"msg"=>"#{msg}"}
  STDOUT.puts contract
  STDOUT.flush
  exit
rescue TimingError => msg
  timing = Document.new
  timing.add_element "TIMING", {"msg"=>"#{msg}"}
  STDOUT.puts timing
  STDOUT.flush
  exit
rescue Cheating => msg
  cheating = Document.new
  cheating.add_element "CHEATING", {"msg"=>"#{msg}"}
  STDOUT.puts cheating
  STDOUT.flush
  exit
end

# I/O 3: TESTER writes one of the following to standard output, then closes the port.
# -- a CONTRACT _resp_, if a contract is violated;
# -- a TIMING _resp_, if a timing contract is violated;
# -- a CHEATING _resp_, if a rule of the game is violated;
# -- or the following five XML elements if the turn worked out okay: 
#      bool  %% is this the end of the battle?
#      borc  %% the return card (or false)
#      slst  %% the discards 
#      from  %% did the player take the cards from the stack or the deck?
#      atta  %% (possibly empty) series of attacks

bool = XMLHelper.boolean_to_xml(is_battle_over)

borc = return_card.card_to_xml

if list_of_discards.size == 0
  slst = '<LIST />'
else
  slst = '<LIST>'
  list_of_discards.each{|x|
    slst = slst + x.squadron_to_xml
  }
  slst = slst + '</LIST>'
end

from = cardsfrom.cardsfrom_to_xml

if list_of_attacks.size == 0
  atta = '<ATTACKS />'
else
  atta = '<ATTACKS>'
  list_of_attacks.each(){|x|
    atta =  atta + x.attack_to_xml
  }
  atta = atta + '</ATTACKS>'
end

STDOUT << bool
STDOUT << borc
STDOUT << slst
STDOUT << from
STDOUT << atta
STDOUT.flush
