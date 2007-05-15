# !arch/unix/bin/ruby

# observer_player.rb
# First included in Project 8
# Run all visualization for the Player class

# required files
require 'tk'
require 'code/player.rb'
require 'code/squadron.rb'

# Constructs ObserverPlayer class
# Observes the Player

class ObserverPlayer
  def initialize(player)
    @player = player    # Player
    self.subscribe
    @root = TkRoot.new() { title "Squadron Scramble"}
    @main_frame = TkFrame.new(@root).pack('padx'=>10, 'pady'=>10)
  end
  
  # update : ObserverPlayer -> ObserverPlayer
  # Retrieves state information from Player
  def update
    @player = @player.get_state
    self.run
    self
  end

  # subscribe : ObserverPlayer -> ObserverPlayer
  # Adds this ObserverPlayer to the given Player's ListOf-ObserverPlayer
  def subscribe
      @player.subscribe(self)
  end

  # run : ->
  # Runs all the Tk commands we've set up
  def run
      @main_frame.destroy
      @main_frame = TkFrame.new(@root).pack('padx'=>10, 'pady'=>10)
      self.make_header
      self.make_hand
      self.make_discards
      Thread.new{Tk.mainloop()}
  end

  # make_header
  # Creates the header for the GUI
  def make_header
     name = @player.player_name
     score = @player.player_score
     label = TkLabel.new(@main_frame) { text "Player: #{name}   Score: #{score}" }
     label.pack("side"=>"top")
  end

  # make_hand
  # Creates the main frame for hand
  def make_hand
      hand_frame = TkFrame.new(@main_frame){relief 'raised'; border 1}.pack('padx'=>5, 'pady'=>5, 'side'=>'left')
      hand_label = TkLabel.new(hand_frame) { text "Hand" }
      hand_label.pack('side'=>'top')
      
      # Wildcards
      wildcards = @player.player_hand.wildcards
      # All the cards in the hand minus wildcards (Duplicated to not cause side effects)
      temp_list = @player.player_hand.minus(wildcards).hand_to_list.dup
      # Building a list of squadrons without wildcards
      list_of_squadrons = Array.new()

      list_of_squadrons = temp_list.map do |card|
          card.name
      end.uniq.map do |name|
          Squadron.new(temp_list.find_all {|card| card.name == name})
      end

      list_of_squadrons.each{|x|
        squadron_frame = TkFrame.new(hand_frame){relief 'raised'; border 1}.pack('padx'=>5, 'pady'=>5, 'side'=>'top')
        tags, alliance, category, name = self.make_squadron(x)
        squadron_label = TkLabel.new(squadron_frame) { text tags }.pack('side'=>'left')
        squadron_status = TkLabel.new(squadron_frame) {text "#{name}\n#{alliance}\n#{category}"}.pack('side'=>'left')
        
        card_image, card_name = self.make_card(x.squadron_first_aircraft)
        card_image = 'aircrafts/' + card_image
        card = TkPhotoImage.new('file'=>card_image)
        card_label = TkLabel.new(squadron_frame) { image card }.pack("anchor"=>"w")
      }
  end

  # make_discards
  # Creates the main frame for dicards
  def make_discards
      discards_frame = TkFrame.new(@main_frame){relief 'raised'; border 1}.pack('padx'=>5, 'pady'=>5, 'side'=>"left")
      discards_label = TkLabel.new(discards_frame) { text "Discards"}
      discards_label.pack("side"=>"top")

      all_discarded_cards = @player.discards.concat(@player.shot_down)
      all_discarded_cards.each{|x|
        squadron_frame = TkFrame.new(discards_frame){relief 'raised'; border 1}.pack('padx'=>5, 'pady'=>5, 'side'=>'top')
        tags, alliance, category, name = self.make_squadron(x)
        squadron_label = TkLabel.new(squadron_frame) { text tags }.pack('side'=>'left')
        squadron_status = TkLabel.new(squadron_frame) {text "#{name}\n#{alliance}\n#{category}"}.pack('side'=>'left')
        
        card_image, card_name = self.make_card(x.squadron_first_aircraft)
        card_image = 'aircrafts/' + card_image
        card = TkPhotoImage.new('file'=>card_image)
        card_label = TkLabel.new(squadron_frame) { image card }.pack("anchor"=>"w")
      }
  end

  # make_card : Card ->
  # Creates an individual card on the GUI
  def make_card(card)
      image = card.image.file_name
      name = card.name
      return image, name
  end

  # make_squadron : Squadron ->
  # Creates a Squadron on the GUI from a Squadron Object
  def make_squadron(squadron)
    name = squadron.squadron_name
    tags = []
    squadron.list_of_cards.each{|x|
        tags << x.tag
    }
    tags.sort! 
    if squadron.squadron_alliance.class == Axis
        alliance = "AXIS"
    elsif squadron.squadron_alliance.class == Allies
        alliance = "ALLIANCE"
    end
    if squadron.squadron_bomber?
        category = "BOMBER"
    elsif squadron.squadron_fighter?
        category = "FIGHTER"
    end
    return tags, alliance, category, name
  end
end
