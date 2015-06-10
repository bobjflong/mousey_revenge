require 'helper'

class TestGridSearcher < Test::Unit::TestCase
  setup do
    @level_design = "-+\n--"
    @grid = MouseyRevenge::Grid.new(width: 2, height: 2, square_size: 1)
    @designer = MouseyRevenge::GridDesigner.new(@grid)
    @designer.write_to_grid(@level_design)
    @searcher = MouseyRevenge::GridSearcher.new(grid: @grid)
  end

  should 'work' do
    @searcher.start_at(x: 0, y: 0)
    res = @searcher.find_path_to(x: 1, y: 1)
    chain = []
    loop do
      chain << [res.x, res.y]
      break unless res.parent
      res = res.parent
    end
    assert_equal [[0, 0], [0, 1], [1, 1]], chain.reverse
  end

end
