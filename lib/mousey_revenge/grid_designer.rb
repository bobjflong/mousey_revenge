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

  class CatRepresentation
    def name
      :cat
    end
  end

  class UnknownGridItem < StandardError; end
  # Capable of taking string representations of Levels, and writing them
  # to grids
  class GridDesigner
    BLANK = '-'
    BLOCK = '+'
    MOUSE = 'm'
    CAT = 'c'

    attr_reader :grid, :mouse_location, :cat_locations

    def initialize(grid)
      @grid = grid
      @mouse_location = [0, 0]
      @cat_locations = []
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
      if chr == CAT
        @cat_locations << { x: x, y: y }
        return new_cat
      end
      fail UnknownGridItem
    end

    def new_block
      BlockRepresentation.new
    end

    def new_mouse
      MouseRepresentation.new
    end

    def new_cat
      CatRepresentation.new
    end

    LEVEL_1 = <<END
------------------------
-------------------c----
--c---------------------
---++++++++++++++++++---
---++++++++++++++++++---
---++++++++++++++++++---
---++++++++++++++++++---
---++++++++++++++++++---
---++++++++++++++++++---
---++++++++++++++++++---
---+++++--------+++++---
----------------+++++---
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
----------------c-------
--c---------------------
------------------------
END
  end
end
