module MouseyRevenge
  DIRECTIONS = [:left, :right, :up, :down]

  module Math
    class << self
      def x_off(direction)
        return -1 if direction == :left
        return +1 if direction == :right
        0
      end

      def y_off(direction)
        return +1 if direction == :down
        return -1 if direction == :up
        0
      end
    end
  end
end

require 'mousey_revenge/grid'
require 'mousey_revenge/grid_shifter'
require 'mousey_revenge/grid_slider'
require 'mousey_revenge/grid_designer'
