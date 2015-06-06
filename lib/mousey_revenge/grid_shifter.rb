module MouseyRevenge
  # Responsible for shifting values one place around a given grid
  class GridShifter
    attr_reader :grid

    def initialize(grid:)
      @grid = grid
    end

    def shift_right(x:, y:)
      value = grid.get(x: x, y: y)
      grid.place(x: x + 1, y: y, value: value)
      grid.delete(x: x, y: y)
    end

    # Generates
    # shift_left ; shift_right ; shift_up ; shift_down
    DIRECTIONS.each do |direction|
      define_method "shift_#{direction}" do |args|
        x_old = args.fetch(:x)
        y_old = args.fetch(:y)

        x = x_old + MouseyRevenge::Math.x_off(direction)
        y = y_old + MouseyRevenge::Math.y_off(direction)

        value = grid.get(x: x_old, y: y_old)
        grid.place(x: x, y: y, value: value)
        grid.delete(x: x_old, y: y_old)
      end
    end
  end
end
