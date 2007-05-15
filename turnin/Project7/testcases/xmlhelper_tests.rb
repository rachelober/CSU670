# !/arch/unix/bin/ruby

# xmlhelper_tests.rb
# Tests cases for XMLHelper.rb

# Required files
require 'test/unit'
require 'code/card.rb'
require 'code/deck.rb'
require 'code/stack.rb'
require 'code/hand.rb'
require 'code/squadron.rb'
require 'code/turn.rb'
require 'XMLHelper.rb'

class TestXMLHelper < Test::Unit::TestCase
        def setup
                image = Image.new("filename.jpg")
                @allies = Allies.new
                @axis = Axis.new
                fighter = Fighter.new
                bomber = Bomber.new

                @air1 = Aircraft.new(image, "Baku Geki KI-99", @axis, bomber, 1)
                @air2 = Aircraft.new(image, "Baku Geki KI-99", @axis, bomber, 2)
                @air3 = Aircraft.new(image, "Baku Geki KI-99", @axis, bomber, 3)
                @air4 = Aircraft.new(image, "Bell P-39D", @allies, fighter, 1)
                @air5 = Aircraft.new(image, "Bell P-39D", @allies, fighter, 2)
                @air6 = Aircraft.new(image, "Dornier Do 26", @axis, bomber, 1)
                @keep1 = Keepem.new(image, 1)
                @keep2 = Keepem.new(image, 2)
                @vic1 = Victory.new(image)

                # Game Deck for building Turns
                @deck = Deck.create

                # Stack used to create a turn
                @stack = Stack.new([@air6, @keep2, @vic1])

                # Squadron to be used to build a Turn's list_of_squads
                @list_of_squads = [Squadron.new([@air1, @air2, @air3])]

                # Generic turn for method testing
                @turn = Turn.new(@deck, @stack, @list_of_squads)
        end

        def test_xml_to_card
                assert_same(@air1, XMLHelper.xml_to_card('<AIRCRAFT NAME="Baku Geki KI-99" TAG="1 />'))
        end
end
