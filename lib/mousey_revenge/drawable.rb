module MouseyRevenge
  module Drawable
    def draw(*)
      sprite.draw(position_x * Constants::CELL_SIZE, position_y * Constants::CELL_SIZE, 0)
    end

    def sprite
      sprite_path = if respond_to?(:sprite_path)
                      prefix + sprite_path
                    else
                      prefix + self.class.const_get(:SPRITE_PATH)
                    end
      @sprite ||= Gosu::Image.new(sprite_path, tileable: true)
    end

    def prefix
      File.dirname(__FILE__)
    end

    def position_x
      position.fetch(:x)
    end

    def position_y
      position.fetch(:y)
    end
  end
end
