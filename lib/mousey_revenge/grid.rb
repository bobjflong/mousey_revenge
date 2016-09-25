require 'mousey_revenge/grid_enumerator'

module MouseyRevenge
  class OccupiedError < StandardError; end
  # Responsible for placing items on a grid, and fetching them back
  class Grid
    EMPTY = nil
    OUT_OF_BOUNDS = Object.new

    include GridEnumerator

    attr_reader :width, :height, :square_size

    def initialize(width:, height:, square_size:)
      @width = width
      @height = height
      @square_size = square_size
    end

    def place(x:, y:, value:)
      raise_occupied_error if get(x: x, y: y, default: nil)
      grid_data[x][y] = value
      self
    end

    def get(x:, y:, default: empty)
      return OUT_OF_BOUNDS if x < 0 || y < 0
      grid_data.fetch(x) { return OUT_OF_BOUNDS }
      result = grid_data.fetch(x).fetch(y) { return OUT_OF_BOUNDS }
      result || default
    end

    def delete(x:, y:)
      grid_data[x][y] = empty
    end

    # TODO: spec
    def overwrite(x:, y:, value:)
      delete(x: x, y: y)
      place(x: x, y: y, value: value)
    end

    def out_of_bounds?(x:, y:)
      get(x: x, y: y) == OUT_OF_BOUNDS
    end

    private

    def raise_occupied_error
      fail MouseyRevenge::OccupiedError # TODO: used for control flow
    end

    def grid_data
      @grid_data ||= [].tap do |grid_data|
        height.times do
          grid_data << [empty] * width
        end
      end
    end

    def empty
      EMPTY
    end
  end
end
