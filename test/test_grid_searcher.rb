require 'helper'

class TestGridSearcher < Test::Unit::TestCase
  setup do
    @level_design = "---+-\n-----"
    @grid = MouseyRevenge::Grid.new(width: 5, height: 5, square_size: 1)
    @designer = MouseyRevenge::GridDesigner.new(@grid)
    @designer.write_to_grid(@level_design)
    @searcher = MouseyRevenge::GridSearcher.new(grid: @grid)
  end

  should 'work' do
    @searcher.start_at(x: 2, y: 0)
    res = @searcher.find_path_to(x: 4, y: 1)
    assert_equal [4, 1], [res.x, res.y]
    assert_equal [3, 1], [res.parent.x, res.parent.y]
    assert_equal [2, 1], [res.parent.parent.x, res.parent.parent.y]
    assert_equal [2, 0], [res.parent.parent.parent.x, res.parent.parent.parent.y]
  end

end
