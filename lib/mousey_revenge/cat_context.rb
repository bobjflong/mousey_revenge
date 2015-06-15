require 'mousey_revenge/contracts/cat_like'

module MouseyRevenge
  class CatContext
    attr_reader :state

    extend Forwardable

    def_delegator :state, :draw
    def_delegator :state, :sprite
    def_delegator :state, :prefix
    def_delegator :state, :position_x
    def_delegator :state, :position_y
    def_delegator :state, :name
    def_delegator :state, :take_move
    def_delegator :state, :symbolic_result

    def initialize(grid:, position:)
      @state = Cat.new(grid: grid, position: position)
    end

    def update_state(new_state)
      new_state.class.implements(MouseyRevenge::Contracts::CatLike)
      @state = new_state
    end

    def calculate_move(args)
      state.calculate_move(args.merge(context: self))
    end
  end
end

MouseyRevenge::CatContext.implements(MouseyRevenge::Contracts::CatLike)
