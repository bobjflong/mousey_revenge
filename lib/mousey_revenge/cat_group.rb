module MouseyRevenge
  # Represents a group of cats
  # Capable of telling its cats to start calculating a path to a target
  class CatGroup
    attr_reader :cats, :grid, :futures_currently_calculating

    extend Forwardable

    def_delegator :cats, :size
    def_delegator :cats, :map

    def initialize(grid:, positions:)
      @grid = grid
      @cats = positions.map { |p| position_to_cat p }
      @futures_currently_calculating = []
    end

    def hunt_for_target(target)
      cats.delete_if do |cat|
        futures_currently_calculating <<
          cat.future.calculate_move(target_position: target)
      end
    end

    def check_current_futures
      futures_currently_calculating.delete_if do |future|
        cats << future.value if future.ready?
      end
    end

    private

    def position_to_cat(position)
      MouseyRevenge::Cat.new(
        grid: grid,
        position: position
      )
    end
  end
end
