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
      @cache = {}
      calculate_uuid
    end

    def name
      NAME
    end

    def calculate_move(target_position:, should_sleep: true)
      @result = nil
      result = find_cached_path(
        target_position: target_position,
        should_sleep: should_sleep
      )
      return result if result
      find_new_path(
        target_position: target_position,
        should_sleep: should_sleep
      )
    end

    def take_move(move)
      return noop unless move
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
      return unless result
      return :right if result.fetch(0) > position_x
      return :left if result.fetch(0) < position_x
      return :down if result.fetch(1) > position_y
      return :up if result.fetch(1) < position_y
    end

    private

    def noop
    end

    def find_new_path(target_position:, should_sleep: true)
      find_path(target_position)
      sleep(1) if should_sleep
      @previous_target = target_position.clone
      current_actor
    end

    def find_cached_path(target_position:, should_sleep:)
      target_x = target_position.fetch(:x)
      target_y = target_position.fetch(:y)
      cached_trail = @cache.fetch([target_x, target_y], nil)
      return nil unless cached_trail
      @result = cached_trail.shift
      @cache = { [target_x, target_y] => cached_trail }
      sleep(1) if should_sleep
      current_actor
    end

    def random_valid_move
      neighbour = Neighbourhood.for(
        x: position_x,
        y: position_y,
        grid: @grid
      ).sample
      return unless neighbour
      [neighbour.x, neighbour.y]
    end

    def grid_shifter
      MouseyRevenge::GridShifter.new(grid: grid)
    end

    def find_path(target_position)
      target_x = target_position.fetch(:x)
      target_y = target_position.fetch(:y)
      end_node = searcher.find_path_to(
        x: target_x,
        y: target_y
      )
      return nil unless end_node
      cached_trail = end_node.retrace
      cached_trail.shift # Delete the starting node
      @result = cached_trail.shift
      @cache = { [target_x, target_y] => cached_trail }
    end

    def searcher
      GridSearcher.new(grid: @grid)
        .start_at(x: position_x, y: position_y)
    end

    attr_reader :grid, :position
  end
end
