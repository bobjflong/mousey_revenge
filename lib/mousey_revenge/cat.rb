require 'celluloid/autostart'
require 'mousey_revenge/contracts/cat_like'
require 'mousey_revenge/hunter'

module MouseyRevenge
  class Cat
    NAME = :cat
    SPRITE_PATH = '/../../assets/cat.png'

    include Celluloid
    include Drawable
    include UUID

    extend Forwardable
    def_delegator :hunter, :attack_mouse_if_possible

    def initialize(grid:, position:)
      @grid = grid
      @position = position
      calculate_uuid
    end

    def name
      NAME
    end

    def calculate_move(target_position:, context: nil)
      @result = nil
      find_cached_path(target_position: target_position)
      return current_actor if @result
      return switch_to_trapped_context(context: context) if no_free_moves?
      find_new_path(target_position: target_position)
      current_actor
    end

    def calculate_move_and_sleep(target_position:, context:)
      sleep(0.5)
      calculate_move(target_position: target_position, context: context)
    end

    def take_move(move)
      return noop unless move
      begin
        x, y = grid_shifter.send(
          "shift_#{move}",
          x: position_x,
          y: position_y
        )
        @position = { x: x, y: y }
      rescue MouseyRevenge::OccupiedError
        noop
      end
    end

    def symbolic_result(result = @result)
      result ||= random_valid_move
      return unless result
      return :right if result.fetch(0) > position_x
      return :left if result.fetch(0) < position_x
      return :down if result.fetch(1) > position_y
      return :up if result.fetch(1) < position_y
    end

    def immobile?
      false
    end

    private

    def noop
    end

    def no_free_moves?
      Neighbourhood.for(
        x: position_x,
        y: position_y,
        grid: @grid
      ).empty?
    end

    def switch_to_trapped_context(context:)
      context.update_state(
        TrappedCat.new(
          grid: @grid,
          position: position,
          uuid: uuid
        )
      )
      current_actor
    end

    def find_new_path(target_position:)
      @result = path_finder.find_path(
        source_position: position,
        target_position: target_position
      )
      @previous_target = target_position.clone
    end

    def find_cached_path(target_position:)
      @result = path_finder.find_cached_path(
        target_position: target_position
      )
    end

    def random_valid_move
      neighbour = Neighbourhood.for(
        x: position_x,
        y: position_y,
        grid: @grid
      ).sample
      return unless neighbour
      [neighbour.x, neighbour.y]
    end

    def grid_shifter
      MouseyRevenge::GridShifter.new(grid: grid)
    end

    def hunter
      Hunter.new(position: position, grid: @grid)
    end

    def path_finder
      @path_finder ||= PathFinder.new({}, @grid)
    end

    attr_reader :grid, :position
  end
end

MouseyRevenge::Cat.implements(MouseyRevenge::Contracts::CatLike)
