require 'helper'

class TestGridDesigner < Test::Unit::TestCase
  setup do
    @level_design = "-+-m-\n-++m"
    @grid = MouseyRevenge::Grid.new(width: 5, height: 5, square_size: 1)
    @designer = MouseyRevenge::GridDesigner.new(@grid)
  end

  should 'write levels to grid' do
    @designer.write_to_grid(@level_design)
    assert_equal nil, @grid.get(x:0, y:0)
    assert_equal :block, @grid.get(x: 1, y: 0).name
    assert_equal :mouse, @grid.get(x: 3, y: 0).name
  end
end
