# !arch/unix/bin/ruby

# run_player_gui.rb
# First included in Project 8
# Runs test code to run the Player GUI for one turn

# Required files
require 'code/player.rb'
require 'code/deck.rb'
require 'code/squadron.rb'
require 'code/stack.rb'
require 'code/turn.rb'

axis = Axis.new
allies = Allies.new
fighter = Fighter.new
bomber = Bomber.new

# Cards
@air1 = Aircraft.new(Image.new("question.gif"), "Baku Geki KI-99", axis, bomber, 1)
@air2 = Aircraft.new(Image.new("question.gif"), "Baku Geki KI-99", axis, bomber, 2)
@air3 = Aircraft.new(Image.new("question.gif"), "Baku Geki KI-99", axis, bomber, 3)
@air4 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", allies, fighter, 1)
@air5 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", allies, fighter, 2)
@air6 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", allies, fighter, 3)
@air7 = Aircraft.new(Image.new("Dornier Do 26.gif"), "Dornier Do 26", axis, bomber, 1)
@air8 = Aircraft.new(Image.new("Dornier Do 26.gif"), "Dornier Do 26", axis, bomber, 2)
@air9 = Aircraft.new(Image.new("Dornier Do 26.gif"), "Dornier Do 26", axis, bomber, 3)
@air10 = Aircraft.new(Image.new("Brewster F2A-3.gif"), "Brewster F2A-3", allies, fighter, 1)
@air11 = Aircraft.new(Image.new("Brewster F2A-3.gif"), "Brewster F2A-3", allies, fighter, 2)
@air12 = Aircraft.new(Image.new("Brewster F2A-3.gif"), "Brewster F2A-3", allies, fighter, 3)
@air13 = Aircraft.new(Image.new("Bristol Blenheim.gif"), "Bristol Blenheim", allies, bomber, 1)
@air14 = Aircraft.new(Image.new("Bristol Blenheim.gif"), "Bristol Blenheim", allies, bomber, 2)
@air15 = Aircraft.new(Image.new("Bristol Blenheim.gif"), "Bristol Blenheim", allies, bomber, 3)
@keep1 = Keepem.new(Image.new("keepem.gif"), 1)
@keep2 = Keepem.new(Image.new("keepem.gif"), 2)
@keep3 = Keepem.new(Image.new("keepem.gif"), 3)
@keep4 = Keepem.new(Image.new("keepem.gif"), 4)
@keep5 = Keepem.new(Image.new("keepem.gif"), 5)
@keep6 = Keepem.new(Image.new("keepem.gif"), 6)
@vic1 = Victory.new(Image.new("victory.gif"))

player = Player.create("God", true)

player.player_first_hand([@air1, @air2, @air3, @air4, @air5, @air6, @air13, @air14])
sleep(15)

deck = Deck.list_to_deck([@air10])
stack = Stack.create(@air10)
list_of_squads = [Squadron.new([@air7, @air8, @air9])]
example_turn = Turn.new(deck, stack, list_of_squads)
player.player_take_turn(example_turn)
sleep(20)
