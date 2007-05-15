# !/arch/unix/bin/ruby

# image.rb
# First included in Project 3
# This file includes the Image class
# Card is dependant on this class

class Image
  include DesignByContract
  attr_reader :file_name

  # create : String -> Image
  #
  # Creates a new Object of type Image.
  def initialize(file_name)
    create(file_name)
  end

  # create : String -> Image
  #
  # Creates a new Object of type Image.
  pre(:create, "file_name needs to be a String.") {|file_name| file_name.instance_of?(String)}
  def create(file_name)
    @file_name = file_name    # String
  end
end
