require 'helper'

class TestNeighbourhood < Test::Unit::TestCase
  setup do
    @level_design = "---+-\n-----"
    @grid = MouseyRevenge::Grid.new(width: 5, height: 5, square_size: 1)
    @designer = MouseyRevenge::GridDesigner.new(@grid)
    @designer.write_to_grid(@level_design)
  end

  should 'work' do
    result = MouseyRevenge::Neighbourhood.for(
      x: 2,
      y: 0,
      grid: @grid,
      options: {
        excluding_occupied_spaces: false,
        excluding_out_of_bounds: true
      }
    )
    assert_equal(
      [{ x: 1, y: 0 }, { x: 3, y: 0 }, { x: 2, y: 1 }],
      result.map(&:to_h)
    )
  end

  should 'excluding_occupied_spaces' do
    result = MouseyRevenge::Neighbourhood.excluding_occupied_spaces(
      MouseyRevenge::Neighbourhood.for(x: 2, y: 0, grid: @grid)
    )
    assert_equal [{ x: 1, y: 0 }, { x: 2, y: 1 }], result.map(&:to_h)
  end
end
