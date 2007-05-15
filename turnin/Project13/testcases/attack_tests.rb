# !/arch/unix/bin/ruby

# attack_tests.rb
# Test cases for attack.rb

# Required Files
require 'test/unit'
require 'code/attack.rb'
require 'code/squadron.rb'

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
    @air13 = Aircraft.new(Image.new("Curtiss P-40E.jpg"), "Curtiss P-40E", allies, fighter, 1)
    @air14 = Aircraft.new(Image.new("Curtiss P-40E.jpg"), "Curtiss P-40E", allies, fighter, 2)
    @air15 = Aircraft.new(Image.new("Curtiss P-40E.jpg"), "Curtiss P-40E", allies, fighter, 3)
    @air16 = Aircraft.new(Image.new("Messerschmitt ME-109"), "Messerschmitt ME-109", axis, fighter, 1)
    @air17 = Aircraft.new(Image.new("Messerschmitt ME-109"), "Messerschmitt ME-109", axis, fighter, 2)
    @air18 = Aircraft.new(Image.new("Messerschmitt ME-109"), "Messerschmitt ME-109", axis, fighter, 3)
    @air19 = Aircraft.new(Image.new("Vickers Wellington"), "Vickers Wellington", allies, bomber, 1)
    @air20 = Aircraft.new(Image.new("Vickers Wellington"), "Vickers Wellington", allies, bomber, 2)
    @air21 = Aircraft.new(Image.new("Vickers Wellington"), "Vickers Wellington", allies, bomber, 3)
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
    expected_attacks2 = Attack.new(Squadron.new([@air10, @air11, @air12]), Squadron.new([@air1, @air2, @air3]))
    expected_attacks3 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))

    assert(expected_attacks1.equal?(expected_attacks1), "Attack.equal? failed")
    assert(!expected_attacks1.equal?(expected_attacks2), "Attack.equal? failed")
    assert(expected_attacks1.equal?(expected_attacks3), "Attack.equal? failed")
  end

  def test_attack_lists
    attack1 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))
    attack2 = Attack.new(Squadron.new([@air10, @air11, @air12]), Squadron.new([@air1, @air2, @air3]))
    attack3 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))

    attack_list1 = [attack1, attack2]
    attack_list2 = [attack2, attack1]
    attack_list3 = [attack3, attack2]

    assert_equal(attack_list1, attack_list1, "Attack.same_attack_list? failed")
    assert_equal(attack_list1, attack_list3, "Attack.same_attack_list? failed")
    assert_not_equal(attack_list1, attack_list2, "Attack.same_attack_list? failed")
    assert_not_equal(attack_list2, attack_list1, "Attack.same_attack_list? failed")
  end

  def test_attack_to_xml
    document = Document.new
    attack = document.add_element "ATTACK"
    fighter = attack.add_element "SQUADRON"
    fighter.add_element "VICTORY"
    fighter.add_element "AIRCRAFT", {"NAME"=>"Curtiss P-40E", "TAG"=>"2"}
    fighter.add_element "AIRCRAFT", {"NAME"=>"Curtiss P-40E", "TAG"=>"3"}
    bomber = attack.add_element "SQUADRON"
    bomber.add_element "KEEPEM", {"TAG"=>"1"}
    bomber.add_element "AIRCRAFT", {"NAME"=>"Dornier Do 26", "TAG"=>"2"}
    bomber.add_element "AIRCRAFT", {"NAME"=>"Dornier Do 26", "TAG"=>"3"}

    norm = Attack.new(Squadron.new([@vic1, @air14, @air15]), Squadron.new([@air8, @keep1, @air9]))

    assert_equal(document.to_s, norm.attack_to_xml.to_s)
  end

  def test_fail_contract
    assert_raise ContractViolation do
      attack = Attack.new(Squadron.new([@air8, @keep1, @air9]), Squadron.new([@vic1, @air14, @air15]))
    end
  end
end
