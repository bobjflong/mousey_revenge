module MouseyRevenge
  # Responsible for sliding multiple values around a grid at once
  class GridSlider
    attr_reader :grid

    def initialize(grid:)
      @grid = grid
    end

    # Generates can_slide_right? ; can_slide_left?
    # can_slide_up? ; can_slide_down?
    DIRECTIONS.each do |direction|
      define_method "can_slide_#{direction}?" do |args|
        x = args.fetch(:x)
        y = args.fetch(:y)
        msg = "enumerate_#{direction}_from"
        grid.send(msg, x: x, y: y).drop(1).each do |enum_value|
          value = enum_value.value
          return false if value_is_out_of_bounds?(value)
          return true unless value
          return false unless value_can_slide?(value)
        end
      end
    end

    # Generates slide_right! ; slide_left!
    # slide_down! ; slide_up!
    DIRECTIONS.each do |direction|
      define_method "slide_#{direction}!" do |args|
        msg = "enumerate_#{direction}_from"
        storage = nil
        x = args.fetch(:x)
        y = args.fetch(:y)
        snapshot = grid.send(msg, x: x, y: y).drop(1).each.to_a
        snapshot.each do |enum_value|
          break if enum_value && value_is_out_of_bounds?(enum_value.value)
          old_value = enum_value && enum_value.value
          if storage
            grid.overwrite(x: enum_value.x, y: enum_value.y, value: storage)
          else
            grid.delete(x: enum_value.x, y: enum_value.y)
          end
          break unless old_value
          storage = old_value
        end
      end
    end

    private

    def value_is_out_of_bounds?(value)
      value == Grid::OUT_OF_BOUNDS
    end

    def value_can_slide?(value)
      value.respond_to?(:can_slide?) && value.can_slide?
    end
  end
end
