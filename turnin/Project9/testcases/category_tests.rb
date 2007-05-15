# !/arch/unix/bin/ruby

# category_tests.rb
# All tests for the Category class

# Required files
require 'test/unit'
require 'code/category.rb'

class TestCategory < Test::Unit::TestCase
    def setup
        @test_fighter = Fighter.new()
        @test_bomber = Bomber.new()
    end

    def test_class
        assert_instance_of(Fighter, @test_fighter)
        assert_instance_of(Bomber, @test_bomber)
    end

    def test_value
        assert_kind_of(Integer, @test_fighter.value)
        assert_equal(5, @test_fighter.value)

        assert_kind_of(Integer, @test_bomber.value)
        assert_equal(10, @test_bomber.value)
    end

    def test_squadron_value
        assert_kind_of(Integer, @test_fighter.squadron_value)
        assert_equal(15, @test_fighter.squadron_value)

        assert_kind_of(Integer, @test_bomber.squadron_value)
        assert_equal(30, @test_bomber.squadron_value)
    end
end
