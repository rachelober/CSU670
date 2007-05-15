# !/arch/unix/bin/ruby

# code.rb
# This file requires all the files for the code to excute
# ... and nothing much else.

# Required modules
require 'modules/dbc.rb'
require 'modules/rtparser.rb'
require 'rexml/document'
include REXML
require 'thwait'

# Structures we need
SquadronState = Struct.new( "SquadronState", :squadron, :owner, :attackable, :status )
PlayerState = Struct.new( "PlayerState", :name, :hand, :score, :status )

# Required files to execute code
require 'code/runtimeerror.rb'
require 'code/alliance.rb'
require 'code/category.rb'
require 'code/image.rb'
require 'code/card.rb'
require 'code/deck.rb'
require 'code/hand.rb'
require 'code/squadron.rb'
require 'code/stack.rb'
require 'code/turn.rb'
require 'code/player.rb'
require 'code/battle.rb'
require 'code/cheatadmin.rb'
require 'code/administrator.rb'
require 'code/xmlhelper.rb'
#require 'code/run_tournament.rb'
