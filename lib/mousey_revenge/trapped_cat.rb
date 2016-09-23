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
    include EdibleSprite

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

    def calculate_move(target_position: nil, context:)
      return switch_to_normal_context(context: context) if free_moves?
      current_actor
    end

    def calculate_move_and_sleep(*args)
      sleep(1)
      calculate_move(*args)
    end

    def take_move(_move)
    end

    def symbolic_result
    end

    def immobile?
      true
    end

    private

    attr_reader :grid, :position

    def free_moves?
      !(Neighbourhood.for(
        x: position_x,
        y: position_y,
        grid: @grid
      ).empty?)
    end

    def switch_to_normal_context(context:)
      context.update_state(
        Cat.new(
          grid: @grid,
          position: position
        )
      )
      current_actor
    end
  end
end

MouseyRevenge::TrappedCat.implements(MouseyRevenge::Contracts::CatLike)
