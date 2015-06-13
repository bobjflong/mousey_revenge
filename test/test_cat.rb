require 'helper'

class TestCat < Test::Unit::TestCase
  setup do
    @level_design = "c+\n--"
    @grid = MouseyRevenge::Grid.new(width: 2, height: 2, square_size: 1)
    @designer = MouseyRevenge::GridDesigner.new(@grid)
    @designer.write_to_grid(@level_design)
    @cat = MouseyRevenge::Cat.new(grid: @grid, position: { x: 0, y: 0 })
  end

  should 'calculate move' do
    @cat.calculate_move(
      target_position: { x: 1, y: 1 },
      should_sleep: false
    )
    assert_equal :down, @cat.symbolic_result
  end

  should 'synchronously take moves' do
    @cat.calculate_move(
      target_position: { x: 1, y: 1 },
      should_sleep: false
    )
    @cat.take_move(@cat.symbolic_result)
    assert_equal nil, @grid.get(x: 0, y: 0)
    assert_equal :cat, @grid.get(x: 0, y: 1).name
  end

  should 'support futures' do
    assert_equal :down, @cat.future.calculate_move(
      target_position: { x: 1, y: 1 },
      should_sleep: false
    ).value.symbolic_result
  end
end
