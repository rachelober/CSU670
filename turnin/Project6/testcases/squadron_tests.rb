# !/arch/unix/bin/ruby

# squadron_tests.rb
# Tests all methods from squadron.rb

# Required files
require 'test/unit'
require 'code/squadron.rb'
require 'code/card.rb'

class TestSquadron < Test::Unit::TestCase
	
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
		@air6 = Aircraft.new(image, "Bell P-39D", @allies, fighter, 3)
		@keep1 = Keepem.new(image, 1)
		@keep2 = Keepem.new(image, 2)
		@vic1 = Victory.new(image)
		
        @squad1 = Squadron.new([@air1, @air2, @air3])
		@squad2 = Squadron.new([@keep1, @air4, @air5])
		@squad3 = Squadron.new([@air1, @air2])
		@squad4 = Squadron.new([@air1, @air2, @keep1])
    end
        
    def test_equal? 
        assert(@squad1.equal?(@squad1), "Squadron.equal? failed")
		assert(!@squad1.equal?(@squad2), "Squadron.equal? failed")
    end
    
    def test_same_squad_list?
        squad_list1 = [@squad1, @squad2]
        squad_list2 = [@squad2, @squad3, @squad1]
        
        assert(Squadron.same_squad_list?([squad_list1], [squad_list1]), "Squadron.same_squad_list? failed")
        assert(!Squadron.same_squad_list?([squad_list1], [squad_list2]), "Squadron.same_squad_list? failed")
    end

    def test_squadron_first_aircraft
        assert_kind_of(Card, @squad1.squadron_first_aircraft, "Squadron.squadron_first_aircraft failed")
		assert_same(@air1, @squad1.squadron_first_aircraft, "Squadron.squadron_first_craft failed")
        assert_kind_of(Card, @squad2.squadron_first_aircraft, "Squadron.squadron_first_aircraft failed")
		assert_same(@air4, @squad2.squadron_first_aircraft, "Squadron.squadron_first_craft failed")
    end

    def test_squadron_alliance
		assert_equal(@allies, @squad2.squadron_alliance, "Squadron.squadron_alliance allies failed")
		assert_equal(@axis, @squad1.squadron_alliance, "Squadron.squadron_alliance axis failed")
		
        assert_not_equal(@allies, @squad1.squadron_alliance, "Squadron.squadron_alliance not allies failed")
		assert_not_equal(@axis, @squad2.squadron_alliance, "Squadron.squadron_alliance not axis failed")
    end

    def test_squadron_complete
        assert(@squad1.squadron_complete?, "Squadron.squadron_complete? true failed")
        assert(@squad2.squadron_complete?, "Squadron.squadron_complete? true failed")
		assert(!@squad3.squadron_complete?, "Squadron.squadron_complete? false failed")
    end

    def test_squadron_incomplete
		assert(!@squad1.squadron_incomplete?, "Squadron.squadron_incomplete? false failed")
		assert(!@squad2.squadron_incomplete?, "Squadron.squadron_incomplete? false failed")
		assert(@squad3.squadron_incomplete?, "Squadron.squadron_incomplete? true failed")
    end

    def test_squadron_fighter
		assert(!@squad1.squadron_fighter?, "Squadron.squadron_fighter? false failed")
        assert(@squad2.squadron_fighter?, "Squadron.squadron_fighter? true failed")
    end

    def test_squadron_bomber
		assert(@squad1.squadron_bomber?, "Squadron.squadron_bomber? true failed")
		assert(!@squad2.squadron_bomber?, "Squadron.squadron_bomber? false failed")
    end

    def test_squadron_value
		assert_equal(30, @squad1.squadron_value, "Squadron.squadron_value bomber failed")
		assert_equal(15, @squad2.squadron_value, "Squadron.squadron_value fighter failed")
    end

    def test_how_many_aircraft?
		assert_equal(3, @squad1.how_many_aircraft?, "Squadron..how_man_aircraft? failed")
		assert_equal(2, @squad2.how_many_aircraft?, "Squadron..how_man_aircraft? failed")
    end

    def test_add_card
        squad_test = Squadron.new([@air1, @air2])
        
		assert_same(Squadron.new([@air1, @air2, @keep1]), squad_test.add_card(@keep1), "Squadron.add_card failed")
    end
end
