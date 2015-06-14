# NB: THIS CLASS IS A MESS
# Also it's untested
# I'm using it to scope out Gosu :)

require 'gosu'
require 'wisper'

module MouseyRevenge
  def self.display
    GridWindow.new.show
  end

  class GridWindow < Gosu::Window
    include Wisper::Publisher

    attr_reader :grid, :designer

    def initialize
      super(REAL_WIDTH, REAL_WIDTH)
      @block = Gosu::Image.new(prefix + '/../../assets/tile.png', tileable: true)
      @background = Gosu::Image.new(prefix + '/../../assets/background.png', tileable: true)

      @grid = Grid.new(width: GRID_WIDTH, height: GRID_HEIGHT, square_size: 10)
      @designer = GridDesigner.new(@grid)
      @designer.write_to_grid(GridDesigner::LEVEL_1)

      @cats = []

      set_up_mouse(@designer.mouse_location)
      set_up_cats(@designer.cat_locations)
      broadcast(:update, mouse_location: @mouse.position)
    end

    def update
      params = {
        right: Gosu.button_down?(Gosu::KbRight),
        left: Gosu.button_down?(Gosu::KbLeft),
        up: Gosu.button_down?(Gosu::KbUp),
        down: Gosu.button_down?(Gosu::KbDown),
        mouse_location: @mouse.position
      }
      broadcast(:update, params) if params != @last_params
      @last_params = params
    end

    def draw
      draw_grid
      draw_npcs
    end

    private

    def set_up_mouse(position)
      @mouse = MouseyRevenge::Mouse.new(
        game: self,
        grid: @grid,
        position: position
      )
      grid.overwrite(
        x: position.fetch(:x),
        y: position.fetch(:y),
        value: @mouse
      )
    end

    def set_up_cats(positions)
      @cat_group = CatGroup.new(grid: @grid, positions: positions, game: self)
      @cat_group.cats.each do |cat|
        @grid.overwrite(
          x: cat.position_x,
          y: cat.position_y,
          value: cat
        )
      end
    end

    def prefix
      File.dirname(__FILE__)
    end

    def draw_npcs
      @cat_group.draw
    end

    # TODO: do properly - this class should not have knowledge of sprites
    def draw_grid
      GRID_WIDTH.times do |x|
        GRID_HEIGHT.times do |y|
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
  end
end

MouseyRevenge.display
