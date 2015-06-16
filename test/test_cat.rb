require 'helper'

class TestCat < Test::Unit::TestCase
  setup do
    @level_design = "c+\n--"
    @grid = MouseyRevenge::Grid.new(width: 2, height: 2, square_size: 1)
    @designer = MouseyRevenge::GridDesigner.new(@grid)
    @designer.write_to_grid(@level_design)
    @cat = MouseyRevenge::Cat.new(grid: @grid, position: { x: 0, y: 0 })
  end

  should 'have uuids' do
    assert_not_nil @cat.uuid
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

  should 'update its own record of its position' do
    @cat.calculate_move(
      target_position: { x: 1, y: 1 },
      should_sleep: false
    )
    @cat.take_move(@cat.symbolic_result)
    assert_equal ({ x: 0, y: 1 }), @cat.instance_variable_get(:@position)
  end

  should 'support futures' do
    assert_equal :down, @cat.future.calculate_move(
      target_position: { x: 1, y: 1 },
      should_sleep: false
    ).value.symbolic_result
  end

  should 'default if no move is found' do
    assert_not_nil @cat.symbolic_result(nil)
  end

  should 'not crash if there are no valid neighbours' do
    @level_design = "c+\n+-"
    @grid = MouseyRevenge::Grid.new(width: 2, height: 2, square_size: 1)
    @designer = MouseyRevenge::GridDesigner.new(@grid)
    @designer.write_to_grid(@level_design)
    @cat = MouseyRevenge::Cat.new(grid: @grid, position: { x: 0, y: 0 })
    assert_nil @cat.send(:random_valid_move)
  end

  # TODO is it even necessary to have trapped? part of the interface?
  should 'report false when ask if trapped' do
    @level_design = "c+\n+-"
    @grid = MouseyRevenge::Grid.new(width: 2, height: 2, square_size: 1)
    @designer = MouseyRevenge::GridDesigner.new(@grid)
    @designer.write_to_grid(@level_design)
    @cat = MouseyRevenge::Cat.new(grid: @grid, position: { x: 0, y: 0 })
    assert_equal false, @cat.trapped?
  end

  should 'set the context state to TrappedCat when trapped' do
    @level_design = "c+\n+-"
    @grid = MouseyRevenge::Grid.new(width: 2, height: 2, square_size: 1)
    @designer = MouseyRevenge::GridDesigner.new(@grid)
    @designer.write_to_grid(@level_design)
    @context = MouseyRevenge::CatContext.new(grid: @grid, position: { x: 0, y: 0 })
    @context.calculate_move(
      target_position: { x: 1, y: 0 },
      should_sleep: false
    )
    assert_equal MouseyRevenge::TrappedCat, @context.state.class
  end
end
