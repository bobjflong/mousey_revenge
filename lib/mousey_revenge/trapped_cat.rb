require 'celluloid/autostart'
require 'mousey_revenge/contracts/cat_like'

module MouseyRevenge
  class TrappedCat
    NAME = :trapped_cat
    SPRITE_PATH = '/../../assets/cat.png'

    include Celluloid
    include Drawable
    include UUID

    def initialize(grid:, position:, uuid: nil)
      @grid = grid
      @position = position
      @uuid = uuid
      calculate_uuid unless @uuid
    end

    def name
      NAME
    end

    def calculate_move(*)
      current_actor
    end

    def take_move(_move)
    end

    def symbolic_result
    end

    def trapped?
    end

    private

    attr_reader :grid, :position
  end
end

MouseyRevenge::TrappedCat.implements(MouseyRevenge::Contracts::CatLike)
