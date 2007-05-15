# !/arch/unix/bin/ruby

# administrator.rb
# First included in Project 7
# Includes class and methods for Administrator

# Required files
require 'code/turn.rb'


class Administrator
    def initialize
    end

    # Play one turn with the given player, using the current deck,
    # the current stack, and the list of of discarded squadrons from
    # all other players
    # play_one_turn : Player Deck Stack List of Discarded Squadrons ->*
    #   boolean?              ;; is the battle over?
    #   (or/c card? boolean?) ;; the return card (if any)
    #   (listof discard/c)    ;; the discarded squadrons 
    #   (listof attack?)      ;; the attacks 
    #   (or/c from-deck? from-stack?) ;; where were the cards taken from?
    def play_one_turn(player, deck, stack, discards)
        turn = Turn.create_turn(deck, stack, discards)
        done = player.player_take_turn(turn)
        battle_over = (player.player_hand.size == 0)
        if done.card.nil?
            return_card = false
        else
            return_card = done.card
        end
        list_of_discards =  done.discards
        list_of_attacks = done.attacks
        from_where = turn.turn_end
        return battle_over, return_card, list_of_discards, list_of_attacks, from_where
    end
end
