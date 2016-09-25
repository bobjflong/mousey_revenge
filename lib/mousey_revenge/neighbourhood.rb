module MouseyRevenge
  class NeighbourhoodPoint
    attr_reader :x, :y, :contents

    def initialize(x:, y:, contents:)
      @x = x
      @y = y
      @contents = contents
    end

    def to_h
      { x: x, y: y }
    end
  end

  # Responsible for calculating spaces around a grid point
  class Neighbourhood
    class << self
      def for(x:, y:, grid:, options: default_neighbourhood_options)
        results = Constants::DIRECTIONS.map do |direction|
          new_x = x + Math.x_off(direction)
          new_y = y + Math.y_off(direction)
          NeighbourhoodPoint.new(
            x: new_x,
            y: new_y,
            contents: grid.get(x: new_x, y: new_y)
          )
        end
        exclude_results(results, options)
      end

      # Remove certain results, controlled by
      # :excluding_out_of_bounds & excluding_occupied_spaces
      def exclude_results(results, options)
        exclude_oob = options.fetch(:excluding_out_of_bounds, false)
        exclude_occupied = options.fetch(:excluding_occupied_spaces, false)

        results = excluding_out_of_bounds(results) if exclude_oob
        results = excluding_occupied_spaces(results) if exclude_occupied
        results
      end

      def default_neighbourhood_options
        { excluding_out_of_bounds: true, excluding_occupied_spaces: true }
      end

      def excluding_out_of_bounds(results)
        results.find_all do |n|
          n.contents != MouseyRevenge::Grid::OUT_OF_BOUNDS
        end
      end

      def excluding_occupied_spaces(results, names = %i(cat mouse))
        results.find_all do |n|
          contents = n.contents
          cat_or_mouse = contents.respond_to?(:name) &&
            names.include?(contents.name)
          !contents || cat_or_mouse
        end
      end
    end
  end
end
