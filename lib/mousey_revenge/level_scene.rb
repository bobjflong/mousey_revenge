module MouseyRevenge
  class LevelScene
    attr_reader :grid, :designer, :mouse

    extend Forwardable

    def_delegator :designer, :mouse_location

    def initialize(game:)
      @game = game
      @grid = Grid.new(width: GRID_WIDTH, height: GRID_HEIGHT, square_size: 10)
      set_up_base_sprites
      write_level_to_grid
      set_up_cat_group
      set_up_mouse(mouse_location)
    end

    def draw
      draw_grid
      draw_npcs
    end

    private

    def set_up_mouse(position)
      @mouse = MouseyRevenge::Mouse.new(
        game: @game,
        grid: @grid,
        position: position
      )
      grid.overwrite(
        x: position.fetch(:x),
        y: position.fetch(:y),
        value: @mouse
      )
    end

    def image_class
      Gosu::Image
    end

    def draw_grid
      GRID_WIDTH.times do |x|
        GRID_HEIGHT.times do |y|
          next if @grid.out_of_bounds?(x: x, y: y)
          cell = @grid.get(x: x, y: y)
          if cell && cell.name == :block
            @block.draw(x * CELL_SIZE, y * CELL_SIZE, 0)
          elsif cell.respond_to?(:draw)
            cell.draw
          else
            @background.draw(x * CELL_SIZE, y * CELL_SIZE, 0)
          end
        end
      end
    end

    def set_up_cat_group
      @cat_group = CatGroup.new(grid: @grid, positions: designer.cat_locations, game: @game)
      @cat_group.cats.each do |cat|
        @grid.overwrite(
          x: cat.position_x,
          y: cat.position_y,
          value: cat
        )
      end
    end

    def set_up_base_sprites
      @block = image_class.new(prefix + '/../../assets/tile.png', tileable: true)
      @background = image_class.new(prefix + '/../../assets/background.png', tileable: true)
    end

    def write_level_to_grid
      @designer = GridDesigner.new(@grid)
      @designer.write_to_grid(GridDesigner::LEVEL_1)
    end

    def draw_npcs
      @cat_group.draw
    end

    def prefix
      File.dirname(__FILE__)
    end

    def mouse_position
      mouse.position
    end

    def mouse_score
      mouse.score
    end
  end
end
