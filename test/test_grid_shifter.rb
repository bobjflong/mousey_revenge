require 'helper'

class TestGridShifter < Test::Unit::TestCase
  setup do
    @grid = MouseyRevenge::Grid.new(width: 10, height: 10, square_size: 1)
    @shifter = MouseyRevenge::GridShifter.new(grid: @grid)
  end

  should 'move items right' do
    @grid.place(x: 0, y: 0, value: :foo)
    @shifter.shift_right(x: 0, y: 0)
    assert_equal :foo, @grid.get(x: 1, y: 0)
  end

  should 'move items left' do
    @grid.place(x: 1, y: 0, value: :foo)
    @shifter.shift_left(x: 1, y: 0)
    assert_equal :foo, @grid.get(x: 0, y: 0)
  end
end
