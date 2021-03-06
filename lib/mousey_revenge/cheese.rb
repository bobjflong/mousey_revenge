require 'celluloid/autostart'
require 'mousey_revenge/contracts/cat_like'

module MouseyRevenge
  class Cheese
    NAME = :cheese
    SPRITE_PATH = '/../../assets/cheese.png'

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

    private

    attr_reader :grid, :position
  end
end

MouseyRevenge::Cheese.implements(MouseyRevenge::Contracts::CatLike)
