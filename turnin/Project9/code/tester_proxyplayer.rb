# !/arch/unix/bin/ruby

require 'code/administrator.rb'
require 'code/turn.rb'
require 'code/proxyplayer.rb'
require 'modules/dbc.rb'
require 'modules/rtparser.rb'
# I/O 1: TESTER reads a _xtrn_ with all the necessary items
doc = Document.new
parser = Parsers::RealTimeParser.new(STDIN, doc)
parser.parse
xtrn = XMLHelper.xml_to_xturn(doc)
deck = xtrn.deck
stack = xtrn.stack
table_discards = xtrn.list_of_squads
# Create Proxy Player
player = ProxyPlayer.new("God")

# Create Admin
admin = Administrator.new

# Run one turn, returns several results
is_battle_over, return_card, list_of_discards, list_of_attacks, cardsfrom = admin.play_one_turn(player, deck, stack, table_discards)

# I/O 3: TESTER writes to 
#          bool  %% is this the end of the battle?
#          borc  %% the return card (or false)
#          slst  %% the discards 
#          from  %% did the player take the cards from the stack or the deck?
#          atta  %% (possibly empty) series of attacks
#        to standard output, then closes the port.

bool = XMLHelper.boolean_to_xml(is_battle_over)

borc = XMLHelper.card_to_xml(return_card)

if list_of_discards.size == 0
    slst = '<LIST />'
else
    slst = '<LIST>'
    list_of_discards.each{|x|
        slst = slst + XMLHelper.squadron_to_xml(x)
    }
    slst = slst + '</LIST>'
end

from = XMLHelper.cardsfrom_to_xml(cardsfrom)

if list_of_attacks.size == 0
    atta = '<ATTACKS />'
else
    atta = '<ATTACKS>'
    list_of_attacks.each(){|x|
        atta =  atta + XMLHelper.attack_to_xml(x)
    }
    atta = atta + '</ATTACKS>'
end

STDOUT << bool
STDOUT << borc
STDOUT << slst
STDOUT << from
STDOUT << atta
STDOUT.flush
