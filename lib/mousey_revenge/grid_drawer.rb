require 'gosu'

module MouseyRevenge
  def self.display
    GridWindow.new.show
  end

  class GridWindow < Gosu::Window

    GRID_WIDTH = 40
    CELL_SIZE = 10
    REAL_WIDTH = GRID_WIDTH * CELL_SIZE

    def initialize
      super(REAL_WIDTH, REAL_WIDTH)
      @block = Gosu::Image.new(prefix + '/../../assets/tile.png')
      @background = Gosu::Image.new(prefix + '/../../assets/background.png', tileable: true)

      @grid = Grid.new(width: 50, height: 50, square_size: 10)
      @designer = GridDesigner.new(@grid)
      @designer.write_to_grid(GridDesigner::LEVEL_1)
    end

    def update

    end

    def draw
      draw_grid
    end

    private


    def prefix
      File.dirname(__FILE__)
    end

    # TODO: do properly - this class should not have knowledge of sprites
    def draw_grid
      GRID_WIDTH.times do |x|
        GRID_WIDTH.times do |y|
          cell = @grid.get(x: x, y: y)
          if cell && cell.name == :block
            @block.draw(x * CELL_SIZE, y * CELL_SIZE, 0)
          else
            @background.draw(x * CELL_SIZE, y * CELL_SIZE, 0)
          end
        end
      end
    end
  end
end

MouseyRevenge.display
