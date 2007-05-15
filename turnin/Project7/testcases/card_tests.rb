# !/arch/unix/bin/ruby

# card_tests.rb
# All tests for the Card class

# Required files
require 'test/unit'
require 'code/card.rb'

class TestCard < Test::Unit::TestCase
    def setup
		image = Image.new("filename.jpg")
		allies = Allies.new
		axis = Axis.new
		fighter = Fighter.new
		bomber = Bomber.new
		
		@air1 = Aircraft.new(image, "Baku Geki KI-99", axis, bomber, 1)
		@air2 = Aircraft.new(image, "Baku Geki KI-99", axis, bomber, 2)
		@air3 = Aircraft.new(image, "Baku Geki KI-99", axis, bomber, 3)
		@air4 = Aircraft.new(image, "Bell P-39D", allies, fighter, 1)
		@air5 = Aircraft.new(image, "Bell P-39D", allies, fighter, 2)
		@air6 = Aircraft.new(image, "Dornier Do 26", axis, bomber, 3)
		
        @keep1 = Keepem.new(image, 1)
		@keep2 = Keepem.new(image, 2)
		
        @vic1 = Victory.new(image)
		@vic2 = Victory.new(image)
    end
    
	def test_card_value
		assert_equal(10, @air1.card_value, "Card.card_value Failed")
		assert_not_equal(5, @air1.card_value, "Card.card_value Failed")
		
		assert_equal(5, @air4.card_value, "Card.card_value Failed")
		assert_not_equal(10, @air4.card_value, "Card.card_value Failed")
		
		assert_equal(0, @keep1.card_value, "Card.card_value Failed")
		assert_equal(0, @vic1.card_value, "Card.card_value Failed")
    end
	
    def test_card_less_than?
		assert(@air4.card_less_than?(@air1), "Card.card_less_than? Failed")
		assert_equal(false, @air1.card_less_than?(@air4), "Card.card_less_than? Failed")
		assert(@keep1.card_less_than?(@air1), "Card.card_less_than? Failed")
		assert_equal(false, @air1.card_less_than?(@keep1), "Card.card_less_than? Failed")
		assert_equal(false, @keep1.card_less_than?(@vic1), "Card.card_less_than? Failed")
		assert_equal(false, @vic1.card_less_than?(@keep1), "Card.card_less_than? Failed")
    end
		
	def test_cards_have_same_name?
		assert(@air1.cards_have_same_name?(@air2), "Card.cards_have_same_name? Failed")
		assert_equal(false, @air1.cards_have_same_name?(@air4), "Card.cards_have_same_name? Failed")
		assert_equal(false, @air1.cards_have_same_name?(@keep1), "Card.cards_have_same_name? Failed")
		assert_equal(false, @air1.cards_have_same_name?(@vic1), "Card.cards_have_same_name? Failed")
		
        assert(@keep1.cards_have_same_name?(@keep2), "Card.cards_have_same_name? Failed")
		assert_equal(false, @keep1.cards_have_same_name?(@vic1), "Card.cards_have_same_name? Failed")
		assert_equal(false, @keep1.cards_have_same_name?(@air1), "Card.cards_have_same_name? Failed")

		assert(@vic1.cards_have_same_name?(@vic2), "Card.cards_have_same_name? Failed")
		assert_equal(false, @vic1.cards_have_same_name?(@keep1), "Card.cards_have_same_name? Failed")
		assert_equal(false, @vic1.cards_have_same_name?(@air1), "Card.cards_have_same_name? Failed")
	end
end
