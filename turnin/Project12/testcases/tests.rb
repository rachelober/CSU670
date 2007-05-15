# !/arch/unix/bin/ruby

# tests.rb
# This file requires all the files for the tests to excute
# ... and nothing much else.

# Required modules
require 'modules/dbc.rb'
require 'modules/rtparser.rb'
require 'rexml/document'
include REXML
require 'thwait'

# Required files to execute tests
require 'code/runtimeerror.rb'
require 'testcases/alliance_tests.rb'
require 'testcases/category_tests.rb'
require 'testcases/image_tests.rb'
require 'testcases/card_tests.rb'
require 'testcases/stack_tests.rb'
require 'testcases/deck_tests.rb'
require 'testcases/squadron_tests.rb'
require 'testcases/hand_tests.rb'
require 'testcases/cardsfrom_tests.rb'
require 'testcases/turn_tests.rb'
require 'testcases/attack_tests.rb'
require 'testcases/done_tests.rb'
require 'testcases/strategy_tests.rb'
require 'testcases/player_tests.rb'
require 'testcases/cheatadmin_tests.rb'
require 'testcases/administrator_tests.rb'
require 'testcases/xmlhelper_tests.rb'
