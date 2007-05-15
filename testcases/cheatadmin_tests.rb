# !/arch/unix/bin/ruby

# cheatadmin_tests.rb
# Tests all methods from cheatadmin.rb

# Required files
require 'test/unit'
require 'code/cheatadmin.rb'

class TestCheatAdmin < Test::Unit::TestCase
  
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
    @cheatadmin = CheatAdmin.new([@playerstate])
  end

  def test_check_valid_tags?
    assert_raise Cheating do
      @cheatadmin.check_valid_tags?(Aircraft.new(Image.new("Baku Geki KI-99.gif"), 
      "Baku Geki KI-99", Axis.new, Bomber.new, -1))
    end

    assert_raise Cheating do
      @cheatadmin.check_valid_tags?(Aircraft.new(Image.new("Baku Geki KI-99.gif"), 
      "Baku Geki KI-99", Axis.new, Bomber.new, 6))
    end

    assert_raise Cheating do
      @cheatadmin.check_valid_tags?(Keepem.new(Image.new("keepem.gif"), -1))
    end

    assert_raise Cheating do
      @cheatadmin.check_valid_tags?(Keepem.new(Image.new("keepem.gif"), 7))
    end
  end

  def test_check_battle_really_over_true
    player = Player.create("Zeus", false)
    hand = player.player_first_hand([@air4, @air5, @keep1])
    playerstate = PlayerState.new("Zeus", hand, 0, true)
    cheatadmin = CheatAdmin.new([playerstate])

    deck = Deck.list_to_deck([@air9])
    stack = Stack.create(@air9)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    turn = Turn.new(deck, stack, list_of_squads)    
    
    done = End.new([], [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @keep1])], @air9)
  
    player.player_take_turn(turn)

    assert_equal(true, cheatadmin.check_battle_really_over?(player, turn, done))
  end

  def test_check_battle_really_over_false
    player = Player.create("Zeus", false)
    hand = player.player_first_hand([@air4, @air5, @keep1, @air6])
    playerstate = PlayerState.new("Zeus", hand, 0, true)
    cheatadmin = CheatAdmin.new([playerstate])

    deck = Deck.list_to_deck([@air9])
    stack = Stack.create(@air9)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    turn = Turn.new(deck, stack, list_of_squads)    
    
    done = End.new([], [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @keep1])], @air9)
  
    player.player_take_turn(turn)
    
    assert_raise Cheating do
      cheatadmin.check_battle_really_over?(player, turn, done)
    end
  end

  def test_check_discards_in_hand_true
    player = Player.create("Zeus", false)
    hand = player.player_first_hand([@air1, @air2, @air3, @air4, @air5, @air7, @air8, @keep1])
    playerstate = PlayerState.new("Zeus", hand, 0, true)
    cheatadmin = CheatAdmin.new([playerstate])

    deck = Deck.list_to_deck([@air9])
    stack = Stack.create(@air9)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    turn = Turn.new(deck, stack, list_of_squads)    
    
    done = Ret.new([], [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @keep1])], @air9)
  
    player.player_take_turn(turn)

    assert_equal(true, cheatadmin.check_discards_in_hand?(player, turn, done))
  end

  def test_check_discards_in_hand_false
    player = Player.create("Zeus", false)
    hand = player.player_first_hand([@air1, @air2, @air3, @air4, @air5, @air7, @air8, @keep1])
    playerstate = PlayerState.new("Zeus", hand, 0, true)
    cheatadmin = CheatAdmin.new([playerstate])

    deck = Deck.list_to_deck([@air9])
    stack = Stack.create(@air9)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    turn = Turn.new(deck, stack, list_of_squads)    
    
    done = Ret.new([], [Squadron.new([@air10, @air11, @air12]), Squadron.new([@air4, @air5, @keep1])], @air8)
  
    player.player_take_turn(turn)

    assert_raise Cheating do
      cheatadmin.check_discards_in_hand?(player, turn, done)
    end
  end

  def test_check_attack_fighters_in_hand_true
    player = Player.create("Zeus", false)
    hand = player.player_first_hand([@air1, @air2, @air3, @air4, @air5, @air6, @air8, @keep1])
    playerstate = PlayerState.new("Zeus", hand, 0, true)
    cheatadmin = CheatAdmin.new([playerstate])

    deck = Deck.list_to_deck([@air9])
    stack = Stack.create(@air9)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    turn = Turn.new(deck, stack, list_of_squads)    
    
    done = Ret.new([Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))], [], @air8)
  
    player.player_take_turn(turn)

    assert_equal(true, cheatadmin.check_attack_fighters_in_hand?(player, turn, done))
  end

  def test_check_attack_fighters_in_hand_false
    player = Player.create("Zeus", false)
    hand = player.player_first_hand([@air1, @air2, @air3, @air4, @air5, @air7, @air8, @keep1])
    playerstate = PlayerState.new("Zeus", hand, 0, true)
    cheatadmin = CheatAdmin.new([playerstate])

    deck = Deck.list_to_deck([@air9])
    stack = Stack.create(@air9)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    turn = Turn.new(deck, stack, list_of_squads)    
    
    done = Ret.new([Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))], [], @air8)
  
    player.player_take_turn(turn)

    assert_raise Cheating do
      cheatadmin.check_attack_fighters_in_hand?(player, turn, done)
    end
  end

  def test_check_attack_bombers_from_table_true
    player = Player.create("Zeus", false)
    hand = player.player_first_hand([@air1, @air2, @air3, @air4, @air5, @air6, @air8, @keep1])
    playerstate = PlayerState.new("Zeus", hand, 0, true)
    cheatadmin = CheatAdmin.new([playerstate])

    deck = Deck.list_to_deck([@air9])
    stack = Stack.create(@air9)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    turn = Turn.new(deck, stack, list_of_squads)    
    
    done = Ret.new([Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))], [], @air8)
  
    player.player_take_turn(turn)

    assert_equal(true, cheatadmin.check_attack_bombers_from_table?(turn, done))
  end

  def test_check_attack_bombers_from_table_false
    player = Player.create("Zeus", false)
    hand = player.player_first_hand([@air1, @air2, @air3, @air4, @air5, @air7, @air8, @keep1])
    playerstate = PlayerState.new("Zeus", hand, 0, true)
    cheatadmin = CheatAdmin.new([playerstate])

    deck = Deck.list_to_deck([@air9])
    stack = Stack.create(@air9)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    turn = Turn.new(deck, stack, list_of_squads)    
    
    done = Ret.new([Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @keep1]))], [], @air8)
  
    player.player_take_turn(turn)

    assert_raise Cheating do
      cheatadmin.check_attack_bombers_from_table?(turn, done)
    end
  end

  def test_check_borc_in_hand_true
    player = Player.create("Zeus", false)
    hand = player.player_first_hand([@air1, @air2, @air3, @air4, @air5, @air6, @air8, @keep1])
    playerstate = PlayerState.new("Zeus", hand, 0, true)
    cheatadmin = CheatAdmin.new([playerstate])

    deck = Deck.list_to_deck([@air9])
    stack = Stack.create(@air9)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    turn = Turn.new(deck, stack, list_of_squads)    
    
    done = Ret.new([Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))], [], @air8)
  
    player.player_take_turn(turn)

    assert(cheatadmin.check_borc_in_hand?(player, turn, done))
  end

  def test_check_borc_in_hand_false
    player = Player.create("Zeus", false)
    hand = player.player_first_hand([@air1, @air2, @air3, @air4, @air5, @air6, @air8, @keep1])
    playerstate = PlayerState.new("Zeus", hand, 0, true)
    cheatadmin = CheatAdmin.new([playerstate])

    deck = Deck.list_to_deck([@air9])
    stack = Stack.create(@air9)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    turn = Turn.new(deck, stack, list_of_squads)    
    
    done = Ret.new([Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))], [], @air12)
  
    player.player_take_turn(turn)

    assert_raise Cheating do
      cheatadmin.check_borc_in_hand?(player, turn, done)
    end
  end

  def test_check_only_play_once_true
    player = Player.create("Zeus", false)
    hand = player.player_first_hand([@air1, @air2, @air3, @air4, @air5, @air6, @air8, @keep1])
    playerstate = PlayerState.new("Zeus", hand, 0, true)
    cheatadmin = CheatAdmin.new([playerstate])

    deck = Deck.list_to_deck([@air9])
    stack = Stack.create(@air9)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    turn = Turn.new(deck, stack, list_of_squads)    
    
    done = Ret.new([Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))], [], @air12)
  
    player.player_take_turn(turn)

    assert(cheatadmin.check_only_play_once?(player, turn, done))
  end

  def test_check_only_play_once_false
    player = Player.create("Zeus", false)
    hand = player.player_first_hand([@air1, @air2, @air3, @air4, @air5, @air6, @air8, @keep1])
    playerstate = PlayerState.new("Zeus", hand, 0, true)
    cheatadmin = CheatAdmin.new([playerstate])

    deck = Deck.list_to_deck([@air9])
    stack = Stack.create(@air9)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    turn = Turn.new(deck, stack, list_of_squads)    
    
    done = Ret.new([Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))], [], @air4)
  
    player.player_take_turn(turn)

    assert_raise Cheating do
      cheatadmin.check_only_play_once?(player, turn, done)
    end
  end
  
  def test_check_discards_removed_from_hand_true
    player = Player.create("Zeus", false)
    hand = player.player_first_hand([@air4, @air5, @air6])
    playerstate = PlayerState.new("Zeus", hand, 0, true)
    cheatadmin = CheatAdmin.new([playerstate])

    deck = Deck.list_to_deck([@air9])
    stack = Stack.create(@air9)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    turn = Turn.new(deck, stack, list_of_squads)    
    
    done = Ret.new([Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))], [], @air9)
  
    player.player_take_turn(turn)

    assert(cheatadmin.check_discards_removed_from_hand?(player, turn, done))
  end
  
  def test_check_discards_removed_from_hand_false
    player = Player.create("Zeus", false)
    hand = player.player_first_hand([@air4, @air5, @air6])
    playerstate = PlayerState.new("Zeus", hand, 0, true)
    cheatadmin = CheatAdmin.new([playerstate])

    deck = Deck.list_to_deck([@air9])
    stack = Stack.create(@air9)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    turn = Turn.new(deck, stack, list_of_squads)    
    
    done = Ret.new([Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))], [], @air9)
  
    player.player_take_turn(turn)

    player.player_first_hand([@air4, @air5])

    assert_raise Cheating do
      cheatadmin.check_discards_removed_from_hand?(player, turn, done)
    end
  end

  def test_check_valid_squadrons?
    # Valid Discards
    done1 = Ret.new([], 
      [Squadron.new([@air1, @air2, @air3]), 
      Squadron.new([@air4, @air5, @keep1])], @air7)
    # One all WildCards
    #done2 = End.new([], 
    #  [Squadron.new([@air1, @air2, @air3]), 
    #  Squadron.new([@air4, @air5, @keep1]), 
    #  Squadron.new([@keep2, @keep3, @keep4])], false)
    # One with different Aircraft types
    #done3 = Ret.new([], 
    #  [Squadron.new([@air1, @air2, @air9]), 
    #  Squadron.new([@air4, @air5, @keep1])], @air7)
    # One with only 2 cards
    done4 = End.new([], 
      [Squadron.new([@air1, @air2]), 
      Squadron.new([@air4, @air5, @keep1]), 
      Squadron.new([@air7, @air8, @air9])], false)
    
    assert_equal(true, @cheatadmin.check_valid_squadrons?(done1))
    #assert_raise Cheating do
    #  @cheatadmin.check_valid_squadrons?(done2)
    #end
    #assert_raise Cheating do
    #  @cheatadmin.check_valid_squadrons?(done3)
    #end
    assert_raise Cheating do
      @cheatadmin.check_valid_squadrons?(done4)
    end
  end
  
  def test_check_all_discards_valid_true
    player = Player.create("Zeus", false)
    hand = player.player_first_hand([@air4, @air5, @air6])
    playerstate = PlayerState.new("Zeus", hand, 0, true)
    cheatadmin = CheatAdmin.new([playerstate])

    done = Ret.new([Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))], [], @air9)
  
    assert(cheatadmin.check_all_discards_valid?(done))
  end
  
  def test_check_all_discards_valid_false
    player = Player.create("Zeus", false)
    hand = player.player_first_hand([@air4, @air5, @air6])
    playerstate = PlayerState.new("Zeus", hand, 0, true)
    cheatadmin = CheatAdmin.new([playerstate])

    bad_air = Aircraft.new(Image.new("Baku Geki KI-99.gif"), "Baku Geki KI-99", Axis.new, Bomber.new, 9)
    
    done = Ret.new([Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))], [], bad_air)
  
    assert_raise Cheating do
      cheatadmin.check_all_discards_valid?(done)
    end
  end
end
