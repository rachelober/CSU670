# !/arch/unix/bin/ruby

# deck_tests.rb
# Test cases for deck.rb

# Required files
require 'test/unit'
require 'code/deck.rb'
require 'code/card.rb'

class TestDeck < Test::Unit::TestCase
    def setup
        image = Image.new("filename.jpg")
        allies = Allies.new
        axis = Axis.new
        fighter = Fighter.new
        bomber = Bomber.new
        
        @air1 = Aircraft.new(image, "Baku Geki KI-99", axis, bomber, 1)
        @air2 = Aircraft.new(image, "Baku Geki KI-99", axis, bomber, 2)
        @air3 = Aircraft.new(image, "Baku Geki KI-99", axis, bomber, 3)
        @air4 = Aircraft.new(image, "Bell P-39D", allies, fighter, 1)
        @air5 = Aircraft.new(image, "Bell P-39D", allies, fighter, 2)
        @air6 = Aircraft.new(image, "Dornier Do 26", axis, bomber, 1)
        @keep1 = Keepem.new(image, 1)
        @keep2 = Keepem.new(image, 2)
        @vic1 = Victory.new(image)

        @deck_empty = Deck.list_to_deck(Array.new())
        @deck_full = Deck.create
        @deck_shuffle = Deck.create
        @deck_shuffle.shuffle
    end

    def test_create
        assert_instance_of(Deck, Deck.create, "Deck.create failed")
    end
    
    def test_equal?
        assert_same(@deck_full, @deck_full, "Deck.equal? failed")
        assert_not_same(@deck_full, @deck_empty, "Deck.equal? failed")
    end
    
    def test_shuffle
        deck_shuffle2 = Deck.create
        deck_shuffle2.shuffle
        
        assert_instance_of(Deck, @deck_shuffle, "Deck.shuffle failed")
        assert_not_same(@deck_full, @deck_shuffle, "Deck.shuffle failed")
        assert_not_same(@deck_shuffle, deck_shuffle2, "Deck.shuffle failed")
    end
    
    def test_empty?
        assert_instance_of(TrueClass, @deck_empty.empty?, "Deck.empty? failed")
        assert_instance_of(FalseClass, @deck_full.empty?, "Deck.empty? failed")

        assert(@deck_empty.empty?, "Deck.empty? failed")
        assert_equal(false, @deck_full.empty?, "Deck.empty? failed")
    end
    
    def test_take
        assert(@deck_full.take.cards_have_same_name?(@air1), "Deck.take failed")
    end
    
    def test_pop
        deck_minus_1 = Deck.create
        list_minus_1 = deck_minus_1.deck_to_list
        list_minus_1.delete_at(0)
        deck_minus_1 = Deck.list_to_deck(list_minus_1)
        
        assert_instance_of(Deck, @deck_full.pop, "Deck.pop 1 failed")
        assert_not_same(@deck_full, @deck_full.pop, "Deck.pop 2 failed")
        assert_same(deck_minus_1, @deck_full.pop, "Deck.pop 3 failed")
    end
    
    def test_deck_to_list
        assert_instance_of(Array, @deck_full.deck_to_list, "Deck.deck_to_list failed")
        assert_same(@deck_full.list_of_cards, @deck_full.deck_to_list, "Deck.deck_to_list failed")
    end

    def test_list_to_deck
        list = [@air1, @air2, @air3]
        deck = Deck.new(list)
        
        assert_instance_of(Deck, Deck.list_to_deck(list), "Deck.list_to_deck failed")
        assert_same(deck, Deck.list_to_deck(list), "Deck.list_to_deck failed") 
    end
end
