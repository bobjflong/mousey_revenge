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
    assert_equal :down, @cat.calculate_move(
      target_position: { x: 1, y: 1 },
      should_sleep: false
    )
  end

  should 'synchronously take moves' do
    move = @cat.calculate_move(
      target_position: { x: 1, y: 1 },
      should_sleep: false
    )
    @cat.take_move(move)
    assert_equal nil, @grid.get(x: 0, y: 0)
    assert_equal :cat, @grid.get(x: 0, y: 1).name
  end

  should 'support futures' do
    assert_equal :down, @cat.future.calculate_move(
      target_position: { x: 1, y: 1 },
      should_sleep: false
    ).value
  end
end
