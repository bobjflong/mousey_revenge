module MouseyRevenge
  class Hunter
    attr_reader :position_x, :position_y, :grid

    def initialize(position:, grid: grid)
      @position_x = position.fetch(:x)
      @position_y = position.fetch(:y)
      @grid = grid
    end

    def attack_mouse_if_possible
      neighbours = Neighbourhood.for(
        x: position_x,
        y: position_y,
        grid: @grid,
        options: { excluding_occupied_spaces: false }
      )
      mouse_in_neighbourhood(neighbours)
    end

    def mouse_in_neighbourhood(neighbours)
      neighbours.find do |neighbour|
        neighbour.contents.is_a?(MouseyRevenge::Mouse)
      end
    end
  end
end
