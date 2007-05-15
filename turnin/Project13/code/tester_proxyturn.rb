# !/arch/unix/bin/ruby
require 'code/player.rb'
require 'code/proxyturn.rb'
require 'modules/rtparser.rb'

# I/O 1: TESTER reads fsth and turn from standard input 
fsth = Document.new
parser = RealTimeParser.new(STDIN, fsth)
parser.parse
fsth = Hand.xml_to_fsth(fsth)

turn = Document.new
parser2 = RealTimeParser.new(STDIN, turn)
parser2.parse
t = ProxyTurn.xml_to_proxyturn(turn)

# Create new player
player = Player.new("God", false)

# Give player a ListOf-Card for his first Hand
player.player_first_hand(fsth.hand_to_list)

# I/O 4: TESTER writes done to standard output
done = player.player_take_turn(t)
result = done.done_to_xml

puts result
STDOUT.flush
