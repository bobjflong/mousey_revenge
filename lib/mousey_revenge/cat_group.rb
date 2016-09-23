module MouseyRevenge
  # Represents a group of cats
  # Capable of telling its cats to start calculating a path to a target
  class CatGroup
    attr_reader :cats, :grid, :futures_currently_calculating, :pending_cats

    extend Forwardable

    def_delegator :cats, :size
    def_delegator :cats, :map

    def initialize(game:, grid:, positions:)
      @game = game
      @grid = grid
      @cats = positions.map { |p| position_to_cat p }
      @pending_cats = []
      @futures_currently_calculating = []
      game.subscribe(self)
    end

    def tick
      hunt_for_target(@last_mouse_location)
      check_current_futures
      turn_cats_into_cheese_if_all_trapped
    end

    def update(params)
      return unless params.key?(:mouse_location)
      @last_mouse_location = params.fetch(:mouse_location)
    end

    def hunt_for_target(target)
      cats.each do |cat|
        next if pending_result?(cat)
        futures_currently_calculating <<
          cat.future_calculate_move(target_position: target)
        pending_cats << cat.uuid
      end
    end

    def check_current_futures
      futures_currently_calculating.delete_if do |future|
        if future.ready?
          future.value.tap do |cat|
            attack_mouse_with_cat(cat) || cat.take_move(cat.symbolic_result)
            pending_cats.delete(cat.uuid)
          end
        end
      end
    end

    def turn_cats_into_cheese_if_all_trapped
      return unless cats.all?(&:immobile?)
      cats.map(&:turn_into_cheese)
    end

    private

    attr_reader :game

    def attack_mouse_with_cat(cat)
      return if cat.immobile? # todo: spec
      result = cat.attack_mouse_if_possible
      game.transition_to(KillScreen) if result
      result
    end

    def pending_result?(cat)
      @pending_cats.include?(cat.uuid)
    end

    def position_to_cat(position)
      MouseyRevenge::CatContext.new(
        grid: grid,
        position: position
      )
    end
  end
end
