require 'gosu'
require 'pry'
module MouseyRevenge
  # Resposible for handling the movement of a Mousey
  class Mouse
    NAME = :mouse
    SPRITE_PATH = '/../../assets/mouse.png'

    attr_reader :grid, :position

    def initialize(game:, grid:, position:)
      @grid = grid
      @position = position
      game.subscribe(self)
    end

    def name
      NAME
    end

    def draw
      sprite.draw(position_x * CELL_SIZE, position_y * CELL_SIZE, 0)
    end

    # TODO: refactor this big method
    def update(params)
      direction = parse(params)
      return unless direction
      move_to_new_position(direction)
    rescue MouseyRevenge::OccupiedError
      try_to_shift_blocks(direction)
    end

    def sprite
      @sprite ||= Gosu::Image.new(prefix + SPRITE_PATH, tileable: true)
    end

    private

    def parse(params)
      %i(right left up down).each { |dir| return dir if params.fetch(dir, false) }
      nil
    end

    def try_to_shift_blocks(msg)
      return unless slider.send(
        "can_slide_#{msg}?",
        x: position_x,
        y: position_y
      )
      slider.send("slide_#{msg}!", x: position_x, y: position_y)
    end

    def slider
      @slider ||= MouseyRevenge::GridSlider.new(grid: @grid)
    end

    def move_to_new_position(msg)
      x, y = grid_shifter.send("shift_#{msg}", x: position_x, y: position_y)
      record_updated_position(x, y)
    end

    def record_updated_position(x, y)
      position[:x] = x
      position[:y] = y
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
