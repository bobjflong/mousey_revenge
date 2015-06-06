require 'gosu'
require 'pry'
module MouseyRevenge
  # Resposible for handling the movement of a Mousey
  class Mouse
    attr_reader :grid, :position

    def initialize(game:, grid:, position:)
      @grid = grid
      @position = position
      game.subscribe(self)
    end

    def name
      :mouse
    end

    def draw
      sprite.draw(position_x * CELL_SIZE, position_y * CELL_SIZE, 0)
    rescue MouseyRevenge::OccupiedError
      noop
    end

    def update(params)
      msg = nil
      msg = :shift_right if params.fetch(:right, false)
      msg = :shift_left if params.fetch(:left, false)
      msg = :shift_up if params.fetch(:up, false)
      msg = :shift_down if params.fetch(:down, false)
      return unless msg
      x, y = grid_shifter.send(msg, x: position_x, y: position_y)
      position[:x] = x
      position[:y] = y
    end

    def sprite
      @sprite ||= Gosu::Image.new(prefix + '/../../assets/mouse.png', tileable: true)
    end

    private

    def noop; end

    def prefix
      File.dirname(__FILE__)
    end

    def position_x
      position.fetch(:x)
    end

    def position_y
      position.fetch(:y)
    end

    def grid_shifter
      @grid_shifter ||= GridShifter.new(grid: grid)
    end
  end
end
