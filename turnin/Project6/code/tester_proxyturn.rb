# !/arch/unix/bin/ruby

require 'code/player.rb'
require 'code/proxyturn.rb'

# I/O 1: TESTER reads fsth and turn from standard input 
doc = Document.new
parser = Parsers::RealTimeParser.new(STDIN, doc)
parser.parse
fsth = XMLHelper.xml_to_fsth(doc)

doc2 = Document.new
parser2 = Parsers::RealTimeParser.new(STDIN, doc2)
parser2.parse
is_card_on_deck, stack, list_of_squads = XMLHelper.xml_to_turn(doc2)

# Create new player
player = Player.new("God")

# Give player a Hand of Cards
player.player_first_hand(fsth)

# Create ProxyTurn
t = ProxyTurn.new(is_card_on_deck, stack, list_of_squads)

# I/O 4: TESTER writes done to standard output
done = player.player_take_turn(t)
result = XMLHelper.done_to_xml(done)

STDOUT << result
STDOUT.flush
