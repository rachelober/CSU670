# !/arch/unix/bin/ruby

# image_tests.rb
# All tests for the Image class

# Required files
require 'test/unit'
require 'code/image.rb'

class TestImage < Test::Unit::TestCase
    def setup
        @test_image = Image.new("question.gif")
    end

    def test_class
        assert_instance_of(Image, @test_image)
    end

    def test_file_name
        assert_instance_of(String, @test_image.file_name)
        assert_equal("question.gif", @test_image.file_name)
    end
end
