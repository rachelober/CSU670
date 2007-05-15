# !/arch/unix/bin/ruby

# administrator_tests.rb
# Tests all methods from administrator.rb

# Required files
require 'test/unit'
require 'code/administrator.rb'
require 'code/cheatadmin.rb'
require 'code/battle.rb'
require 'code/war.rb'

class TestAdministrator < Test::Unit::TestCase

  # Stucture used in Admin to track Player information
  PlayerState = Struct.new( "PlayerState", :name, :hand, :score, :status )
  
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
    @air6 = Aircraft.new(image, "Bell P-39D", allies, fighter, 3)
    @air7 = Aircraft.new(image, "Dornier Do 26", axis, bomber, 1)
    @air8 = Aircraft.new(image, "Dornier Do 26", axis, bomber, 2)
    @air9 = Aircraft.new(image, "Dornier Do 26", axis, bomber, 3)
    @air10 = Aircraft.new(image, "Brewster F2A-3", allies, fighter, 1)
    @air11 = Aircraft.new(image, "Brewster F2A-3", allies, fighter, 2)
    @air12 = Aircraft.new(image, "Brewster F2A-3", allies, fighter, 3)
    @air13 = Aircraft.new(Image.new("Messerschmitt ME-109"), "Messerschmitt ME-109", axis, fighter, 1)
    @air14 = Aircraft.new(Image.new("Messerschmitt ME-109"), "Messerschmitt ME-109", axis, fighter, 2)
    @air15 = Aircraft.new(Image.new("Messerschmitt ME-109"), "Messerschmitt ME-109", axis, fighter, 3)
    @keep1 = Keepem.new(image, 1)
    @keep2 = Keepem.new(image, 2)
    @keep3 = Keepem.new(image, 3)
    @keep4 = Keepem.new(image, 4)
    @keep5 = Keepem.new(image, 5)
    @keep6 = Keepem.new(image, 6)
    @vic1 = Victory.new(image)

    @player = Player.create("Venus", false)
    @playerstate = PlayerState.new("Venus", Hand.new([@vic1]), 0, true)
    @admin = Administrator.new
    @battle = Battle.new([@player], [@playerstate])
    @cheatadmin = CheatAdmin.new([@playerstate])
  end

  def test_initialize
    assert_equal(true, Administrator.new.instance_of?(Administrator), 
    "Administrator initializes to a different type")
  end
 
  def test_register_player
    player1 = Player.create("God", false)
    player2 = Player.create("Budda", false)
    player3 = Player.create("Moses", false)

    assert_equal([player1], @admin.register_player(player1), 
      "First Player didn't register correctly")
    assert_equal([player1, player2], @admin.register_player(player2),
      "Second player didn't register correctly")
  end
  
  def test_play_one_turn_1
    player = Player.create("God", false)
    hand = player.player_first_hand([@air4, @air5, @air6, @air10, @air11, @keep1])
    deck = Deck.list_to_deck([@vic1])
    stack = Stack.new([@vic1])
    list_of_discards = [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air7, @air8, @keep3])]
    playerstate = PlayerState.new("God", hand, 0, true)
    battle = Battle.new([player], [playerstate])

    is_battle_over, return_card, our_discards, list_of_attacks, from_where = 
    battle.play_one_turn(player, deck, stack, list_of_discards)

    assert(is_battle_over, "play_one_turn is_battle_over failed")
    assert_same(@keep1, return_card, "play_one_turn return_card failed")
    assert_equal([], our_discards, "play_one_turn our_discards failed")
    assert_equal(
      [Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3])),
      Attack.new(Squadron.new([@air10, @air11, @vic1]), Squadron.new([@air7, @air8, @keep3]))],
      list_of_attacks, "play_one_turn list_of_attacks failed")
    assert_kind_of(CardsFrom, from_where, "play_one_turn from_where failed")

  end

  def test_play_one_turn_2
    player = Player.create("Moses", false)
    hand = player.player_first_hand([@air1, @air2, @air3, @air7, @air8, @air9])
    deck = Deck.list_to_deck([@vic1])
    stack = Stack.new([@vic1])
    list_of_discards = [Squadron.new([@air4, @air5, @air6]), Squadron.new([@air10, @air11, @keep3])]
    playerstate = PlayerState.new("Moses", hand, 0, true)
    battle = Battle.new([player], [playerstate])
    
    is_battle_over, return_card, our_discards, list_of_attacks, from_where =
    battle.play_one_turn(player, deck, stack, list_of_discards)

    assert(is_battle_over, "play_one_turn is_battle_over failed")
    assert_same(@vic1, return_card, "play_one_turn return_card failed")
    assert_equal([Squadron.new([@air1, @air2, @air3]), 
      Squadron.new([@air7, @air8, @air9])],
      our_discards, 
      "play_one_turn our_discards failed")
    assert_equal([], list_of_attacks, "play_one_turn list_of_attacks failed")
    assert_kind_of(CardsFrom, from_where, "play_one_turn from_where failed")
  end

  def test_play_one_turn_3
    player = Player.create("Budda", false)
    hand = player.player_first_hand([@air1, @air2, @air3, @air7, @air8, @air9, @air12])   
    deck = Deck.list_to_deck([@vic1, @air12, @keep4, @keep5, @keep6])
    stack = Stack.new([@vic1])
    list_of_discards = [Squadron.new([@air4, @air5, @air6]), Squadron.new([@air10, @air11, @keep3])]
    playerstate = PlayerState.new("Budda", hand, 0, true)
    battle = Battle.new([player], [playerstate])
    
    is_battle_over, return_card, our_discards, list_of_attacks, from_where =
    battle.play_one_turn(player, deck, stack, list_of_discards)
    
    assert(!is_battle_over, "play_one_turn is_battle_over failed")
    if return_card.instance_of?(Aircraft)
      assert_same(@air12, return_card, "play_one_turn return_card failed")
    elsif return_card.instance_of?(Victory)
      assert_same(@vic1, return_card, "play_one_turn return_card failed")
    end
    assert_equal([Squadron.new([@air1, @air2, @air3]), 
      Squadron.new([@air7, @air8, @air9])],
      our_discards,
      "play_one_turn our_discards failed")
    assert_equal([], list_of_attacks, "play_one_turn list_of_attacks failed")
    assert_kind_of(CardsFrom, from_where, "play_one_turn from_where failed")
  end

  def test_check_discards_in_hand?
    player = Player.create("Zeus", false)
    hand = player.player_first_hand([@air1, @air2, @air3, @air4, @air5, @air7, @air8, @keep1])
    playerstate = PlayerState.new("Zeus", hand, 0, true)
    cheatadmin = CheatAdmin.new([playerstate])
    done1 = Ret.new([], [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @keep1])], @air7)
    done2 = End.new([], 
      [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @keep1]), 
      Squadron.new([@air7, @air8, @air9])], false)
   
    assert_equal(true, cheatadmin.check_discards_in_hand?(player, done1))
    assert_raise Cheating do
      cheatadmin.check_discards_in_hand?(player, done2)
    end
  end

  def test_check_only_play_once?
    player = Player.create("Zeus", false)
    player.player_first_hand([@air1, @air2, @air3, @air4, @air5, @air7, @air8, @keep1])
    done1 = Ret.new([], [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @keep1])], @air7)
    done2 = End.new([], 
      [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @keep1]), 
      Squadron.new([@air7, @air8, @air8])], false)
   
    assert_equal(true, @cheatadmin.check_only_play_once?(player, done1))
    assert_raise Cheating do
      @cheatadmin.check_only_play_once?(player, done2)
    end
  end

  def test_check_valid_squadrons?
    # Valid Discards
    done1 = Ret.new([], 
      [Squadron.new([@air1, @air2, @air3]), 
      Squadron.new([@air4, @air5, @keep1])], @air7)
    # One all WildCards
    done2 = End.new([], 
      [Squadron.new([@air1, @air2, @air3]), 
      Squadron.new([@air4, @air5, @keep1]), 
      Squadron.new([@keep2, @keep3, @keep4])], false)
    # One with differend Aircraft types
    done3 = Ret.new([], 
      [Squadron.new([@air1, @air2, @air9]), 
      Squadron.new([@air4, @air5, @keep1])], @air7)
    # One with only 2 cards
    done4 = End.new([], 
      [Squadron.new([@air1, @air2]), 
      Squadron.new([@air4, @air5, @keep1]), 
      Squadron.new([@air7, @air8, @air9])], false)
    
    assert_equal(true, @cheatadmin.check_valid_squadrons?(done1))
    assert_raise Cheating do
      @cheatadmin.check_valid_squadrons?(done2)
    end
    assert_raise Cheating do
      @cheatadmin.check_valid_squadrons?(done3)
    end
    assert_raise Cheating do
      @cheatadmin.check_valid_squadrons?(done4)
    end
  end

  def test_check_valid_attacks?
    attack1 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))
    attack2 = Attack.new(Squadron.new([@air10, @air11, @air12]), Squadron.new([@air1, @air2, @air3]))
    attack3 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air7, @air8, @air9]))
    # Reversed Fighter and Bomber
    attack4 = Attack.new(Squadron.new([@air1, @air2, @air4]), Squadron.new([@air4, @air5, @air6]))
    # Same alliance
    attack5 = Attack.new(Squadron.new([@air13, @air14, @air15]), Squadron.new([@air1, @air2, @air3]))
    
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    list_of_attacks1 = [attack1, attack2, attack3]
    list_of_attacks2 = [attack3, attack1, attack2]
    list_of_attacks3 = [attack4, attack2, attack3]
    list_of_attacks4 = [attack2, attack1, attack5]
    
    done1 = Ret.new(list_of_attacks1, list_of_squads, @air7)
    done2 = End.new(list_of_attacks2, list_of_squads, false)
    done3 = Ret.new(list_of_attacks3, list_of_squads, @air7)
    done4 = End.new(list_of_attacks4, list_of_squads, false)

    assert_equal(true, @cheatadmin.check_valid_attacks?(done1))
    assert_equal(true, @cheatadmin.check_valid_attacks?(done2))
    assert_raise Cheating do
      @cheatadmin.check_valid_attacks?(done3)
    end
    assert_raise Cheating do
      @cheatadmin.check_valid_attacks?(done4)
    end
  end

  def test_run_battle
    god_player = Player.create("God", false)
    god_hand = god_player.player_first_hand([@air4, @air5, @air6, @air10, @air11, @keep1])
    god_state = PlayerState.new("God", god_hand, 0, true)
    budda_player = Player.create("Budda", false)
    budda_hand = budda_player.player_first_hand([@air1, @air2, @air3, @air7, @air8, @air9, @air12])   
    budda_state = PlayerState.new("Budda", budda_hand, 0, true)
    moses_player = Player.create("Moses", false)
    moses_hand = moses_player.player_first_hand([@air1, @air2, @air3, @air7, @air8, @air9])
    moses_state = PlayerState.new("Moses", moses_hand, 0, true)

    battle = Battle.new([god_player, budda_player, moses_player],
      [god_state, budda_state, moses_state])

    #battle.run_battle
    
  end
 
  def test_run_war
    god_player = Player.create("God", false)
    god_hand = god_player.player_first_hand([@air4, @air5, @air6, @air10, @air11, @keep1])
    god_state = PlayerState.new("God", god_hand, 0, true)
    budda_player = Player.create("Budda", false)
    budda_hand = budda_player.player_first_hand([@air1, @air2, @air3, @air7, @air8, @air9, @air12])   
    budda_state = PlayerState.new("Budda", budda_hand, 0, true)
    moses_player = Player.create("Moses", false)
    moses_hand = moses_player.player_first_hand([@air1, @air2, @air3, @air7, @air8, @air9])
    moses_state = PlayerState.new("Moses", moses_hand, 0, true)

    war = War.new([god_player, budda_player, moses_player],
      [god_state, budda_state, moses_state])

    war.run_war
  end    
end
