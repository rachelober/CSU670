# !/arch/unix/bin/ruby

# testcaseadmin.rb
# This code tests ProxyPlayer and ProxyTurn by reading xml test cases.

# Required files
require 'modules/rtparser.rb'
require 'code/xmlhelper.rb'
require 'code/proxyturn.rb'
require 'code/done.rb'
require 'test/unit'
require 'rexml/document'
include REXML

class TestCaseAdmin < Test::Unit::TestCase
  test_case = Document.new
  parser = RealTimeParser.new(STDIN, test_case)
  parser.parse

  fsth, turn, ex_done = XMLHelper.parse_test_case(test_case)

  # Figure out what the expected done is
  ex_done = Document.new ex_done
  ex_done = Done.xml_to_done(ex_done)
  card = ex_done.card
  if !card.nil?
    card = Document.new card.card_to_xml
  end

  pipe = IO.popen("ruby code/tester_ruletester.rb", "w+") do |io|
    io.puts fsth
    io.flush
    io.puts turn
    io.flush

    parsed = io.gets
    cardsfrom = Document.new
    cardsfrom_parser = RealTimeParser.new(parsed, cardsfrom)
    cardsfrom_parser.parse
  
    if cardsfrom.root.name == "TURN-GET-CARDS-FROM-STACK"
      io.puts "<OKAY />"
    elsif cardsfrom.root.name == "TURN-GET-A-CARD-FROM-DECK"
      io.puts card
    end
    io.flush

    parsed2 = io.gets
    done = Document.new
    done_parser = RealTimeParser.new(parsed2, done)
    done_parser.parse
  
    done_result = Done.xml_to_done(done)
    assert_same(ex_done, done_result)
  end
end
