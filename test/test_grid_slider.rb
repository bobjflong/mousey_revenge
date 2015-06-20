require 'helper'
require 'mocha'

class TestGridSlider < Test::Unit::TestCase
  setup do
    @grid = MouseyRevenge::Grid.new(width: 5, height: 5, square_size: 1)
    @slider = MouseyRevenge::GridSlider.new(grid: @grid)
    @slidable = mock()
    @slidable.stubs(:can_slide?).returns(true)
  end

  should 'know if a line of values is slidable' do
    @grid.place(x: 0, y: 0, value: :block)
    @grid.place(x: 1, y: 0, value: @slidable)
    @grid.place(x: 2, y: 0, value: @slidable)
    assert_equal true, @slider.can_slide_right?(x: 0, y: 0)
  end

  should 'know if a line of values is not slidable' do
    @grid.place(x: 1, y: 0, value: @slidable)
    @grid.place(x: 2, y: 0, value: @slidable)
    @grid.place(x: 3, y: 0, value: @slidable)
    @grid.place(x: 4, y: 0, value: @slidable)
    assert_equal false, @slider.can_slide_right?(x: 1, y: 0)
  end

  should 'slide horizontally' do
    @grid.place(x: 1, y: 0, value: @slidable)
    @grid.place(x: 2, y: 0, value: @slidable)
    @slider.slide_right!(x: 0, y: 0)
    assert_equal nil, @grid.get(x: 1, y: 0)
    assert_equal @slidable, @grid.get(x: 2, y: 0)
    assert_equal @slidable, @grid.get(x: 3, y: 0)
  end

  should 'slide vertically' do
    @grid.place(x: 0, y: 1, value: @slidable)
    @grid.place(x: 0, y: 2, value: @slidable)
    @slider.slide_down!(x: 0, y: 0)
    assert_equal nil, @grid.get(x: 0, y: 1)
    assert_equal @slidable, @grid.get(x: 0, y: 2)
    assert_equal @slidable, @grid.get(x: 0, y: 3)
  end

  should 'invert when sliding' do
    @grid.place(x: 0, y: 1, value: @slidable)
    @grid.place(x: 0, y: 2, value: @slidable)
    @slider.slide_down!(x: 0, y: 0)
    @slider.slide_up!(x: 0, y: 4)
    assert_equal @slidable, @grid.get(x: 0, y: 1)
    assert_equal @slidable, @grid.get(x: 0, y: 2)
    assert_equal nil, @grid.get(x: 0, y: 3)
  end
end
