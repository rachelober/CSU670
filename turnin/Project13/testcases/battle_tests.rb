# !/arch/unix/bin/ruby

# battle_tests.rb
# Tests all methods from battle.rb

# Required files
require 'test/unit'
require 'code/administrator.rb'
require 'code/battle.rb'

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
  end

  def test_play_one_turn_1
    player = Player.create("God", false)
    hand = player.player_first_hand([@air4, @air5, @air6, @air10, @air11, @keep1])
    deck = Deck.list_to_deck([@vic1])
    stack = Stack.new([@vic1])
    list_of_discards = [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air7, @air8, @keep3])]
    playerstate = PlayerState.new("God", hand, 0, true)
    battle = Battle.new([player], [playerstate], [])

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
    battle = Battle.new([player], [playerstate], [])
    
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
    battle = Battle.new([player], [playerstate], [])
    
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

=begin
  def test_deal_hands
    god_player = Player.create("God", false)
    god_state = PlayerState.new("God", Hand.new([]), 0, true)
    budda_player = Player.create("Budda", false)
    budda_state = PlayerState.new("Budda", Hand.new([]), 0, true)
    moses_player = Player.create("Moses", false)
    moses_state = PlayerState.new("Moses", Hand.new([]), 0, true)

    list_of_players = [god_player, budda_player, moses_player]
    list_of_playerstates = [god_state, budda_state, moses_state]

    battle = Battle.new(list_of_players, list_of_playerstates, [])

    battle.deal_hands

    assert_instance_of(Hand, god_state.hand)
    assert(god_player.player_hand.hand_to_list.size == 7)
    assert(budda_player.player_hand.hand_to_list.size == 7)
    assert(moses_player.player_hand.hand_to_list.size == 7)
    assert(god_state.hand.hand_to_list.size == 7)
    assert(budda_state.hand.hand_to_list.size == 7)
    assert(moses_state.hand.hand_to_list.size == 7)
    assert(god_player.player_hand.equal?(god_state.hand))
    assert(budda_player.player_hand.equal?(budda_state.hand))
    assert(moses_player.player_hand.equal?(moses_state.hand))
  end
=end

=begin
  def test_update_table
    god_player = Player.create("God", false)
    god_state = PlayerState.new("God", Hand.new([]), 0, true)
    budda_player = Player.create("Budda", false)
    budda_state = PlayerState.new("Budda", Hand.new([]), 0, true)
    moses_player = Player.create("Moses", false)
    moses_state = PlayerState.new("Moses", Hand.new([]), 0, true)

    list_of_players = [god_player, budda_player, moses_player]
    list_of_playerstates = [god_state, budda_state, moses_state]

    battle = Battle.new(list_of_players, list_of_playerstates, [])

    battle.update_table([Squadron.new([@air7, @air8, @air9])], [], moses_player)

    expected_table = [SquadronState.new(Squadron.new([@air7, @air8, @air9]), moses_player)]

    assert(battle.equal_squadronstructs_list?(expected_table, battle.table))

    list_of_turn_discards = [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @air6])]
    list_of_turn_attacks = [Attack.new(Squadron.new([@air10, @air11, @air12]), Squadron.new([@air7, @air8, @air9]))]

    battle.update_table(list_of_turn_discards, list_of_turn_attacks, god_player)

    expected_table = [
      SquadronState.new(Squadron.new([@air1, @air2, @air3]), god_player),
      SquadronState.new(Squadron.new([@air4, @air5, @air6]), god_player),
      SquadronState.new(Squadron.new([@air10, @air11, @air12]), god_player),
      SquadronState.new(Squadron.new([@air7, @air8, @air9]), god_player),
    ]

    assert(battle.equal_squadronstructs_list?(expected_table, battle.table))
  end
=end

=begin
  def test_update_score
    god_player = Player.create("God", false)
    god_state = PlayerState.new("God", Hand.new([@air1, @air2]), 0, true)
    budda_player = Player.create("Budda", false)
    budda_state = PlayerState.new("Budda", Hand.new([@keep1]), 0, true)
    moses_player = Player.create("Moses", false)
    moses_state = PlayerState.new("Moses", Hand.new([@air3]), 0, true)

    list_of_players = [god_player, budda_player, moses_player]
    list_of_playerstates = [god_state, budda_state, moses_state]

    battle = Battle.new(list_of_players, list_of_playerstates, [])

    battle.update_table([Squadron.new([@air7, @air8, @air9])], [], moses_player)
    
    list_of_turn_discards = [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @air6])]
    list_of_turn_attacks = [Attack.new(Squadron.new([@air10, @air11, @air12]), Squadron.new([@air7, @air8, @air9]))]

    battle.update_table(list_of_turn_discards, list_of_turn_attacks, god_player)
    
    battle.update_score

    assert_equal(70, god_state.score, "Update Score failed")
    assert_equal(0, budda_state.score, "Update Score failed")
    assert_equal(-10, moses_state.score, "Update Score failed")
  end
=end

=begin
  def test_attackable_squads
    god_player = Player.create("God", false)
    god_state = PlayerState.new("God", Hand.new([@air1, @air2]), 0, true)
    budda_player = Player.create("Budda", false)
    budda_state = PlayerState.new("Budda", Hand.new([@keep1]), 0, true)
    moses_player = Player.create("Moses", false)
    moses_state = PlayerState.new("Moses", Hand.new([@air3]), 0, true)

    list_of_players = [god_player, budda_player, moses_player]
    list_of_playerstates = [god_state, budda_state, moses_state]

    battle = Battle.new(list_of_players, list_of_playerstates, [])

    list_of_turn_discards = [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @air6])]
    list_of_turn_attacks = [Attack.new(Squadron.new([@air10, @air11, @air12]), Squadron.new([@air7, @air8, @air9]))]
    
    battle.update_table(list_of_turn_discards, list_of_turn_attacks, god_player)
   
    list_of_attackable = battle.attackable_squads(budda_player)
    expected_attackable = [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @air6])]

    assert_equal(expected_attackable, list_of_attackable)
  end
=end

=begin
  def test_maintain_deck
    god_player = Player.create("God", false)
    god_state = PlayerState.new("God", Hand.new([]), 0, true)
    budda_player = Player.create("Budda", false)
    budda_state = PlayerState.new("Budda", Hand.new([]), 0, true)
    moses_player = Player.create("Moses", false)
    moses_state = PlayerState.new("Moses", Hand.new([]), 0, true)

    battle = Battle.new([god_player, budda_player, moses_player],
      [god_state, budda_state, moses_state], [])
    
    deck = Deck.new([])
    stack = Stack.new([@air1, @air2, @air4, @air5, @keep1])

    deck_new, stack_new = battle.maintain_deck(deck, stack)

    expected_deck = Deck.new([@air2, @air4, @air5, @keep1])
    expected_stack = Stack.new([@air1])

    assert_same(expected_stack, stack_new)
    assert(deck_new.deck_to_list.each{|card|
      expected_deck.deck_to_list.include?(card)})
  end
=end

=begin
  def test_run_battle
    god_player = Player.create("God", false)
    god_state = PlayerState.new("God", Hand.new([]), 0, true)
    budda_player = Player.create("Budda", false)
    budda_state = PlayerState.new("Budda", Hand.new([]), 0, true)
    moses_player = Player.create("Moses", false)
    moses_state = PlayerState.new("Moses", Hand.new([]), 0, true)

    battle = Battle.new([god_player, budda_player, moses_player],
      [god_state, budda_state, moses_state], [])

    battle.run_battle    
  end
=end
end
