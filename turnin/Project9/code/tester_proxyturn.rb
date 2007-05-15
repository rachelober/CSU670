# !/arch/unix/bin/ruby

require 'code/player.rb'
require 'code/proxyturn.rb'

# I/O 1: TESTER reads fsth and turn from standard input 
fsth = Document.new
parser = Parsers::RealTimeParser.new(STDIN, fsth)
parser.parse
fsth = XMLHelper.xml_to_fsth(fsth)
turn = Document.new
parser2 = Parsers::RealTimeParser.new(STDIN, turn)
parser2.parse
is_card_on_deck, stack, list_of_squads = XMLHelper.xml_to_pturn(turn)

# Create new player
player = Player.new("God", false)

# Give player a Hand of Cards
player.player_first_hand(fsth.hand_to_list)

# Create ProxyTurn
t = ProxyTurn.new(is_card_on_deck, stack, list_of_squads)

# I/O 4: TESTER writes done to standard output
done = player.player_take_turn(t)
result = XMLHelper.done_to_xml(done)

STDOUT << result
STDOUT.flush
