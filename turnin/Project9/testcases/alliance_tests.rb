# !/arch/unix/bin/ruby

# alliance_tests.rb
# All tests for the Alliance class

# Required files
require 'test/unit'
require 'code/alliance.rb'

class TestAlliance < Test::Unit::TestCase
    def setup
        @test_axis = Axis.new
        @test_allies = Allies.new
    end

    def test_class
        assert_kind_of(Alliance, @test_axis)
        assert_instance_of(Axis, @test_axis)

        assert_kind_of(Alliance, @test_allies)
        assert_instance_of(Allies, @test_allies)
    end
end
