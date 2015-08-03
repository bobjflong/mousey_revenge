require 'mousey_revenge/score_drawer'

module MouseyRevenge
  class LevelScene
    attr_reader :grid, :designer, :mouse, :game

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
      draw_score
    end

    def mouse_position
      mouse.position
    end

    private

    def set_up_mouse(position)
      @mouse = MouseyRevenge::Mouse.new(
        game: game,
        grid: @grid,
        position: position
      )
      grid.overwrite(
        x: position.fetch(:x),
        y: position.fetch(:y),
        value: @mouse
      )
    end

    def draw_grid
      GRID_WIDTH.times do |x|
        GRID_HEIGHT.times do |y|
          next if @grid.out_of_bounds?(x: x, y: y)
          cell = @grid.get(x: x, y: y)
          # TODO: nope! this should not be here duplicated
          if cell.respond_to?(:draw)
            cell.draw(x * CELL_SIZE, y * CELL_SIZE, 0)
          else
            @background.draw(x * CELL_SIZE, y * CELL_SIZE, 0)
          end
        end
      end
    end

    def draw_score
      score_drawer.draw(score: mouse.score)
    end

    def set_up_cat_group
      @cat_group = CatGroup.new(grid: @grid, positions: designer.cat_locations, game: game)
      @cat_group.cats.each do |cat|
        @grid.overwrite(
          x: cat.position_x,
          y: cat.position_y,
          value: cat
        )
      end
    end

    def set_up_base_sprites
      @background = image_class.new(prefix + '/../../assets/background.png', tileable: true)
    end

    def image_class
      Gosu::Image
    end


    def write_level_to_grid
      @designer = GridDesigner.new(@grid)
      @designer.write_to_grid(GridDesigner::LEVEL_1)
    end

    def score_drawer
      @score_drawer ||= ScoreDrawer.new(game)
    end

    def prefix
      File.dirname(__FILE__)
    end
  end
end
