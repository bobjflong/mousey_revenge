module MouseyRevenge
  # A representation of a grid node, for searching
  # it contains a cost, based on a search heuristic
  # and a parent for retracing successul paths
  class SearchRepresentation
    attr_reader :x, :y, :cost, :parent

    def self.from_neighbourhood_representation(neighbour, cost, parent)
      new(
        x: neighbour.x,
        y: neighbour.y,
        cost: cost,
        parent: parent
      )
    end

    def initialize(x:, y:, cost:, parent: nil)
      @x = x
      @y = y
      @cost = cost
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
