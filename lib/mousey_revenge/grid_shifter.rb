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
        x_off = 0
        y_off = 0
        x_off = -1 if direction == :left
        x_off = +1 if direction == :right
        y_off = +1 if direction == :up
        y_off = -1 if direction == :down

        x_old = args.fetch(:x)
        y_old = args.fetch(:y)

        x = x_old + x_off
        y = y_old + y_off

        value = grid.get(x: x_old, y: y_old)
        grid.place(x: x, y: y, value: value)
        grid.delete(x: x_old, y: y_old)
      end
    end
  end
end
