# !/arch/unix/bin/ruby

# cardsfrom_tests.rb
# Tests cases for cardsfrom.rb

# Required files
require 'test/unit'
require 'code/cardsfrom.rb'

class TestCardsFrom < Test::Unit::TestCase
    def setup
        @allies = Allies.new
        @axis = Axis.new
        fighter = Fighter.new
        bomber = Bomber.new
        @air1 = Aircraft.new(Image.new("Baku Geki KI-99.gif"), "Baku Geki KI-99", @axis, bomber, 1)
        @air2 = Aircraft.new(Image.new("Baku Geki KI-99.gif"), "Baku Geki KI-99", @axis, bomber, 2)
        @air3 = Aircraft.new(Image.new("Baku Geki KI-99.gif"), "Baku Geki KI-99", @axis, bomber, 3)
        @air4 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", @allies, fighter, 1)
        @air5 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", @allies, fighter, 2)
        @air6 = Aircraft.new(Image.new("Dornier Do 26.gif"), "Dornier Do 26", @axis, bomber, 1)
        @keep1 = Keepem.new(Image.new("keepem.gif"), 1)
        @keep2 = Keepem.new(Image.new("keepem.gif"), 2)
        @vic1 = Victory.new(Image.new("victory.gif"))
    end
    
    def test_CardsFrom_equal?
        from_deck = FromDeck.new
        from_stack = FromStack.new(3)
        assert_same(from_deck, from_deck, "CardsFrom.equal? failed")
        assert_not_same(from_deck, from_stack, "CardsFrom.equal? failed")
        assert_same(from_stack, from_stack, "CardsFrom.equal? failed")
        assert_not_same(from_stack, from_deck, "CardsFrom.equal? failed")
    end
end
