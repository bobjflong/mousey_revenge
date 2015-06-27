require 'mousey_revenge/contracts/cat_like'

module MouseyRevenge
  class CatContext
    attr_reader :state

    def initialize(grid:, position:)
      @state = Cat.new(grid: grid, position: position)
    end

    def update_state(new_state)
      new_state.class.implements(MouseyRevenge::Contracts::CatLike)
      @state = new_state
    end

    def future_calculate_move(args)
      state.future.calculate_move_and_sleep(args.merge(context: self))
    end

    def calculate_move(args)
      state.calculate_move(args.merge(context: self))
    end

    def draw(*args)
      state.draw(*args)
    end

    def edible?
      return false unless state.respond_to?(:edible?)
      state.edible?
    end

    def method_missing(m, *args)
      return state.send(m, *args) if state.respond_to?(m)
      fail NoMethodError
    end
  end
end
