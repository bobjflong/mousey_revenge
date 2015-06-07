require 'ostruct'

module MouseyRevenge
  class UnknownGridItem < StandardError; end
  class GridDesigner
    BLANK = '-'
    BLOCK = '+'
    MOUSE = 'm'

    attr_reader :grid, :mouse_location

    def initialize(grid)
      @grid = grid
      @mouse_location = [0,0]
    end

    def write_to_grid(level)
      lines = level.split("\n")
      lines.each_with_index do |line, y|
        line.split('').each_with_index do |chr, x|
          grid.overwrite(x: x, y: y, value: translate(x, y, chr))
        end
      end
    end

    private

    def translate(x, y, chr)
      return nil if chr == BLANK
      return new_block if chr == BLOCK
      if chr == MOUSE
        @mouse_location = { x: x, y: y }
        return new_mouse
      end
      fail UnknownGridItem
    end

    def new_block
      # TODO: models
      OpenStruct.new(name: :block, can_slide?: true)
    end

    def new_mouse
      OpenStruct.new(name: :mouse)
    end

    LEVEL_1 = <<END
------------------------
------------------------
------------------------
---++++++++++++++++++---
---++++++++++++++++++---
---++++++++++++++++++---
---++++++++++++++++++---
---++++++++++++++++++---
---++++++++++++++++++---
---++++++++++++++++++---
---+++++--------+++++---
---+++++--------+++++---
---+++++---m----+++++---
---+++++--------+++++---
---++++++++++++++++++---
---++++++++++++++++++---
---++++++++++++++++++---
---++++++++++++++++++---
---++++++++++++++++++---
---++++++++++++++++++---
---++++++++++++++++++---
------------------------
------------------------
------------------------
------------------------
-------------------------
END
  end
end
