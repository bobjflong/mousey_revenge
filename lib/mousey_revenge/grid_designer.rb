require 'ostruct'

module MouseyRevenge
  def self.create_basic_sprite_class(representation_name, sprite_path = nil)
    created_class = Class.new do
      @@sprite_path = ""

      def name
        self.class.name.gsub(/Representation/,'').downcase.to_sym
      end

      def can_slide?
        name == :block
      end

      def draw(*args)
        sprite.draw(*args)
      end

      private

      def sprite
        return saved_sprite if saved_sprite
        self.class.class_variable_set(
          :@@sprite,
          image_class.new(prefix + self.class.class_variable_get(:@@sprite_path), tileable: true)
        )
      end

      def saved_sprite
        @saved_sprite ||= self.class.class_variable_get(:@@sprite)
      rescue NameError
        nil
      end

      def prefix
        File.dirname(__FILE__)
      end

      def image_class
        Gosu::Image
      end
    end
    created_class = Object.const_set("#{representation_name.capitalize}Representation", created_class)
    created_class.class_variable_set(:@@sprite_path, sprite_path)
  end

  create_basic_sprite_class('mouse')
  create_basic_sprite_class('cat')
  create_basic_sprite_class('block', '/../../assets/tile.png')
  create_basic_sprite_class('rock', '/../../assets/rock.png')

  class UnknownGridItem < StandardError; end
  # Capable of taking string representations of Levels, and writing them
  # to grids
  class GridDesigner
    BLANK = '-'
    BLOCK = '+'
    ROCK = 'r'
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
      return new_rock if chr == ROCK
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

    def new_rock
      @rock ||= RockRepresentation.new
    end

    def new_block
      @block ||= BlockRepresentation.new
    end

    def new_mouse
      MouseRepresentation.new
    end

    def new_cat
      CatRepresentation.new
    end

    LEVEL_1 = <<END
------------------------
--c----------------c----
------------------------
---++++++++-+++++++++---
---++++++++-+++++++++---
---+++r++++-+++++r+++---
---++++++++-+++++++++---
---++++++++-+++++++++---
---++++++++++++++++++---
---++++++++++++++++++---
---+++++--------+++++---
----------------+++++---
---+++++---m----+++++---
---+++++--------+++++---
---++++++++++++++++++---
---++++++++++++++++++---
---++++++++-+++++++++---
---++++++++-+++++++++---
---+++r++++-+++++r+++---
---++++++++-+++++++++---
---++++++++-+++++++++---
------------------------
------------------------
--c----------------c----
------------------------
END
  end
end
