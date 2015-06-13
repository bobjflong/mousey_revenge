module MouseyRevenge
  DIRECTIONS = [:left, :right, :up, :down]

  GRID_WIDTH = 25
  GRID_HEIGHT = GRID_WIDTH
  CELL_SIZE = 25
  REAL_WIDTH = GRID_WIDTH * CELL_SIZE

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
require 'mousey_revenge/neighbourhood'
require 'mousey_revenge/grid_searcher'
require 'mousey_revenge/mouse'
require 'mousey_revenge/uuid'
require 'mousey_revenge/cat'
require 'mousey_revenge/cat_group'
