
module MouseyRevenge
  module EdibleSprite
    SPRITE_PATH_ALT = '/../../assets/cheese.png'

    attr_reader :cheese

    def sprite_path
      cheese ? SPRITE_PATH_ALT : self.class.const_get(:SPRITE_PATH)
    end

    def turn_into_cheese
      return if cheese
      @cheese = Cheese.new(grid: grid, position: position, uuid: uuid)
      reset_sprite
    end

    def reset_sprite
      @sprite = nil
    end

    def edible?
      cheese
    end
  end
end
