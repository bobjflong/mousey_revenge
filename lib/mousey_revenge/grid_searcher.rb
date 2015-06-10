require 'pqueue'

module MouseyRevenge
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
        current = frontier.pop
        return current if current == @goal
        neighbours = Neighbourhood.for(x: current.x, y: current.y, grid: grid)
        neighbours.each do |next_visit|
          new_cost = cost_so_far.fetch([x, y], 0) + cost(
            current: current,
            x: next_visit.x,
            y: next_visit.y
          )
          priority = new_cost + heuristic(@goal, next_visit)
          search_representation = SearchRepresentation.from_neighbourhood_representation(
            next_visit,
            priority,
            current
          )
          if (!cost_so_far.include?([search_representation.x, search_representation.y])) || new_cost < cost_so_far.fetch([search_representation.x, search_representation.y], 0)
            cost_so_far[[search_representation.x, search_representation.y]] = new_cost
            frontier.push(search_representation)
            came_from[[search_representation.x, search_representation.y]] = current
          end
        end
      end
    end

    private

    def heuristic(goal, next_visit)
      (goal.x - next_visit.x).abs + (goal.y - next_visit.y).abs

    end

    def cost(current:, x:, y:)
      return 1 if current.x < x
      return 1 if current.y < y
      2
    end

    attr_accessor :came_from, :cost_so_far, :frontier
  end
end
