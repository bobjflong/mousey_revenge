require 'lawyer'

module MouseyRevenge
  module Contracts
    # Interface for a cat-like Object
    # eg. Cat, TrappedCat, Cheese (cats turn into cheese when vanquished)
    class CatLike < Lawyer::Contract
      # Expectations for drawing
      confirm :draw
      confirm :sprite
      confirm :prefix
      confirm :position_x
      confirm :position_y

      confirm :name
      confirm :calculate_move
      confirm :calculate_move_and_sleep
      confirm :take_move
      confirm :symbolic_result
      confirm :immobile?
    end
  end
end
