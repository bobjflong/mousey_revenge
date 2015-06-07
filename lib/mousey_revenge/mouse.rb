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
    end

    # TODO: refactor this big method
    def update(params)
      msg = nil
      msg = :right if params.fetch(:right, false)
      msg = :left if params.fetch(:left, false)
      msg = :up if params.fetch(:up, false)
      msg = :down if params.fetch(:down, false)
      return unless msg
      x, y = grid_shifter.send("shift_#{msg}", x: position_x, y: position_y)
      position[:x] = x
      position[:y] = y
    rescue MouseyRevenge::OccupiedError
      try_to_shift_blocks(msg)
    end

    def sprite
      @sprite ||= Gosu::Image.new(prefix + '/../../assets/mouse.png', tileable: true)
    end

    private

    def try_to_shift_blocks(msg)
      return unless slider.send("can_slide_#{msg}?", x: position_x, y: position_y)
      slider.send("slide_#{msg}!", x: position_x, y: position_y)
    end

    def slider
      @slider ||= MouseyRevenge::GridSlider.new(grid: @grid)
    end

    def move_to_new_position
      grid_shifter.send(msg, x: position_x, y: position_y)
    end

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
