# !/arch/unix/bin/ruby

# player_tests.rb
# Test cases for player.rb

# Required Files
require 'test/unit'
require 'code/player.rb'

class TestPlayer < Test::Unit::TestCase
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

    @player1 = Player.create("Rachel", false)
    @player1.player_first_hand([@air1, @air2, @air3, @keep1, @keep3, @keep4])
    
    expected_attacks1 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))
    expected_attacks2 = Attack.new(Squadron.new([@air10, @air11, @air12]), Squadron.new([@air1, @air2, @air3]))
    expected_attacks3 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))
  
    @list_of_attacks1 = [expected_attacks1, expected_attacks2, expected_attacks3]
    @list_of_attacks2 = [expected_attacks3, expected_attacks1, expected_attacks2]
    @list_of_squads = [Squadron.new([@air1, @air2, @air3])]
  end

  def test_create
    assert_instance_of(Player, Player.create("Test Player", false), "Player.create failed")
  end

  def test_contract_no_card_on_deck_stack
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@air1, @air2, @air3, @air4, @air5, @air6, @air10, @air11, @air12])

    deck = Deck.list_to_deck([])
    stack = Stack.create(nil)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    example_turn = Turn.new(deck, stack, list_of_squads)

    assert_raise ContractViolation do
      player2.player_take_turn(example_turn)
    end
  end
  
  def test_contract_card_only_on_stack
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@air1, @air2, @air3, @air4, @air5, @air6, @air10, @air11, @air12])

    deck = Deck.list_to_deck([])
    stack = Stack.create(@vic1)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    example_turn = Turn.new(deck, stack, list_of_squads)

    player2.player_take_turn(example_turn)
  end
  
  def test_player_name
    assert_instance_of(String, @player1.player_name, "Player.player_name failed")
    assert_equal("Rachel", @player1.player_name, "Player.player_name failed")
  end

  def test_player_hand
    player2 = Player.create("Player 2", false)
    player2_first_hand_list = [@air1, @air2, @air3]
    
    assert_instance_of(Hand, player2.player_hand, "Player.player_hand failed")
    assert_same(Hand.create(Array.new), player2.player_hand, "Player.player_hand failed")
  end

  def test_player_first_hand
    player2 = Player.create("Player 2", false)
    player2_first_hand_list = [@air1, @air2, @air3]
    
    assert_instance_of(Hand, @player1.player_first_hand([@air1]), "Player.player_first_hand failed")
    assert_same(Hand.new([]), player2.player_hand, "Player.player_first_hand failed")
    assert_same(Hand.new([@air1, @air2, @air3]), player2.player_first_hand(player2_first_hand_list), 
    "Player.player_first_hand failed")
    assert_same(Hand.new(player2_first_hand_list), player2.player_hand, "Player.player_first_hand failed")
  end

  def test_update_hand
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@air4, @air5, @vic1, @air7, @air8, @keep2, @keep6])

    list_of_squads = [Squadron.new([@air7, @air8, @keep2]), Squadron.new([@keep6, @air4, @air5])]
    
    assert_equal(Hand.new([@vic1]), player2.update_hand(list_of_squads), "Player.update_hand failed")
    assert_equal(Hand.new([@vic1]), player2.player_hand, "Player.update_hand failed")
  end

  def test_play_hand
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@air4, @air5, @keep1])
    
    from_deck_or_stack = [@keep6]
    list_of_allies = [Squadron.new([@air7, @air8, @air9])]
    list_of_axis = [Squadron.new([@air1, @air2, @air3])]

    expected_attacks = [Attack.new(Squadron.new([@air4, @air5, @keep1]), Squadron.new([@air1, @air2, @air3]))]
    expected_discards = []
    
    result_attacks, result_discards = player2.play_hand(from_deck_or_stack, list_of_allies, list_of_axis)

    assert_equal(expected_attacks, result_attacks)
    assert_equal(expected_discards, result_discards)
    assert_equal(Hand.new([@keep6]), player2.player_hand)
  end

  def test_play_hand_discards_already_on_table_one_aircraft
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@air4, @vic1, @keep1])
    
    from_deck_or_stack = [@keep6]
    list_of_allies = [Squadron.new([@air7, @air8, @air9]), Squadron.new([@keep2, @air5, @air6])]
    list_of_axis = [Squadron.new([@air1, @air2, @air3])]

    expected_attacks = []
    expected_discards = []
    
    result_attacks, result_discards = player2.play_hand(from_deck_or_stack, list_of_allies, list_of_axis)

    assert_equal(expected_attacks, result_attacks)
    assert_equal(expected_discards, result_discards)
    assert_equal(Hand.new([@keep6, @air4, @vic1, @keep1]), player2.player_hand)
  end

  def test_player_take_turn_ret_card
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@air4])

    list_of_discards = []
    list_of_attacks = []
    card = @air4
    expected_done = Ret.new(list_of_attacks, list_of_discards, card)

    deck = Deck.list_to_deck([@air4])
    stack = Stack.create(@air4)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    example_turn = Turn.new(deck, stack, list_of_squads)

    assert_same(expected_done, player2.player_take_turn(example_turn), "Player.player_take_turn failed")
    assert(!example_turn.turn_end.nil?)
  end

  def test_player_take_turn_end_nil
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@air7, @air8, @air9, @air4, @air5])

    list_of_discards = [Squadron.new([@air7, @air8, @air9])]
    list_of_attacks = [Attack.new(Squadron.new([@keep1, @air4, @air5]), Squadron.new([@air1, @air2, @air3]))]
    card = nil
    expected_done = End.new(list_of_attacks, list_of_discards, card)

    deck = Deck.list_to_deck([@keep1])
    stack = Stack.create(@keep1)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    example_turn = Turn.new(deck, stack, list_of_squads)

    assert_same(expected_done, player2.player_take_turn(example_turn), "Player.player_take_turn failed")
    assert(!example_turn.turn_end.nil?)
  end

  def test_player_take_turn_end_card
    player2 = Player.create("Player 2", false)
    player2.player_first_hand([@air7, @air8, @air9, @air4, @air5, @air6, @air10, @air11, @air12])

    list_of_discards = [Squadron.new([@air10, @air11, @air12]), Squadron.new([@air7, @air8, @air9])]
    list_of_attacks = [Attack.new(Squadron.new([@air6, @air4, @air5]), Squadron.new([@air1, @air2, @air3]))]
    card = @keep1
    expected_done = End.new(list_of_attacks, list_of_discards, card)

    deck = Deck.list_to_deck([@keep1])
    stack = Stack.create(@keep1)
    list_of_squads = [Squadron.new([@air1, @air2, @air3])]
    example_turn = Turn.new(deck, stack, list_of_squads)

    assert_same(expected_done, player2.player_take_turn(example_turn), "Player.player_take_turn failed")
    assert(!example_turn.turn_end.nil?)
  end
end
