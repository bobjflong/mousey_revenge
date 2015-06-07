require 'ostruct'

module MouseyRevenge
  # GridDesigner's representation of a Block
  class BlockRepresentation
    def name
      :block
    end

    def can_slide?
      true
    end
  end

  # GridDesigner's representation of a Mouse
  class MouseRepresentation
    def name
      :mouse
    end
  end

  class UnknownGridItem < StandardError; end
  # Capable of taking string representations of Levels, and writing them
  # to grids
  class GridDesigner
    BLANK = '-'
    BLOCK = '+'
    MOUSE = 'm'

    attr_reader :grid, :mouse_location

    def initialize(grid)
      @grid = grid
      @mouse_location = [0, 0]
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
      BlockRepresentation.new
    end

    def new_mouse
      MouseRepresentation.new
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
END
  end
end
