# !/arch/unix/bin/ruby

# hand_tests.rb
# Tests all methods for hand.rb

# Required files
require 'test/unit'
require 'code/card.rb'
require 'code/hand.rb'
require 'code/squadron.rb'

class TestHand < Test::Unit::TestCase
	
	def setup
		# Necessary objects to build cards
		image = Image.new("filename.jpg")
		allies = Allies.new
		axis = Axis.new
		fighter = Fighter.new
		bomber = Bomber.new
		
		# Cards to be used for testing
		@air1 = Aircraft.new(Image.new("Baku Geki KI-99.gif"), "Baku Geki KI-99", axis, bomber, 1)
		@air2 = Aircraft.new(Image.new("Baku Geki KI-99.gif"), "Baku Geki KI-99", axis, bomber, 2)
		@air3 = Aircraft.new(Image.new("Baku Geki KI-99.gif"), "Baku Geki KI-99", axis, bomber, 3)
		@air4 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", allies, fighter, 1)
		@air5 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", allies, fighter, 2)
		@air6 = Aircraft.new(Image.new("Dornier Do 26.gif"), "Dornier Do 26", axis, bomber, 1)
		@air7 = Aircraft.new(Image.new("Dornier Do 26.gif"), "Dornier Do 26", axis, bomber, 2)
		@air8 = Aircraft.new(Image.new("Dornier Do 26.gif"), "Dornier Do 26", axis, bomber, 3)
		@keep1 = Keepem.new(Image.new("keepem.gif"), 1)
		@keep2 = Keepem.new(Image.new("keepem.gif"), 2)
		@keep3 = Keepem.new(Image.new("keepem.gif"), 3)
		@keep4 = Keepem.new(Image.new("keepem.gif"), 4)
		@keep5 = Keepem.new(Image.new("keepem.gif"), 5)
		@keep6 = Keepem.new(Image.new("keepem.gif"), 6)
		@vic1 = Victory.new(Image.new("victory.gif"))
		
		#General Hand to be used for testing
		@hand1 = Hand.create([@air1, @air2, @air3, @air4, @air5, @air6, @keep1])
		@hand2 = Hand.create([@keep1, @keep2, @keep3, @keep4, @keep5, @vic1, @keep6])
		@hand3 = Hand.create([@air1, @air2, @air3, @air4, @air5, @air6, @air7])
		@hand4 = Hand.create([@vic1])
		@hand5 = Hand.create([@air1, @keep2, @keep3, @keep4, @keep5, @vic1, @keep6])
		@hand6 = Hand.create([@air1, @air2, @air3, @air4, @air5, @air6, @air7, @air8, @keep1])
    end

    def test_equal?
		assert(@hand1.equal?(@hand1), "Hand.equal? failed")
		assert(!@hand1.equal?(@hand2), "Hand.equal? failed")
    end

    def test_comparable
		test_hand1 = Hand.create([@air1, @air2, @air3, @air4, @air5, @air6, @keep1])
        assert(@hand4 < @hand1)
        assert(@hand1 == @hand1)
        assert(@hand1 == test_hand1)
    end

    def test_create
		assert_instance_of(Hand, @hand1, "Hand.create failed")
        assert_same(@hand1, @hand1, "Hand.create failed")
		assert_not_same(@hand2, @hand1, "Hand.create failed")
    end

    def test_hand_to_list
        # Expected hand_to_list
        expected_hand1 = [@keep1, @air1, @air2, @air3, @air4, @air5, @air6]
		expected_hand2 = [@vic1, @keep1, @keep2, @keep3, @keep4, @keep5, @keep6]
		expected_hand3 = [@air1, @air2, @air3, @air4, @air5, @air6, @air7]
		expected_hand4 = [@vic1]
		expected_hand5 = [@vic1, @keep2, @keep3, @keep4, @keep5, @keep6, @air1]
        
        assert_instance_of(Array, @hand1.hand_to_list, "Hand.hand_to_list failed")
		assert_equal(expected_hand1, @hand1.hand_to_list, "Hand.hand_to_list failed")
        
        assert_instance_of(Array, @hand2.hand_to_list, "Hand.hand_to_list failed")
		assert_equal(expected_hand2, @hand2.hand_to_list, "Hand.hand_to_list failed")
        
        assert_instance_of(Array, @hand3.hand_to_list, "Hand.hand_to_list failed")
		assert_equal(expected_hand3, @hand3.hand_to_list, "Hand.hand_to_list failed")
        
        assert_instance_of(Array, @hand4.hand_to_list, "Hand.hand_to_list failed")
		assert_equal(expected_hand4, @hand4.hand_to_list, "Hand.hand_to_list failed")
        
        assert_instance_of(Array, @hand5.hand_to_list, "Hand.hand_to_list failed")
		assert_equal(expected_hand5, @hand5.hand_to_list, "Hand.hand_to_list failed")
    end

    def test_size
        assert_instance_of(Fixnum, @hand1.size, "Hand.size failed")
		assert_equal(7, @hand1.size, "Hand.size failed")
        
        assert_instance_of(Fixnum, @hand2.size, "Hand.size failed")
		assert_equal(7, @hand2.size, "Hand.size failed")
        
        assert_instance_of(Fixnum, @hand3.size, "Hand.size failed")
		assert_equal(7, @hand3.size, "Hand.size failed")
        
        assert_instance_of(Fixnum, @hand4.size, "Hand.size failed")
		assert_equal(1, @hand4.size, "Hand.size failed")
        
        assert_instance_of(Fixnum, @hand5.size, "Hand.size failed")
		assert_equal(7, @hand5.size, "Hand.size failed")
    end

    def test_value
        assert_instance_of(Fixnum, @hand1.value, "Hand.value failed")
		assert_equal(50, @hand1.value, "Hand.value failed")
		assert_not_equal(150, @hand1.value, "Hand.value failed")
        
        assert_instance_of(Fixnum, @hand2.value, "Hand.value failed")
		assert_equal(0, @hand2.value, "Hand.value failed")
		assert_not_equal(150, @hand2.value, "Hand.value failed")
        
        assert_instance_of(Fixnum, @hand3.value, "Hand.value failed")
		assert_equal(60, @hand3.value, "Hand.value failed")
		assert_not_equal(150, @hand3.value, "Hand.value failed")
        
        assert_instance_of(Fixnum, @hand4.value, "Hand.value failed")
		assert_equal(0, @hand4.value, "Hand.value failed")
		assert_not_equal(150, @hand4.value, "Hand.value failed")
        
        assert_instance_of(Fixnum, @hand5.value, "Hand.value failed")
		assert_equal(10, @hand5.value, "Hand.value failed")
		assert_not_equal(150, @hand5.value, "Hand.value failed")
    end

    def test_completes
		# Expected complete squadron from Hand.completes test		
		squad1 = Squadron.new([@air1, @air2, @air3])
		squad2 = Squadron.new([@air6, @air7, @air8])

        # Expected result of Hand.completes tests 
		complete_test_hand1 = [squad1]
        complete_test_hand2 = []
        complete_test_hand3 = [squad1]
        complete_test_hand4 = []
        complete_test_hand5 = []
        complete_test_hand6 = [squad1, squad2]

        assert_instance_of(Array, @hand1.completes, "Hand.completes failed")
		assert(complete_test_hand1 == @hand1.completes, "Hand.completes failed")
        
        assert_instance_of(Array, @hand2.completes, "Hand.completes failed")
		assert_equal(complete_test_hand2, @hand2.completes, "Hand.completes failed")
        
        assert_instance_of(Array, @hand3.completes, "Hand.completes failed")
		assert_equal(complete_test_hand3, @hand3.completes, "Hand.completes failed")
        
        assert_instance_of(Array, @hand4.completes, "Hand.completes failed")
		assert_equal(complete_test_hand4, @hand4.completes, "Hand.completes failed")
        
        assert_instance_of(Array, @hand5.completes, "Hand.completes failed")
		assert_equal(complete_test_hand5, @hand5.completes, "Hand.completes failed")
        
        assert_instance_of(Array, @hand6.completes, "Hand.completes failed")
		assert_equal(complete_test_hand6, @hand6.completes, "Hand.completes failed")
    end

    def test_wildcards
		# Expected result of Hand.wildcard test
		wildcards_test_hand1 = [@keep1]
        wildcards_test_hand2 = [@vic1, @keep1, @keep2, @keep3, @keep4, @keep5, @keep6]
        wildcards_test_hand3 = []
        wildcards_test_hand4 = [@vic1]
        wildcards_test_hand5 = [@vic1, @keep2, @keep3, @keep4, @keep5, @keep6]

        assert_instance_of(Array, @hand1.wildcards, "Hand.wildcards failed")
		assert_equal(wildcards_test_hand1, @hand1.wildcards, "Hand.wildcards failed")

        assert_instance_of(Array, @hand2.wildcards, "Hand.wildcards failed")
		assert_equal(wildcards_test_hand2, @hand2.wildcards, "Hand.wildcards failed")

        assert_instance_of(Array, @hand3.wildcards, "Hand.wildcards failed")
		assert_equal(wildcards_test_hand3, @hand3.wildcards, "Hand.wildcards failed")

        assert_instance_of(Array, @hand4.wildcards, "Hand.wildcards failed")
		assert_equal(wildcards_test_hand4, @hand4.wildcards, "Hand.wildcards failed")
    end

    def test_complementable
        complement_test_hand1 = [Squadron.new([@air4, @air5])]
        complement_test_hand2 = []
        complement_test_hand3 = [Squadron.new([@air4, @air5]), Squadron.new([@air6, @air7])]
        complement_test_hand4 = []
        complement_test_hand5 = []
        complement_test_hand6 = [Squadron.new([@air4, @air5])]
		
        assert_instance_of(Array, @hand1.complementable, "Hand.complementable failed")
        assert_equal(complement_test_hand1, @hand1.complementable, "Hand.complementable failed")
        
        assert_instance_of(Array, @hand2.complementable, "Hand.complementable failed")
		assert_equal(complement_test_hand2, @hand2.complementable, "Hand.complementable failed")
        
        assert_instance_of(Array, @hand3.complementable, "Hand.complementable failed")
        assert_equal(complement_test_hand3, @hand3.complementable, "Hand.complementable failed")
		
        assert_instance_of(Array, @hand4.complementable, "Hand.complementable failed")
		assert_equal(complement_test_hand4, @hand4.complementable, "Hand.complementable failed")
        
        assert_instance_of(Array, @hand5.complementable, "Hand.complementable failed")
		assert_equal(complement_test_hand5, @hand5.complementable, "Hand.complementable failed")
        
        assert_instance_of(Array, @hand6.complementable, "Hand.complementable failed")
		assert_equal(complement_test_hand6, @hand6.complementable, "Hand.complementable failed")
    end

    def test_plus
		# List of cards to be added in Hand.plus test
		plus_test_add_hand1 = [@vic1]
		plus_test_add_hand2 = [@air1, @air2]
		plus_test_add_hand3 = [@keep1, @keep2, @keep3]
		plus_test_add_hand4 = [@air1, @air2, @air3, @air4, @air5, @air6]
		plus_test_add_hand5 = [@air2, @air3]

		# Expected result of Hand.plus test
        plus_test_hand1 = Hand.new([@air1, @air2, @air3, @air4, @air5, @air6, @keep1, @vic1])
        plus_test_hand2 = Hand.new([@keep1, @keep2, @keep3, @keep4, @keep5, @vic1, @keep6, @air1, @air2])
        plus_test_hand3 = Hand.new([@air1, @air2, @air3, @air4, @air5, @air6, @air7, @keep1, @keep2, @keep3])
        plus_test_hand4 = Hand.new([@vic1, @air1, @air2, @air3, @air4, @air5, @air6])
        plus_test_hand5 = Hand.new([@air1, @keep2, @keep3, @keep4, @keep5, @vic1, @keep6, @air2, @air3])

        assert_instance_of(Hand, @hand1.plus(plus_test_add_hand1), "Hand.plus failed")
		assert_same(plus_test_hand1, @hand1.plus(plus_test_add_hand1), "Hand.plus failed")
        
        assert_instance_of(Hand, @hand2.plus(plus_test_add_hand2), "Hand.plus failed")
		assert_same(plus_test_hand2, @hand2.plus(plus_test_add_hand2), "Hand.plus failed")
        
        assert_instance_of(Hand, @hand3.plus(plus_test_add_hand3), "Hand.plus failed")
		assert_same(plus_test_hand3, @hand3.plus(plus_test_add_hand3), "Hand.plus failed")
        
        assert_instance_of(Hand, @hand4.plus(plus_test_add_hand4), "Hand.plus failed")
		assert_same(plus_test_hand4, @hand4.plus(plus_test_add_hand4), "Hand.plus failed")
        
        assert_instance_of(Hand, @hand5.plus(plus_test_add_hand5), "Hand.plus failed")
		assert_same(plus_test_hand5, @hand5.plus(plus_test_add_hand5), "Hand.plus failed")
    end

    def test_minus
		# List of cards to be deleted in Hand.minus test
		minus_test_delete_hand1 = [@air1]
		minus_test_delete_hand2 = [@keep6]
		minus_test_delete_hand3 = [@air1, @air7]
		minus_test_delete_hand4 = [@vic1]
		minus_test_delete_hand5 = [@keep4, @vic1]

		# Expected result of Hand.minus test
        minus_test_hand1 = Hand.new([@air2, @air3, @air4, @air5, @air6, @keep1])
        minus_test_hand2 = Hand.new([@keep1, @keep2, @keep3, @keep4, @keep5, @vic1])
        minus_test_hand3 = Hand.new([@air2, @air3, @air4, @air5, @air6])
        minus_test_hand4 = Hand.new([])
        minus_test_hand5 = Hand.new([@air1, @keep2, @keep3, @keep5, @keep6])
        
        assert_instance_of(Hand, @hand1.minus(minus_test_delete_hand1), "Hand.minus failed")
		assert_same(minus_test_hand1, @hand1.minus(minus_test_delete_hand1), "Hand.minus failed")
        
        assert_instance_of(Hand, @hand2.minus(minus_test_delete_hand2), "Hand.minus failed")
		assert_same(minus_test_hand2, @hand2.minus(minus_test_delete_hand2), "Hand.minus failed")
        
        assert_instance_of(Hand, @hand3.minus(minus_test_delete_hand3), "Hand.minus failed")
		assert_same(minus_test_hand3, @hand3.minus(minus_test_delete_hand3), "Hand.minus failed")
        
        assert_instance_of(Hand, @hand4.minus(minus_test_delete_hand4), "Hand.minus failed")
		assert_same(minus_test_hand4, @hand4.minus(minus_test_delete_hand4), "Hand.minus failed")
        
        assert_instance_of(Hand, @hand5.minus(minus_test_delete_hand5), "Hand.minus failed")
		assert_same(minus_test_hand5, @hand5.minus(minus_test_delete_hand5), "Hand.minus failed")
    end
end
