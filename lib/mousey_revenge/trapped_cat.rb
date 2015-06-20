require 'celluloid/autostart'
require 'mousey_revenge/contracts/cat_like'

module MouseyRevenge
  class TrappedCat
    NAME = :trapped_cat
    SPRITE_PATH = '/../../assets/cat.png'
    SPRITE_PATH_ALT = '/../../assets/cheese.png'

    include Celluloid
    include Drawable
    include UUID

    attr_reader :cheese

    def initialize(grid:, position:, uuid: nil)
      @grid = grid
      @position = position
      @uuid = uuid
      calculate_uuid unless @uuid
    end

    def name
      NAME
    end

    def sprite_path
      cheese ? SPRITE_PATH_ALT : SPRITE_PATH
    end

    def calculate_move(*)
      current_actor
    end

    def calculate_move_and_sleep(*)
      sleep(1)
      calculate_move
    end

    def take_move(_move)
    end

    def symbolic_result
    end

    def immobile?
      true
    end

    def turn_into_cheese
      return if cheese
      @cheese = Cheese.new(grid: grid, position: position, uuid: uuid)
      reset_sprite
    end

    private

    def reset_sprite
      @sprite = nil
    end

    attr_reader :grid, :position
  end
end

MouseyRevenge::TrappedCat.implements(MouseyRevenge::Contracts::CatLike)
