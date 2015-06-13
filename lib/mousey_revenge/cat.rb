require 'celluloid/autostart'

module MouseyRevenge
  class Cat
    MAX_SLEEP = 5
    NAME = :cat
    SPRITE_PATH = '/../../assets/mouse.png'

    include Celluloid
    include Drawable

    def initialize(grid:, position:)
      @grid = grid
      @position = position
    end

    def name
      NAME
    end

    def calculate_move(target_position:, should_sleep: true)
      find_path(target_position)
      sleep(rand(MAX_SLEEP)) if should_sleep
      current_actor
    end

    def take_move(move)
      x, y = grid_shifter.send("shift_#{move}", x: position_x, y: position_y)
      @position = { x: x, y: y }
    end

    def symbolic_result
      return unless @result
      return :right if @result.fetch(0) > position_x
      return :left if @result.fetch(0) < position_x
      return :down if @result.fetch(1) > position_y
      return :up if @result.fetch(1) < position_y
    end

    def sprite
      @sprite ||= Gosu::Image.new(prefix + SPRITE_PATH, tileable: true)
    end

    def draw
      sprite.draw(position_x * CELL_SIZE, position_y * CELL_SIZE, 0)
    end

    private

    def grid_shifter
      MouseyRevenge::GridShifter.new(grid: grid)
    end

    def find_path(target_position)
      end_node = searcher.find_path_to(
        x: target_position.fetch(:x),
        y: target_position.fetch(:y)
      )
      @result = end_node.retrace.fetch(1, nil)
    end

    def searcher
      GridSearcher.new(grid: @grid)
        .start_at(x: position_x, y: position_y)
    end

    def position_x
      position.fetch(:x)
    end

    def position_y
      position.fetch(:y)
    end

    attr_reader :grid, :position
  end
end
