# !/arch/unix/bin/ruby

# strategy.rb
# First included in Project 11
# Includes all of the classes needed to make strategies for Player

# This is the default strategy. The Player takes a card from either the 
# Deck or the Stack randomly and tries to play as many Attacks and as many 
# discards as possible.
class Strategy
  def initialize
  end

  # choose_cards : Strategy Turn -> ListOf-Card
  def choose_cards(turn)
    num = rand(turn.turn_stack_inspect.size)
    num += 1

    if turn.turn_card_on_deck?
      rand_num = rand(2)
      case
      when rand_num == 0: Array.new.push(turn.turn_get_a_card_from_deck)
      when rand_num == 1: turn.turn_get_cards_from_stack(num)
      end
    else
      turn.turn_get_cards_from_stack(num)
    end
  end
  
  # make_attacks : Strategy Player ListOf-Squadron ListOf-Squadron -> ListOf-Attack
  #
  # What attacks can the Player make?
  # This method takes into consideration the different squadrons played
  # by other players and tries to make the maximum amount of attacks
  # from their cards.
  def make_attacks(player, list_of_allies, list_of_axis)
    complete_fighter_squads = player.player_hand.completes.find_all {|squad| squad.squadron_fighter?}
    complement_fighter_squads = player.player_hand.complementable.find_all {|squad| squad.squadron_fighter?}

    # We need to make sure that we don't make attacks with squadrons that have already been used
    complete_fighter_squads = player.remove_used_squads(complete_fighter_squads, list_of_allies, list_of_axis)
    complement_fighter_squads = player.remove_used_squads(complement_fighter_squads, list_of_allies, list_of_axis)

    wildcards = player.player_hand.wildcards
    attacks = []
    # First we'll go through and make attacks from our known completed squadrons.
    # Then we can go back over and decide which incomplete squadrons we should
    # add wildcards to.
    complete_fighter_squads.dup.each{|squad|
      if squad.squadron_alliance.instance_of?(Allies) && list_of_axis.size > 0
        attacks << Attack.new(squad, list_of_axis.shift)
      elsif squad.squadron_alliance.instance_of?(Axis) && list_of_allies.size > 0
        attacks << Attack.new(squad, list_of_allies.shift)
      end
    }

    # What we need to look at is whether we should add a WildCard to
    # the incomplete Squadron or not. We SHOULD if there is an opposing 
    # Squadron we can fight but we SHOULD NOT if there is not an opposing
    # Bomber to attack. If we decide to add a WildCard, we then make an 
    # attack with that Fighter Squadron and the opposing Bomber Squadron.
    complement_fighter_squads.dup.each{|squad|
      if wildcards.size > 0
        if squad.squadron_alliance.instance_of?(Allies) && list_of_axis.size > 0
          if wildcards.size >= 2 && squad.list_of_cards.size == 1
            attacks << Attack.new(squad.push!(wildcards.shift).push!(wildcards.shift),
                                  list_of_axis.shift)
          else
            attacks << Attack.new(squad.push!(wildcards.shift), list_of_axis.shift)
          end
        elsif squad.squadron_alliance.instance_of?(Axis) && list_of_allies. size > 0
          if wildcards.size >= 2 && squad.list_of_cards.size == 1
            attacks << Attack.new(squad.push!(wildcards.shift).push!(wildcards.shift),
                                  list_of_allies.shift)
          else
            attacks << Attack.new(squad.push!(wildcards.shift), list_of_allies.shift)
          end
        end
      end
    }
    
    # Now return all the attacks we've made
    attacks
  end

  # make_discards : Strategy Player ListOf-Squadron ListOf-Squadron -> ListOf-Squadron
  #
  # What squadrons can the user play? This method looks at the player's 
  # Hand and determines what other squadrons can be discarded. This method 
  # is usually called after analyzing which attacks can be played
  # so the maximum amount of points can be aquired.
  def make_discards(player, list_of_allies, list_of_axis)
    complete_squads = player.player_hand.completes
    complement_squads = player.player_hand.complementable
    wildcards = player.player_hand.wildcards

    # We need to make sure that we don't make attacks with squadrons that have already been used
    complete_squads = player.remove_used_squads(complete_squads, list_of_allies, list_of_axis)
    complement_squads = player.remove_used_squads(complement_squads, list_of_allies, list_of_axis)

    # Look through complement squadrons and go ahead and add
    # WildCards to them.
    complement_squads.each{|squadron|
      if wildcards.size > 0
        if wildcards.size >= 2 && squadron.list_of_cards.size == 1
          squadron.push!(wildcards.shift)
          squadron.push!(wildcards.shift)
        else
          squadron.push!(wildcards.shift)
        end
      end
    }
    
    # Combine the two lists of Squadrons
    all_squads = complete_squads.dup.concat(complement_squads)

    # Now we go through and make sure all the Squadrons
    # are complete.
    all_squads.find_all {|squadron| squadron.squadron_complete? }
  end

  # discard_card : Strategy Player -> Card
  def discard_card(player)
    if player.player_hand.size == 0
      return nil
    elsif player.player_hand.size == 1
      return player.player_hand.hand_to_list.first
    else
      rand_index = rand(player.player_hand.size)
      return player.player_hand.hand_to_list.fetch(rand_index)
    end
  end

  # make_done : Strategy Player ListOf-Attack ListOf-Discard Card -> Done
  def make_done(player, attacks, discards, card)
    if player.player_hand.size == 0
      return End.new(attacks, discards, nil)
    elsif player.player_hand.size == 1
      return End.new(attacks, discards, card)
    else
      return Ret.new(attacks, discards, card)
    end
  end
end

# This Strategy calls for cheating. This player cheats so that if he has a single 
# Aircraft card but no WildCards he materializes an extra Keepem Card.
# Unless he doesn't have any cards left in his hand, he tries to pass off a 
# random Keepem Card as a discard. This Player also tries to tell the 
# Administrator that he's out of cards and therefore the battle should be over.
class CheaterStrategy < Strategy
  def initialize
  end

  # make_attacks : Strategy Player ListOf-Squadron ListOf-Squadron -> ListOf-Attack
  #
  # What attacks can the Player make?
  def make_attacks(player, list_of_allies, list_of_axis)
    complete_fighter_squads = player.player_hand.completes.find_all {|squad| squad.squadron_fighter?}
    complement_fighter_squads = player.player_hand.complementable.find_all {|squad| squad.squadron_fighter?}

    # We need to make sure that we don't make attacks with squadrons that have already been used
    complete_fighter_squads = player.remove_used_squads(complete_fighter_squads, list_of_allies, list_of_axis)
    complement_fighter_squads = player.remove_used_squads(complement_fighter_squads, list_of_allies, list_of_axis)

    wildcards = player.player_hand.wildcards
    attacks = []
    # First we'll go through and make attacks from our known completed squadrons.
    # Then we can go back over and decide which incomplete squadrons we should
    # add wildcards to.
    complete_fighter_squads.dup.each{|squad|
      if squad.squadron_alliance.instance_of?(Allies) && list_of_axis.size > 0
        attacks << Attack.new(squad, list_of_axis.shift)
      elsif squad.squadron_alliance.instance_of?(Axis) && list_of_allies.size > 0
        attacks << Attack.new(squad, list_of_allies.shift)
      end
    }

    # This is very similar to the default strategy however, this player wants to
    # cheat and will slip in an extra WildCard if he has two of a kind but not
    # enough WildCards.
    complement_fighter_squads.dup.each{|squad|
      if squad.squadron_alliance.instance_of?(Allies) && list_of_axis.size > 0
        if wildcards.size >= 2 && squad.list_of_cards.size == 1
          attacks << Attack.new(squad.push!(wildcards.shift).push!(wildcards.shift),
                                list_of_axis.shift)
        elsif wildcards.size > 1 && squad.list_of_cards == 2 
          attacks << Attack.new(squad.push!(wildcards.shift), list_of_axis.shift)
        elsif squad.list_of_cards == 2
          attacks << Attack.new(squad.push!(Keepem.new(Image.new("keepem.gif"), rand(5)+1)), 
                                list_of_axis.shift)
        end
      elsif squad.squadron_alliance.instance_of?(Axis) && list_of_allies.size > 0
        if wildcards.size >= 2 && squad.list_of_cards.size == 1
          attacks << Attack.new(squad.push!(wildcards.shift).push!(wildcards.shift),
                                list_of_allies.shift)
        elsif wildcards.size > 1 && squad.list_of_cards == 2 
          attacks << Attack.new(squad.push!(wildcards.shift), list_of_allies.shift)
        elsif squad.list_of_cards == 2
          attacks << Attack.new(squad.push!(Keepem.new(Image.new("keepem.gif"), rand(5)+1)), 
                                list_of_allies.shift)
        end
      end
    }
    
    # Now return all the attacks we've made
    attacks
  end

  # make_discards : Strategy Player ListOf-Squadron ListOf-Squadron -> ListOf-Squadron
  #
  # What squadrons can the user play? 
  def make_discards(player, list_of_allies, list_of_axis)
    complete_squads = player.player_hand.completes
    complement_squads = player.player_hand.complementable
    wildcards = player.player_hand.wildcards

    # We need to make sure that we don't make attacks with squadrons that have already been used
    complete_squads = player.remove_used_squads(complete_squads, list_of_allies, list_of_axis)
    complement_squads = player.remove_used_squads(complement_squads, list_of_allies, list_of_axis)

    # Look through complement squadrons and go ahead and add
    # WildCards to them. If we don't have enough WildCards, well then
    # just make some up.
    complement_squads.each{|squadron|
      if wildcards.size > 0
        if wildcards.size >= 2 && squadron.list_of_cards.size == 1
          squadron.push!(wildcards.shift)
          squadron.push!(wildcards.shift)
        elsif wildcards.size > 1 && squadron.list_of_cards.size == 2
          squadron.push!(wildcards.shift)
        else
          squadron.push!(Keepem.new(Image.new("keepem.gif"), rand(5)+1))
        end
      end
    }
    
    # Combine the two lists of Squadrons
    all_squads = complete_squads.dup.concat(complement_squads)

    # Now we go through and make sure all the Squadrons
    # are complete.
    all_squads.find_all {|squadron| squadron.squadron_complete? }
  end

  # discard_card : Strategy Player -> Card
  def discard_card(player)
    if player.player_hand.size == 0
      nil
    else
      rand_index = rand(5)
      rand_index += 1
      Keepem.new(Image.new("keepem.gif"))
    end
  end

  # make_done : Strategy Player ListOf-Attack ListOf-Discard Card -> Done
  #
  # This Player always returns an End.
  def make_done(player, attacks, discards, card)
    End.new(attacks, discards, card)
  end
end

# This Strategy causes a timing error. The Player tries to draw more cards from the
# Deck or Stack than he should.
class TimingBreakerStrategy < Strategy
  # choose_cards : Strategy Turn -> ListOf-Card
  def choose_cards(turn)
    if turn.turn_card_on_deck?
      rand_num = rand(2)
      list_of_cards = case
                      when rand_num == 0: Array.new.push(turn.turn_get_a_card_from_deck)
                      when rand_num == 1: turn.turn_get_cards_from_stack(1)
      end
    else
      list_of_cards = turn.turn_get_cards_from_stack(1)
    end
      list_of_cards.concat(turn.turn_get_cards_from_stack(1))
  end
end

# This Strategy breaks contract. He tries to take more from the
# stack than is available.
class ContractBreakerStrategy < Strategy
  # choose_cards : Strategy Turn -> ListOf-Card
  def choose_cards(turn)
    num = rand(turn.turn_stack_inspect.size)
    num += 2

    turn.turn_get_cards_from_stack(num)
  end
end

# This Strategy doesn't like to use WildCards and only likes to use them when
# making discards. He will try to discard a WildCard if he has them in
# his hand at the end.
class TimidStrategy < Strategy
  # make_attacks : Strategy Player ListOf-Squadron ListOf-Squadron -> ListOf-Attack
  #
  # What attacks can the Player make?
  def make_attacks(player, list_of_allies, list_of_axis)
    complete_fighter_squads = player.player_hand.completes.find_all {|squad| squad.squadron_fighter?}

    # We need to make sure that we don't make attacks with squadrons that have already been used
    complete_fighter_squads = player.remove_used_squads(complete_fighter_squads, list_of_allies, list_of_axis)

    wildcards = player.player_hand.wildcards
    attacks = []
    # First we'll go through and make attacks from our known completed squadrons.
    # Then we can go back over and decide which incomplete squadrons we should
    # add wildcards to.
    complete_fighter_squads.dup.each{|squad|
      if squad.squadron_alliance.instance_of?(Allies) && list_of_axis.size > 0
        attacks << Attack.new(squad, list_of_axis.shift)
      elsif squad.squadron_alliance.instance_of?(Axis) && list_of_allies.size > 0
        attacks << Attack.new(squad, list_of_allies.shift)
      end
    }
    
    # Now return all the attacks we've made
    attacks
  end

  # make_discards : Strategy Player ListOf-Squadron ListOf-Squadron -> ListOf-Squadron
  #
  # What squadrons can the user play? 
  def make_discards(player, list_of_allies, list_of_axis)
    complete_squads = player.player_hand.completes

    # We need to make sure that we don't make attacks with squadrons that have already been used
    complete_squads = player.remove_used_squads(complete_squads, list_of_allies, list_of_axis)
  end

  # discard_card : Strategy Player -> Card
  def discard_card(player)
    if player.player_hand.size == 0
      return nil
    elsif player.player_hand.size == 1
      return player.player_hand.hand_to_list.first
    elsif player.player_hand.wildcards.size > 0
      wildcards = player.player_hand.wildcards
      rand_index = rand(wildcards.size)
      return wildcards.fetch(rand_index)
    else
      rand_index = rand(player.player_hand.size)
      return player.player_hand.hand_to_list.fetch(rand_index)
    end
  end
end

# This Strategy inspects the Stack before he decides if he wants to take
# a Card from the Deck or Stack to see if anything matches what he currently
# has in his Hand to make something complete. 
class InspectorStrategy < Strategy
  # choose_cards : Strategy Turn -> ListOf-Card
  def choose_cards(turn, player)
    stack = turn.turn_stack_inspect
    complementable = player.player_hand.complementable

    possible = []
    complementable.each{|x|
      possible << stack.detect {|y| y.cards_have_same_name?(x.squadron_first_aircraft)}
    }

    index = stack.index(possible.first)
    index += 1
    
    if index.nil? && turn.turn_card_on_deck?
      Array.new.push(turn.turn_get_a_card_from_deck)
    elsif !index.nil?
      turn.turn_get_cards_from_stack(index)
    else
      num = rand(turn.turn_stack_inspect.size)
      num += 1
      turn.turn_get_cards_from_stack(num)
    end
  end
end

# This Strategy never playes Fighters as discards because he wants to win
# as many points by shooting down other players' bombers. He always inspects 
# the stack before deciding which to take from.
class NoFightersStrategy < Strategy
  # choose_cards : Strategy Turn -> ListOf-Card
  def choose_cards(turn, player)
    stack = turn.turn_stack_inspect
    complementable = player.player_hand.complementable

    possible = []
    complementable.each{|x|
      possible << stack.detect {|y| y.cards_have_same_name?(x.squadron_first_aircraft)}
    }

    index = stack.index(possible.first)
    index += 1
    
    if index.nil? && turn.turn_card_on_deck?
      Array.new.push(turn.turn_get_a_card_from_deck)
    elsif !index.nil?
      turn.turn_get_cards_from_stack(index)
    else
      num = rand(turn.turn_stack_inspect.size)
      num += 1
      turn.turn_get_cards_from_stack(num)
    end
  end

  # make_discards : Strategy Player ListOf-Squadron ListOf-Squadron -> ListOf-Squadron
  #
  # What squadrons can the user play? 
  def make_discards(player, list_of_allies, list_of_axis)
    complete_squads = player.player_hand.completes
    complement_squads = player.player_hand.complementable
    wildcards = player.player_hand.wildcards

    # We need to make sure that we don't make attacks with squadrons that have already been used
    complete_squads = player.remove_used_squads(complete_squads, list_of_allies, list_of_axis)
    complement_squads = player.remove_used_squads(complement_squads, list_of_allies, list_of_axis)

    # Look through complement squadrons and go ahead and add
    # WildCards to them.
    complement_squads.each{|squadron|
      if wildcards.size > 0
        if wildcards.size >= 2 && squadron.list_of_cards.size == 1
          squadron.push!(wildcards.shift)
          squadron.push!(wildcards.shift)
        else
          squadron.push!(wildcards.shift)
        end
      end
    }
    
    # Combine the two lists of Squadrons
    all_squads = complete_squads.dup.concat(complement_squads)

    # Now we go through and make sure all the Squadrons
    # are complete and are bombers.
    all_squads.find_all {|squadron| squadron.squadron_complete? && squadron.squadron_bomber? }
  end
end
