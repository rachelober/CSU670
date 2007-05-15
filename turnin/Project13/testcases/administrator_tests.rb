# !/arch/unix/bin/ruby

# administrator_tests.rb
# Tests all methods from administrator.rb

# Required files
require 'test/unit'
require 'code/administrator.rb'

class TestAdministrator < Test::Unit::TestCase
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
    @air13 = Aircraft.new(Image.new("Messerschmitt ME-109.gif"), "Messerschmitt ME-109", axis, fighter, 1)
    @air14 = Aircraft.new(Image.new("Messerschmitt ME-109.gif"), "Messerschmitt ME-109", axis, fighter, 2)
    @air15 = Aircraft.new(Image.new("Messerschmitt ME-109.gif"), "Messerschmitt ME-109", axis, fighter, 3)
    @keep1 = Keepem.new(Image.new("keepem.gif"), 1)
    @keep2 = Keepem.new(Image.new("keepem.gif"), 2)
    @keep3 = Keepem.new(Image.new("keepem.gif"), 3)
    @keep4 = Keepem.new(Image.new("keepem.gif"), 4)
    @keep5 = Keepem.new(Image.new("keepem.gif"), 5)
    @keep6 = Keepem.new(Image.new("keepem.gif"), 6)
    @vic1 = Victory.new(Image.new("victory.gif"))
  
    @player = Player.create("Venus", false)
    @playerstate = PlayerState.new("Venus", Hand.new([@vic1]), 0, true)
    @admin = Administrator.new
    @battle = Battle.new([@player], [@playerstate], [])
    @cheatadmin = CheatAdmin.new([@playerstate])
  end

  def test_initialize
    assert_equal(true, Administrator.new.instance_of?(Administrator), 
    "Administrator initializes to a different type")
  end
 
  def test_register_player
    player1 = Player.create("God", false)
    player2 = Player.create("Budda", false)
    player3 = Player.create("Budda", false)

    assert_equal(true, @admin.register_player(player1), 
      "First Player didn't register correctly")
    assert_equal(true, @admin.register_player(player2),
      "Second player didn't register correctly")
    assert_equal(false, @admin.register_player(player3))
  end
end
