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
    @cat.calculate_move(target_position: { x: 1, y: 1 })
    assert_equal :down, @cat.symbolic_result
  end

  should 'synchronously take moves' do
    @cat.calculate_move(target_position: { x: 1, y: 1 })
    @cat.take_move(@cat.symbolic_result)
    assert_equal nil, @grid.get(x: 0, y: 0)
    assert_equal :cat, @grid.get(x: 0, y: 1).name
  end

  should 'update its own record of its position' do
    @cat.calculate_move(target_position: { x: 1, y: 1 })
    @cat.take_move(@cat.symbolic_result)
    assert_equal ({ x: 0, y: 1 }), @cat.instance_variable_get(:@position)
  end

  should 'support futures' do
    assert_equal :down, @cat.future.calculate_move(
      target_position: { x: 1, y: 1 }
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

  should 'report false when ask if trapped' do
    @level_design = "c+\n+-"
    @grid = MouseyRevenge::Grid.new(width: 2, height: 2, square_size: 1)
    @designer = MouseyRevenge::GridDesigner.new(@grid)
    @designer.write_to_grid(@level_design)
    @cat = MouseyRevenge::Cat.new(grid: @grid, position: { x: 0, y: 0 })
    assert_equal false, @cat.immobile?
  end

  should 'set the context state to TrappedCat when trapped' do
    @level_design = "c+\n+-"
    @grid = MouseyRevenge::Grid.new(width: 2, height: 2, square_size: 1)
    @designer = MouseyRevenge::GridDesigner.new(@grid)
    @designer.write_to_grid(@level_design)
    @context = MouseyRevenge::CatContext.new(grid: @grid, position: { x: 0, y: 0 })
    @context.calculate_move(target_position: { x: 1, y: 0 })
    assert_equal MouseyRevenge::TrappedCat, @context.state.class
  end

  should 'set the context state to Cat when untrapped' do
    @level_design = "c-\n+-"
    @grid = MouseyRevenge::Grid.new(width: 2, height: 2, square_size: 1)
    @designer = MouseyRevenge::GridDesigner.new(@grid)
    @designer.write_to_grid(@level_design)
    @context = MouseyRevenge::CatContext.new(grid: @grid, position: { x: 0, y: 0 })
    trapped_cat = MouseyRevenge::TrappedCat.new(grid: @grid, position: {x: 0, y: 0}, uuid: 'foo')
    @context.update_state(trapped_cat)
    @context.calculate_move(target_position: { x: 1, y: 0 })
    assert_equal MouseyRevenge::Cat, @context.state.class
  end

  should "attack mice that are in range" do
    @level_design = "cm\n+-"
    @grid = MouseyRevenge::Grid.new(width: 2, height: 2, square_size: 1)
    @designer = MouseyRevenge::GridDesigner.new(@grid)
    @designer.write_to_grid(@level_design)
    game = mock
    game.stub_everything
    @grid.overwrite(x: 1, y: 0, value: MouseyRevenge::Mouse.new(game: game, grid: @grid, position: { x: 1, y: 0}))
    @context = MouseyRevenge::CatContext.new(grid: @grid, position: { x: 0, y: 0 })
    mouse_result = @context.attack_mouse_if_possible
    assert_equal MouseyRevenge::Mouse, mouse_result.contents.class
  end
end
