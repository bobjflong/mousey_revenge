module MouseyRevenge
  class PathFinder
    attr_reader :cache, :grid

    def initialize(cache = {}, grid)
      @cache = cache
      @grid = grid
    end

    def find_path(source_position:, target_position:)
      target_x = target_position.fetch(:x)
      target_y = target_position.fetch(:y)
      end_node = searcher(source_position).find_path_to(
        x: target_x,
        y: target_y
      )
      return nil unless end_node
      cached_trail = end_node.retrace
      cached_trail.shift # Delete the starting node
      result = cached_trail.shift
      @cache = { [target_x, target_y] => cached_trail }
      result
    end

    def find_cached_path(target_position:)
      target_x = target_position.fetch(:x)
      target_y = target_position.fetch(:y)
      cached_trail = cache.fetch([target_x, target_y], nil)
      return nil unless cached_trail
      result = cached_trail.shift
      @cache = { [target_x, target_y] => cached_trail }
      result
    end

    private

    def searcher(source_position)
      GridSearcher.new(grid: grid)
                  .start_at(
                    x: source_position.fetch(:x),
                    y: source_position.fetch(:y)
                  )
    end
  end
end
