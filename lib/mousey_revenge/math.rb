module MouseyRevenge
  module Math
    class << self
      def x_off(direction)
        return -1 if direction == :left
        return +1 if direction == :right
        0
      end

      def y_off(direction)
        return +1 if direction == :down
        return -1 if direction == :up
        0
      end
    end
  end
end
