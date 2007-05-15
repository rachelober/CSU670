# !/arch/unix/bin/ruby

# image.rb
# First included in Project 3
# This file includes the Image class
# Card is dependant on this class

class Image
  attr_reader :file_name

  # Create a new Object of type Image
  def initialize(file_name)
    @file_name = file_name    # String
  end
end
