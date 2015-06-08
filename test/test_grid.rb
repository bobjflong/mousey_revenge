require 'helper'

class TestGrid < Test::Unit::TestCase
  setup do
    @grid = MouseyRevenge::Grid.new(width: 5, height: 5, square_size: 10)
  end

  should 'have width and height' do
    assert_equal 5, @grid.width
    assert_equal 5, @grid.height
  end

  should 'get items' do
    assert_equal nil, @grid.get(x: 0, y: 0)
    assert_equal MouseyRevenge::Grid::OUT_OF_BOUNDS, @grid.get(x: -1, y: 0)
    assert_equal MouseyRevenge::Grid::OUT_OF_BOUNDS, @grid.get(x: 10_000, y: 0)
    assert_equal MouseyRevenge::Grid::OUT_OF_BOUNDS, @grid.get(x: 0, y: -1)
    assert_equal MouseyRevenge::Grid::OUT_OF_BOUNDS, @grid.get(x: 0, y: 10_000)
  end

  should 'have a square size' do
    assert_equal 10, @grid.square_size
  end

  should 'place items' do
    assert_equal :foo, @grid.place(x: 0, y: 0, value: :foo).get(x: 0, y: 0)
  end

  should 'delete items' do
    @grid.place(x: 0, y: 0, value: :foo)
    @grid.delete(x: 0, y: 0)
    assert_equal :empty, @grid.get(x: 0, y: 0, default: :empty)
  end

  should 'not be possible to place more item than once on a grid item' do
    assert_raise MouseyRevenge::OccupiedError do
      2.times { @grid.place(x: 0, y: 0, value: :foo) }
    end
  end

  should 'calculate out of bounds points correctly' do
    assert_equal true, @grid.out_of_bounds?(x: -1, y: 0)
    assert_equal true, @grid.out_of_bounds?(x: 0, y: -1)
    assert_equal true, @grid.out_of_bounds?(x: 100, y: 0)
    assert_equal true, @grid.out_of_bounds?(x: 0, y: 100)
    assert_equal false, @grid.out_of_bounds?(x: 0, y: 0)
  end

  should 'enumerate values' do
    @grid.delete(x: 0, y: 0)
    @grid.place(x: 1, y: 0, value: :x)
    @grid.place(x: 2, y: 0, value: :y)
    @grid.place(x: 3, y: 0, value: :z)

    result = @grid.enumerate_right_from(x: 0, y: 0).to_a.map(&:value)
    assert_equal [nil, :x, :y, :z, nil, MouseyRevenge::Grid::OUT_OF_BOUNDS], result
  end
end
