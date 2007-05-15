# !/arch/unix/bin/ruby

# strategy_tests.rb
# Test cases for strategy.rb

# Required Files
require 'test/unit'
require 'code/strategy.rb'
require 'code/player.rb'

class TestStrategy < Test::Unit::TestCase
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

    @default_strategy = Strategy.new
    @timing_strategy = TimingBreakerStrategy.new
    @contract_strategy = ContractBreakerStrategy.new
    @timid_strategy = TimidStrategy.new
    @inspector_strategy = InspectorStrategy.new
    @nofighters_strategy = NoFightersStrategy.new
  end

  def test_choose_cards_no_deck
    deck = Deck.list_to_deck([])
    stack = Stack.create(@vic1)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    example_turn = Turn.new(deck, stack, list_of_squads)
    
    expected = [@vic1]
    result = @default_strategy.choose_cards(example_turn, Player.new("Rachel", false, Strategy.new))

    assert_equal(expected, result, "DefaultStrategy.choose_cards failed")
  end

  def test_make_attacks_no_wildcards
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@air4, @air5, @air6])

    list_of_allies = [Squadron.new([@air7, @air8, @air9])]
    list_of_axis = [Squadron.new([@air1, @air2, @air3])]

    expected_fighters = Squadron.new([@air4, @air5, @air6])
    expected_bombers = Squadron.new([@air1, @air2, @air3])

    expected_attack_list = [Attack.new(expected_fighters, expected_bombers)]

    result = @default_strategy.make_attacks(player2, list_of_allies, list_of_axis)

    assert_instance_of(Array, result, "DefaultStrategy.make_attacks failed")
    assert_equal(expected_attack_list, result, "DefaultStrategy.make_attacks failed")
  end


  def test_make_attacks_one_wildcard
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@air4, @air5, @keep1, @air10, @air11])

    list_of_allies = [Squadron.new([@air7, @air8, @air9])]
    list_of_axis = [Squadron.new([@air1, @air2, @air3])]

    expected_fighters = Squadron.new([@air4, @air5, @keep1])
    expected_bombers = Squadron.new([@air1, @air2, @air3])

    expected_attack_list = [Attack.new(expected_fighters, expected_bombers)]

    result = @default_strategy.make_attacks(player2, list_of_allies, list_of_axis)

    assert_instance_of(Array, result, "DefaultStrategy.make_attacks failed")
    assert_equal(expected_attack_list, result, "DefaultStrategy.make_attacks failed")
  end

  def test_make_max_attacks_two_wildcards
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@air4, @keep1, @vic1])

    list_of_allies = [Squadron.new([@air7, @air8, @air9])]
    list_of_axis = [Squadron.new([@air1, @air2, @air3])]

    result = @default_strategy.make_attacks(player2, list_of_allies, list_of_axis)

    assert_instance_of(Array, result, "DefaultStrategy.make_attacks failed")
    assert_equal([Attack.new(Squadron.new([@air4, @keep1, @vic1]), 
                             Squadron.new([@air1, @air2, @air3]))], 
                 result, "DefaultStrategy.make_attacks failed")
  end

  def test_make_discards_no_wildcards
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@air1, @air5, @air6, @air2, @air3, @air4])
    expected_squad_list = [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @air6])]

    assert_instance_of(Array, @default_strategy.make_discards(player2, [], []), 
    "DefaultStrategy.make_discards failed")
    assert_equal(expected_squad_list, @default_strategy.make_discards(player2, [], []), 
    "DefaultStrategy.make_discards failed")
  end

  def test_make_discards_one_wildcard
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@air1, @air5, @vic1, @air2, @air3, @air4])
    expected_squad_list = [Squadron.new([@air1, @air2, @air3]), Squadron.new([@vic1, @air4, @air5])]

    assert_instance_of(Array, @default_strategy.make_discards(player2, [], []), 
    "DefaultStrategy.make_discards failed")
    assert_equal(expected_squad_list, @default_strategy.make_discards(player2, [], []), 
    "DefaultStrategy.make_discards failed")
  end

  def test_make_discards_two_wildcards
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@air1, @air4, @keep1, @vic1, @air2, @air3])
    expected_squad_list = [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @keep1, @vic1])]

    assert_instance_of(Array, @default_strategy.make_discards(player2, [], []), 
    "DefaultStrategy.make_discards failed")
    assert_equal(expected_squad_list, @default_strategy.make_discards(player2, [], []), 
    "DefaultStrategy.make_discards failed")
  end

  def test_make_done_end_card
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@keep1])

    list_of_discards = [Squadron.new([@air10, @air11, @air12]), Squadron.new([@air7, @air8, @air9])]
    list_of_attacks = [Attack.new(Squadron.new([@air6, @air4, @air5]), Squadron.new([@air1, @air2, @air3]))]
    card = @keep1

    expected_done = End.new(list_of_attacks, list_of_discards, card)
    result_done = @default_strategy.make_done(player2, list_of_attacks, list_of_discards, card)

    assert_same(expected_done, result_done, "DefaultStrategy.make_done failed")
  end

  def test_make_done_end_nil
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([])

    list_of_discards = [Squadron.new([@air10, @air11, @air12]), Squadron.new([@air7, @air8, @air9])]
    list_of_attacks = [Attack.new(Squadron.new([@air6, @air4, @air5]), Squadron.new([@air1, @air2, @air3]))]
    card = nil

    expected_done = End.new(list_of_attacks, list_of_discards, card)
    result_done = @default_strategy.make_done(player2, list_of_attacks, list_of_discards, card)

    assert_same(expected_done, result_done, "DefaultStrategy.make_done failed")
  end

  def test_make_done_ret
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@keep1, @air1])

    list_of_discards = [Squadron.new([@air10, @air11, @air12]), Squadron.new([@air7, @air8, @air9])]
    list_of_attacks = [Attack.new(Squadron.new([@air6, @air4, @air5]), Squadron.new([@air1, @air2, @air3]))]
    card = @keep1

    expected_done = Ret.new(list_of_attacks, list_of_discards, card)
    result_done = @default_strategy.make_done(player2, list_of_attacks, list_of_discards, card)

    assert_same(expected_done, result_done, "DefaultStrategy.make_done failed")
  end

  def test_discard_card_nil
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([])

    expected = nil
    result = @default_strategy.discard_card(player2)

    assert_same(expected, result, "DefaultStrategy.discard_card failed")
  end

  def test_discard_card_1_in_hand
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@keep1])

    expected = @keep1
    result = @default_strategy.discard_card(player2)

    assert_same(expected, result, "DefaultStrategy.discard_card failed")
  end

  def test_discard_card_multiple_in_hand
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@keep1, @keep1, @keep1])

    expected = @keep1
    result = @default_strategy.discard_card(player2)

    assert_same(expected, result, "DefaultStrategy.discard_card failed")
  end

  # ----------------------------------------
  # Timing Breaker
  # ----------------------------------------
  def test_tb_choose_cards
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@air4, @air5, @air6, @air10, @air11, @vic1])
    
    deck = Deck.list_to_deck([@vic1])
    stack = Stack.create(@vic1)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    example_turn = Turn.new(deck, stack, list_of_squads)
    
    assert_raise TimingError do
      @timing_strategy.choose_cards(example_turn, player2)
    end
  end
  
  # ----------------------------------------
  # Contract Breaker
  # ----------------------------------------
  def test_cb_choose_cards
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@air4, @air5, @air6, @air10, @air11, @vic1])
    
    deck = Deck.list_to_deck([@vic1])
    stack = Stack.create(@vic1)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    example_turn = Turn.new(deck, stack, list_of_squads)
    
    assert_raise ContractViolation do
      @contract_strategy.choose_cards(example_turn, player2)
    end
  end
  
  # ----------------------------------------
  # Timid Strategy
  # ----------------------------------------
  def test_ts_make_attacks
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@air4, @air5, @air6, @air10, @air11, @vic1])

    list_of_allies = [Squadron.new([@air7, @air8, @air9])]
    list_of_axis = [Squadron.new([@air1, @air2, @air3])]

    expected_fighters = Squadron.new([@air4, @air5, @air6])
    expected_bombers = Squadron.new([@air1, @air2, @air3])

    expected_attack_list = [Attack.new(expected_fighters, expected_bombers)]

    result = @timid_strategy.make_attacks(player2, list_of_allies, list_of_axis)

    assert_instance_of(Array, result, "DefaultStrategy.make_attacks failed")
    assert_equal(expected_attack_list, result, "DefaultStrategy.make_attacks failed")
  end

  def test_ts_make_discards_one_wildcard
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@air1, @air5, @vic1, @air2, @air3, @air4])
    expected_squad_list = [Squadron.new([@air1, @air2, @air3])]

    assert_instance_of(Array, @timid_strategy.make_discards(player2, [], []), 
    "DefaultStrategy.make_discards failed")
    assert_equal(expected_squad_list, @timid_strategy.make_discards(player2, [], []), 
    "DefaultStrategy.make_discards failed")
  end
  
  def test_ts_discard_card
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@keep1, @air5, @air6])

    expected = @keep1
    result = @timid_strategy.discard_card(player2)

    assert_same(expected, result, "DefaultStrategy.discard_card failed")
  end
  
  # ----------------------------------------
  # Inspector Strategy
  # ----------------------------------------
  def test_is_choose_cards
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@keep1, @air5, @air6])
    
    deck = Deck.list_to_deck([])
    stack = Stack.create(@air4)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    example_turn = Turn.new(deck, stack, list_of_squads)
    
    expected = [@air4]
    result = @inspector_strategy.choose_cards(example_turn, player2)

    assert_equal(expected, result, "DefaultStrategy.choose_cards failed")
  end
  
  def test_is_choose_cards_2
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@keep1, @air5, @air6])
    
    deck = Deck.list_to_deck([])
    stack = Stack.new([@keep2, @air4])
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    example_turn = Turn.new(deck, stack, list_of_squads)
    
    expected = [@keep2, @air4]
    result = @inspector_strategy.choose_cards(example_turn, player2)

    assert_equal(expected, result, "DefaultStrategy.choose_cards failed")
  end
  
  def test_is_choose_cards_3
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@keep1, @air5, @air6])
    
    deck = Deck.list_to_deck([])
    stack = Stack.new([@keep2, @air4, @keep4])
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    example_turn = Turn.new(deck, stack, list_of_squads)
    
    expected = [@keep2, @air4]
    result = @inspector_strategy.choose_cards(example_turn, player2)

    assert_equal(expected, result, "DefaultStrategy.choose_cards failed")
  end
  
  # ----------------------------------------
  # No Fighters Strategy
  # ----------------------------------------
  def test_nf_make_discards
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@air1, @air5, @air6, @air2, @air3, @air4])
    expected_squad_list = [Squadron.new([@air1, @air2, @air3])]

    assert_instance_of(Array, @nofighters_strategy.make_discards(player2, [], []), 
    "DefaultStrategy.make_discards failed")
    assert_equal(expected_squad_list, @nofighters_strategy.make_discards(player2, [], []), 
    "DefaultStrategy.make_discards failed")
  end
end
