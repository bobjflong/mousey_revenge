require 'gosu'
require 'mousey_revenge/drawable'

module MouseyRevenge
  # Resposible for handling the movement of a Mousey
  class Mouse
    NAME = :mouse
    SPRITE_PATH = '/../../assets/mouse.png'

    attr_reader :grid, :position, :score

    include Drawable

    def initialize(game:, grid:, position:)
      @grid = grid
      @position = position
      game.subscribe(self)
    end

    def name
      NAME
    end

    def update(params)
      direction = parse(params)
      return unless direction
      move_to_new_position(direction)
    rescue OccupiedError
      try_to_shift_blocks(direction)
      try_to_eat_cheese(direction)
      move_to_new_position(direction) rescue OccupiedError
    end

    private

    def parse(params)
      %i(right left up down).each do |dir|
        return dir if params.fetch(dir, false)
      end
      nil
    end

    def try_to_eat_cheese(direction)
      cheese_x = position_x + Math.x_off(direction)
      cheese_y = position_y + Math.y_off(direction)
      possibly_cheese = @grid.get(x: cheese_x, y: cheese_y)
      return unless possibly_cheese && possibly_cheese.respond_to?(:edible?)
      return unless possibly_cheese.edible?
      eat(x: cheese_x, y: cheese_y)
    end

    def eat(x:, y:)
      @grid.overwrite(x: x, y: y, value: nil)
      score!
    end

    def score!
      @score = (@score || 0) + 1
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

    def grid_shifter
      @grid_shifter ||= GridShifter.new(grid: grid)
    end
  end
end
