# !/arch/unix/bin/ruby

# stack_tests.rb
# Test cases for stack.rb

# Required files
require 'test/unit'
require 'code/card.rb'
require 'code/stack.rb'

class TestStack < Test::Unit::TestCase
    def setup
        allies = Allies.new
        axis = Axis.new
        fighter = Fighter.new
        bomber = Bomber.new
        
        @air1 = Aircraft.new(Image.new("Baku Geki KI-99.gif"), "Baku Geki KI-99", axis, bomber, 1)
        @air2 = Aircraft.new(Image.new("Baku Geki KI-99.gif"), "Baku Geki KI-99", axis, bomber, 2)
        @air3 = Aircraft.new(Image.new("Baku Geki KI-99.gif"), "Baku Geki KI-99", axis, bomber, 3)
        @air4 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", allies, fighter, 1)
        @air5 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", allies, fighter, 2)
        @air6 = Aircraft.new(Image.new("Dornier Do 26.gif"), "Dornier Do 26", axis, bomber, 1)
        @keep1 = Keepem.new(Image.new("keepem.gif"), 1)
        @keep2 = Keepem.new(Image.new("keepem.gif"), 2)
        @keep3 = Keepem.new(Image.new("keepem.gif"), 3)
        @vic1 = Victory.new(Image.new("victory.gif"))
        
        @stack1 = Stack.create(@air1)
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

    def test_comparable
        test_stack = Stack.new([@air2, @air1])
        assert(@stack1 < @stack2)
        assert(@stack2 < test_stack)
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
        test_stack1 = Stack.new([@air2, @air1])
        test_stack2 = Stack.new([@keep1, @air1, @air2])
        test_stack3 = Stack.new([@vic1, @air1])
        
        assert_instance_of(Stack, @stack1.push(@air2), "Stack.push failed")
        assert_same(test_stack1, @stack1.push(@air2), "Stack.push failed")
        
        assert_instance_of(Stack, @stack2.push(@keep1), "Stack.push failed")
        assert_same(test_stack2, @stack2.push(@keep1), "Stack.push failed")
        
        assert_instance_of(Stack, @stack1.push(@vic1), "Stack.push failed")
        assert_same(test_stack3, @stack1.push(@vic1), "Stack.push failed")
    end

    def test_take
        stack1 = Stack.new([@air2, @air1, @keep1, @keep2, @keep3])
        stack2 = Stack.new([@keep1, @air5, @air1, @vic1, @air2])
        stack3 = Stack.new([@vic1, @air1])
        
        test_stack1 = [@air2, @air1, @keep1]
        test_stack2 = [@keep1, @air5, @air1, @vic1, @air2]
        test_stack3 = [@vic1, @air1]
        
        assert_instance_of(Array, stack1.take(3), "Stack.take failed")
        assert_equal(test_stack1, stack1.take(3), "Stack.take failed")
        
        assert_instance_of(Array, stack2.take(5), "Stack.take failed")
        assert_equal(test_stack2, stack2.take(5), "Stack.take failed")
        
        assert_instance_of(Array, stack3.take(2), "Stack.take failed")
        assert_equal(test_stack3, stack3.take(2), "Stack.take failed")
    end

    def test_pop!
        stack1 = Stack.new([@air2, @air1, @keep1, @keep2, @keep3])
        stack2 = Stack.new([@keep1, @air5, @air1, @vic1, @air2])
        stack3 = Stack.new([@vic1, @air1])
        
        test_stack1 = Stack.new([@air1, @keep1, @keep2, @keep3])
        test_stack2 = Stack.new([@air1, @vic1, @air2])
        test_stack3 = Stack.new([])
        
        assert_instance_of(Stack, stack1.pop!(1), "Stack.pop! failed")
        assert_same(test_stack1, stack1.pop!(1), "Stack.pop! failed")
        
        assert_instance_of(Stack, stack2.pop!(2), "Stack.pop! failed")
        assert_same(test_stack2, stack2.pop!(2), "Stack.pop! failed")
        
        assert_instance_of(Stack, stack3.pop!(2), "Stack.pop! failed")
        assert_same(test_stack3, stack3.pop!(2), "Stack.pop! failed")
    end

    def test_stack_to_xml
      document = Document.new
      stack = document.add_element "STACK"
      stack.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"1"}
      stack.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"2"}
      stack.add_element "AIRCRAFT", {"NAME"=>"Baku Geki KI-99", "TAG"=>"3"}
      stack.add_element "VICTORY"

      stack1 = Stack.new([@air1, @air2, @air3, @vic1])
      test_stack = stack1.stack_to_xml 
      assert_equal(stack.to_s, test_stack.to_s)
    end
end
