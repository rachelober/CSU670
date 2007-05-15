# !/arch/unix/bin/ruby

# testcaseadmin.rb
# This code tests ProxyPlayer and ProxyTurn by reading xml test cases.

# Required files
require 'modules/rtparser.rb'
require 'code/xmlhelper.rb'
require 'rexml/document'
include REXML
require 'code/proxyturn.rb'
require 'code/proxyplayer.rb'
require 'testcases/proxyturn_tests.rb'
require 'testcases/proxyplayer_tests.rb'

test_case = Document.new
parser = Parsers::RealTimeParser.new(STDIN, test_case)
parser.parse

fsth, turn, ex_done = XMLHelper.parse_test_case(test_case)
pipe = IO.popen("ruby code/tester_proxyturn.rb", "r+") do |io|
    io.write(fsth)
    io.write(turn)

    cardsfrom = Document.new
    io.lineno
    cardsfrom_parser = Parsers::RealTimeParser.new(io.read, cardsfrom)
    puts "2"
    if cardsfrom.root.name == "TURN-GET-CARDS-FROM-STACK"
        puts "okay"
        pipe.write("<OKAY />")
    elsif cardsfrom.root.name == "TURN-GET-A-CARD-FROM-DECK"
        puts "victory"
        pipe.write("<VICTORY />")
    end

   done = Document.new
   done_parser = Parsers::RealTimeParser.new(io.read, done)
end

done = XMLHelper.xml_to_done(done)
STDOUT << done
STDOUT.flush
