require 'helper'

class TestCatGroup < Test::Unit::TestCase
  setup do
    level_design = (["-" * 5] * 5).join "\n"
    @grid = MouseyRevenge::Grid.new(width: 5, height: 5, square_size: 10)
    @designer = MouseyRevenge::GridDesigner.new(@grid)
    @designer.write_to_grid(level_design)
  end

  def basic_positions
    res = []
    0.upto(4) do |i|
      res << { x: i, y: 0 }
    end
    res
  end

  should 'initialize a bunch of cats' do
    group = MouseyRevenge::CatGroup.new(grid: @grid, positions: basic_positions)
    assert_equal 5, group.size
    assert_equal [MouseyRevenge::Cat], group.map(&:class).uniq
  end

  should 'tell all of those cats to start computing a search path' do
    future_receiver = mock
    future_receiver.expects(:calculate_move).with(
      target_position: { x: 3, y: 3 }
    ).times(5)
    fake_cat = mock
    fake_cat.stubs(:future).returns(future_receiver)
    fake_cats = 0.upto(4).map { fake_cat.clone }

    group = MouseyRevenge::CatGroup.new(grid: @grid, positions: basic_positions)
    group.instance_variable_set(:@cats, fake_cats)

    group.hunt_for_target(x: 3, y: 3)

    assert_equal 0, group.size
    assert_equal 5, group.futures_currently_calculating.size
  end

  should 'check futures for results, and add them back when resolved' do
    future = mock
    future.stubs(:ready?).returns(true)
    future.stubs(:value).returns mock
    futures = 0.upto(4).map { future.clone }

    group = MouseyRevenge::CatGroup.new(grid: @grid, positions: basic_positions)
    group.instance_variable_set(:@cats, [])
    group.instance_variable_set(:@futures_currently_calculating, futures)

    group.check_current_futures
    assert_equal 5, group.size
    assert_equal 0, group.futures_currently_calculating.size
  end
end
