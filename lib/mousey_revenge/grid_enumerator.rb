module MouseyRevenge
  # Capable of producing an enumerator on a grid for a given direction
  module GridEnumerator
    class GridEnumValue
      attr_reader :x, :y, :value

      def initialize(x, y, value)
        @x = x
        @y = y
        @value = value
      end
    end

    # Generates enumerate_right_from ; enumerate_left_from
    # enumerate_up_from ; enumerate_down_from
    DIRECTIONS.each do |direction|
      define_method "enumerate_#{direction}_from" do |args|
        x = args.fetch(:x)
        y = args.fetch(:y)

        yield Grid::OUT_OF_BOUNDS if out_of_bounds?(x: x, y: y)

        current_value = get(x: x, y: y)

        Enumerator.new do |e|
          loop do
            e.yield GridEnumValue.new(x, y, current_value)
            x += MouseyRevenge::Math.x_off(direction)
            y += MouseyRevenge::Math.y_off(direction)
            if out_of_bounds?(x: x, y: y)
              e.yield GridEnumValue.new(x, y, Grid::OUT_OF_BOUNDS)
              break
            else
              current_value = get(x: x, y: y)
            end
          end
        end
      end
    end
  end
end
