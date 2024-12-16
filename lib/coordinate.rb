class Coordinate
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end

  def display_coordinate
    return "#{(@y + 97).chr}#{8 - @x}"
  end
end