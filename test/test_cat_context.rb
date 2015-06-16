require 'helper'

class TestCatContext < Test::Unit::TestCase
  setup do
    @grid = MouseyRevenge::Grid.new(width: 2, height: 2, square_size: 1)
    @context = MouseyRevenge::CatContext.new(grid: @grid, position: { x: 0, y: 0 })
    @cat = MouseyRevenge::Cat.new(grid: @grid, position: { x: 0, y: 0 })
  end

  should 'sets a default state' do
    assert_equal MouseyRevenge::Cat, @context.state.class
  end

  should 'set new states' do
    @context.instance_variable_set(:@state, nil)
    assert_equal NilClass, @context.state.class
    @context.update_state(@cat)
    assert_equal MouseyRevenge::Cat, @context.state.class
  end

  should 'check that new states conform to the interface' do
    assert_raise Lawyer::BrokenContract do
      @context.update_state(nil)
    end
  end

  should 'delegate simple methods straight through to the state' do
    assert_equal :cat, @context.name
  end

  should 'delegate methods that require context' do
    assert_nothing_raised do
      @context.calculate_move(target_position: { x: 1, y: 0 })
    end
  end
end
