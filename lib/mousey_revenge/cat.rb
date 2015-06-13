require 'celluloid/autostart'

module MouseyRevenge
  class Cat
    NAME = :cat
    SPRITE_PATH = '/../../assets/cat.png'

    include Celluloid
    include Drawable
    include UUID

    def initialize(grid:, position:)
      @grid = grid
      @position = position
      calculate_uuid
    end

    def name
      NAME
    end

    def calculate_move(target_position:, should_sleep: true)
      @result = nil
      find_path(target_position)
      sleep(1) if should_sleep
      current_actor
    end

    def take_move(move)
      begin
        x, y = grid_shifter.send(
          "shift_#{move}",
          x: position_x,
          y: position_y
        )
        @position = { x: x, y: y }
      rescue MouseyRevenge::OccupiedError
        noop
      end
    end

    def symbolic_result(result = @result)
      result ||= random_valid_move
      return :right if result.fetch(0) > position_x
      return :left if result.fetch(0) < position_x
      return :down if result.fetch(1) > position_y
      return :up if result.fetch(1) < position_y
    end

    private

    def noop
    end

    def random_valid_move
      neighbour = Neighbourhood.for(
        x: position_x,
        y: position_y,
        grid: @grid
      ).sample
      [neighbour.x, neighbour.y]
    end

    def grid_shifter
      MouseyRevenge::GridShifter.new(grid: grid)
    end

    def find_path(target_position)
      end_node = searcher.find_path_to(
        x: target_position.fetch(:x),
        y: target_position.fetch(:y)
      )
      return nil unless end_node
      @result = end_node.retrace.fetch(1, nil)
    end

    def searcher
      GridSearcher.new(grid: @grid)
        .start_at(x: position_x, y: position_y)
    end

    attr_reader :grid, :position
  end
end