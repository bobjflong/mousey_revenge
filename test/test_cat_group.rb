require 'helper'
require 'securerandom'

class TestCatGroup < Test::Unit::TestCase
  setup do
    level_design = (['-' * 5] * 5).join "\n"
    @grid = MouseyRevenge::Grid.new(width: 5, height: 5, square_size: 10)
    @designer = MouseyRevenge::GridDesigner.new(@grid)
    @designer.write_to_grid(level_design)
    @game = mock
    @game.stub_everything
  end

  def basic_positions
    res = []
    0.upto(4) do |i|
      res << { x: i, y: 0 }
    end
    res
  end

  should 'initialize a bunch of cats' do
    group = MouseyRevenge::CatGroup.new(game: @game, grid: @grid, positions: basic_positions)
    assert_equal 5, group.size
    assert_equal [MouseyRevenge::CatContext], group.map(&:class).uniq
  end

  should 'tell all of those cats to start computing a search path' do
    fake_cats = []
    5.times do
      fake_cat = mock
      fake_cat.stubs(:uuid).returns(SecureRandom.uuid)
      fake_cat.stubs(:future_calculate_move).with(
        target_position: { x: 3, y: 3 }
      )
      fake_cat.stubs(:immobile?).returns(false)
      fake_cats << fake_cat
    end

    group = MouseyRevenge::CatGroup.new(game: @game, grid: @grid, positions: basic_positions)
    group.instance_variable_set(:@cats, fake_cats)

    group.hunt_for_target(x: 3, y: 3)

    assert_equal 5, group.size
    assert_equal 5, group.futures_currently_calculating.size
    assert_equal 5, group.pending_cats.size
  end

  should 'check futures for results, and maintains the "pending" records' do
    result = mock
    result.stubs(:uuid).returns('1234')
    result.stubs(:attack_mouse_if_possible)
    result.stubs(:symbolic_result).returns(:up)
    result.stubs(:take_move).with(:up)
    result.stubs(:immobile?).returns(false)

    future = mock
    future.stubs(:ready?).returns(true)
    future.stubs(:value).returns result
    futures = 0.upto(4).map { future.clone }

    group = MouseyRevenge::CatGroup.new(game: @game, grid: @grid, positions: basic_positions)
    group.instance_variable_set(:@futures_currently_calculating, futures)
    group.instance_variable_set(:@pending_cats, ['1234'])

    group.check_current_futures
    assert_equal 0, group.futures_currently_calculating.size
    assert_equal 0, group.pending_cats.size
  end

  should 'check futures for results when cats are trapped' do
    result = mock
    result.stubs(:uuid).returns('1234')
    result.stubs(:attack_mouse_if_possible)
    result.stubs(:symbolic_result).returns(:up)
    result.stubs(:take_move).with(:up)
    result.stubs(:immobile?).returns(true)

    future = mock
    future.stubs(:ready?).returns(true)
    future.stubs(:value).returns result
    futures = [future]

    group = MouseyRevenge::CatGroup.new(game: @game, grid: @grid, positions: basic_positions)
    group.instance_variable_set(:@futures_currently_calculating, futures)
    group.instance_variable_set(:@pending_cats, ['1234'])

    group.check_current_futures
    assert_equal 0, group.futures_currently_calculating.size
    assert_equal 0, group.pending_cats.size
  end

  should 'subscribe to game events' do
    game = mock
    game.expects(:subscribe)
    MouseyRevenge::CatGroup.new(game: game, grid: @grid, positions: [])
  end

  should 'turn the cats to cheese when they\'ve all been trapped' do
    group = MouseyRevenge::CatGroup.new(game: @game, grid: @grid, positions: basic_positions)
    group.map do |context|
      context.state.send(:switch_to_trapped_context, context: context)
    end
    group.send(:turn_cats_into_cheese_if_all_trapped)
    assert_equal 5, group.map(&:cheese).uniq.size
  end
end
