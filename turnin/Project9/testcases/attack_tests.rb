# !/arch/unix/bin/ruby

# attack_tests.rb
# Test cases for attack.rb

# Required Files
require 'test/unit'
require 'code/attack.rb'

class TestAttack < Test::Unit::TestCase
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
    end

    def test_equal?
        expected_attacks1 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))
        expected_attacks2 = Attack.new(Squadron.new([@air7, @air8, @air9]), Squadron.new([@air1, @air2, @air3]))
        expected_attacks3 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))

        assert(expected_attacks1.equal?(expected_attacks1), "Attack.equal? failed")
        assert(!expected_attacks1.equal?(expected_attacks2), "Attack.equal? failed")
        assert(expected_attacks1.equal?(expected_attacks3), "Attack.equal? failed")
    end

    def test_attack_lists
        attack1 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))
        attack2 = Attack.new(Squadron.new([@air7, @air8, @air9]), Squadron.new([@air1, @air2, @air3]))
        attack3 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))

        attack_list1 = [attack1, attack2]
        attack_list2 = [attack2, attack1]
        attack_list3 = [attack3, attack2]

        assert_equal(attack_list1, attack_list1, "Attack.same_attack_list? failed")
        assert_equal(attack_list1, attack_list3, "Attack.same_attack_list? failed")
        assert_not_equal(attack_list1, attack_list2, "Attack.same_attack_list? failed")
        assert_not_equal(attack_list2, attack_list1, "Attack.same_attack_list? failed")
    end
end
