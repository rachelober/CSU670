# !/arch/unix/bin/ruby

# done_tests.rb
# Test cases for done.rb

# Required Files
require 'test/unit'
require 'code/done.rb'

class TestDone < Test::Unit::TestCase
    def setup
        allies = Allies.new
        axis = Axis.new
        fighter = Fighter.new
        bomber = Bomber.new

        @air1 = Aircraft.new(Image.new("Baku Geki KI-99.gif"), "Baku Geki KI-99", axis, bomber, 1)
        @air2 = Aircraft.new(Image.new("Baku Geki KI-99.gif"), "Baku Geki KI-99", axis, bomber, 2)
        @air3 = Aircraft.new(Image.new("Baku Geki KI-99.gif"), "Baku Geki KI-99", axis, bomber, 3)
        @air4 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", allies, fighter, 1)
        @air5 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", allies, fighter, 2)
        @air6 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", allies, fighter, 3)
        @air7 = Aircraft.new(Image.new("Dornier Do 26.gif"), "Dornier Do 26", axis, bomber, 1)
        @air8 = Aircraft.new(Image.new("Dornier Do 26.gif"), "Dornier Do 26", axis, bomber, 2)
        @air9 = Aircraft.new(Image.new("Dornier Do 26.gif"), "Dornier Do 26", axis, bomber, 3)
        @air10 = Aircraft.new(Image.new("Brewster F2A-3.gif"), "Brewster F2A-3", allies, fighter, 1)
        @air11 = Aircraft.new(Image.new("Brewster F2A-3.gif"), "Brewster F2A-3", allies, fighter, 2)
        @air12 = Aircraft.new(Image.new("Brewster F2A-3.gif"), "Brewster F2A-3", allies, fighter, 3)
        @keep1 = Keepem.new(Image.new("keepem.gif"), 1)
        @keep2 = Keepem.new(Image.new("keepem.gif"), 2)
        @keep3 = Keepem.new(Image.new("keepem.gif"), 3)
        @keep4 = Keepem.new(Image.new("keepem.gif"), 4)
        @keep5 = Keepem.new(Image.new("keepem.gif"), 5)
        @keep6 = Keepem.new(Image.new("keepem.gif"), 6)
        @vic1 = Victory.new(Image.new("victory.gif"))

        expected_attacks1 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))
        expected_attacks2 = Attack.new(Squadron.new([@air7, @air8, @air9]), Squadron.new([@air1, @air2, @air3]))
        expected_attacks3 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))

        @list_of_attacks1 = [expected_attacks1, expected_attacks2, expected_attacks3]
        @list_of_attacks2 = [expected_attacks3, expected_attacks1, expected_attacks2]
        @list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    end

    def test_Ret_equal?
        test_ret1 = Ret.new(@list_of_attacks1, @list_of_squads, @air1)
        test_ret2 = Ret.new(@list_of_attacks2, @list_of_squads, @air6)
        test_ret3 = Ret.new(@list_of_attacks1, @list_of_squads, @air1)

        assert_same(test_ret1, test_ret1, "Ret.equal? Failed")
        assert_not_same(test_ret2, test_ret1, "Ret.equal? Failed")
        assert_same(test_ret1, test_ret3, "Ret.equal? Failed")
    end

    def test_End_equal?
        test_end1 = End.new(@list_of_attacks1, @list_of_squads, @air1)
        test_end2 = End.new(@list_of_attacks2, @list_of_squads, @air6)
        test_end3 = End.new(@list_of_attacks1, @list_of_squads, @air1)
        test_ret = Ret.new(@list_of_attacks2, @list_of_squads, @air6)

        assert_same(test_end1, test_end1, "End.equal? Failed")
        assert_not_same(test_end2, test_end1, "End.equal? Failed")
        assert_same(test_end1, test_end3, "End.equal? Failed")
        assert_not_same(test_end2, test_ret, "End.equal? Failed")
    end

    def test_End_nilcard_equal?
        test_end1 = End.new(@list_of_attacks1, @list_of_squads, nil)
        test_end2 = End.new(@list_of_attacks2, @list_of_squads, nil)
        test_end3 = End.new(@list_of_attacks1, @list_of_squads, nil)
        test_ret = Ret.new(@list_of_attacks1, @list_of_squads, @keep1)

        assert_same(test_end1, test_end1, "End.equal? Failed")
        assert_not_same(test_end2, test_end1, "End.equal? Failed")
        assert_same(test_end1, test_end3, "End.equal? Failed")
        assert_not_same(test_end2, test_ret, "End.equal? Failed")
    end
end
