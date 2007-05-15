# !/arch/unix/bin/ruby

# stack_tests.rb
# Test cases for stack.rb

# Required files
require 'test/unit'
require 'code/card.rb'
require 'code/stack.rb'

class TestStack < Test::Unit::TestCase
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
        
        @stack1 = Stack.new([@air1])
        @stack2 = Stack.new([@air1, @air2])
        @stack3 = Stack.new([@keep1, @air2, @vic1])
    end

    def test_create
        assert_instance_of(Stack, Stack.create(@air1), "Stack.create failed")
    end

    def test_equal?
        assert_same(@stack1, @stack1, "Stack.equal? failed")
        assert_not_same(@stack1, @stack2, "Stack.equal? failed")
    end

    def test_depth
        assert_instance_of(Fixnum, @stack1.depth, "Stack.depth failed")
        assert_equal(1, @stack1.depth, "Stack.depth failed")
        
        assert_instance_of(Fixnum, @stack2.depth, "Stack.depth failed")
        assert_equal(2, @stack2.depth, "Stack.depth failed")
        
        assert_instance_of(Fixnum, @stack3.depth, "Stack.depth failed")
        assert_equal(3, @stack3.depth, "Stack.depth failed")
    end

    def test_push
        test_stack1 = Stack.new([@air1, @air2])
        test_stack2 = Stack.new([@air1, @air2, @keep1])
        test_stack3 = Stack.new([@air1, @vic1])
        
        assert_instance_of(Stack, @stack1.push(@air2), "Stack.push failed")
        assert_same(test_stack1, @stack1.push(@air2), "Stack.push failed")
        
        assert_instance_of(Stack, @stack2.push(@keep1), "Stack.push failed")
        assert_same(test_stack2, @stack2.push(@keep1), "Stack.push failed")
        
        assert_instance_of(Stack, @stack1.push(@vic1), "Stack.push failed")
        assert_same(test_stack3, @stack1.push(@vic1), "Stack.push failed")
    end

    def test_take
        test_stack1 = [@air1]
        test_stack2 = [@air1]
        test_stack3 = [@keep1, @air2]
        
        assert_instance_of(Array, @stack1.take(1), "Stack.take failed")
        assert_equal(test_stack1, @stack1.take(1), "Stack.take failed")
        
        assert_instance_of(Array, @stack2.take(1), "Stack.take failed")
        assert_equal(test_stack2, @stack2.take(1), "Stack.take failed")
        
        assert_instance_of(Array, @stack3.take(2), "Stack.take failed")
        assert_equal(test_stack3, @stack3.take(2), "Stack.take failed")
    end

    def test_pop!
        test_stack1 = Stack.new([])
        test_stack2 = Stack.new([@air2])
        test_stack3 = Stack.new([@vic1])
        
        assert_instance_of(Stack, @stack1.pop!(1), "Stack.pop! failed")
        assert_same(test_stack1, @stack1.pop!(1), "Stack.pop! failed")
        
        assert_instance_of(Stack, @stack2.pop!(1), "Stack.pop! failed")
        assert_same(test_stack2, @stack2.pop!(1), "Stack.pop! failed")
        
        assert_instance_of(Stack, @stack3.pop!(2), "Stack.pop! failed")
        assert_same(test_stack3, @stack3.pop!(2), "Stack.pop! failed")
    end
end
