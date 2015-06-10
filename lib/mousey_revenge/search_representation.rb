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

    def retrace
      res = self
      chain = []
      loop do
        chain << [res.x, res.y]
        break unless res.parent
        res = res.parent
      end
      chain.reverse
    end
  end
end
