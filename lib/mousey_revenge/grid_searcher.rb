require 'pqueue'

module MouseyRevenge
  # A representation of a grid node, for searching
  # it contains a priority, based on a search heuristic
  # and a parent for retracing successul paths
  class SearchRepresentation
    attr_reader :x, :y, :priority, :parent

    def self.from_neighbourhood_representation(neighbour, priority, parent)
      new(x: neighbour.x, y: neighbour.y, priority: priority, parent: parent)
    end

    def initialize(x:, y:, priority:, parent: nil)
      @x = x
      @y = y
      @priority = priority
      @parent = parent
    end

    def ==(other)
      x == other.x && y == other.y
    end
  end

  class GridSearcher
    attr_reader :grid, :start

    def initialize(grid:)
      @grid = grid
      @frontier = PQueue.new([]) { |a, b| a.priority > b.priority }
      @came_from = {}
      @cost_so_far = {}
    end

    def start_at(x:, y:)
      search_representation = SearchRepresentation.new(
        x: x,
        y: y,
        priority: 0
      )
      frontier << search_representation
      came_from[[x, y]] = nil
      cost_so_far[[x, y]] = 0
    end

    def find_path_to(x:, y:)
      @goal = SearchRepresentation.new(x: x, y: y, priority: 0)
      until frontier.empty?
        result = a_star_search
        return result if result
      end
    end

    private

    def a_star_search
      current = frontier.pop
      return current if current == @goal
      neighbours = Neighbourhood.for(x: current.x, y: current.y, grid: grid)
      neighbours.each { |neighbour| examine_neighbour(current, neighbour) }
      nil
    end

    def examine_neighbour(current, neighbour)
      new_cost = accumulated_cost(current, neighbour)
      priority = new_cost + heuristic(@goal, neighbour)
      search_representation = from_neighbour(neighbour, priority, current)

      return unless should_expand_frontier?(new_cost, search_representation)
      update_cost(new_cost, search_representation)
      frontier.push(search_representation)
      maintain_visited_list(current, search_representation)
    end

    def from_neighbour(neighbour, priority, parent)
      SearchRepresentation.from_neighbourhood_representation(
        neighbour,
        priority,
        parent
      )
    end

    def update_cost(new_cost, search_representation)
      cost_so_far[[search_representation.x, search_representation.y]] = new_cost
    end

    def maintain_visited_list(current, search_representation)
      came_from[[search_representation.x, search_representation.y]] = current
    end

    def accumulated_cost(current, neighbour)
      cost_so_far.fetch([current.x, current.y], 0) + cost(
        current: current,
        x: neighbour.x,
        y: neighbour.y
      )
    end

    def should_expand_frontier?(new_cost, search_representation)
      hash_key = [search_representation.x, search_representation.y]

      !cost_so_far.include?(hash_key) ||
        new_cost < cost_so_far.fetch(hash_key, 0)
    end

    def heuristic(goal, neighbour)
      (goal.x - neighbour.x).abs + (goal.y - neighbour.y).abs

    end

    def cost(current:, x:, y:)
      return 1 if current.x < x
      return 1 if current.y < y
      2
    end

    attr_accessor :came_from, :cost_so_far, :frontier
  end
end
