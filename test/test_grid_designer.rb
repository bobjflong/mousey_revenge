require 'helper'

class TestGridDesigner < Test::Unit::TestCase
  setup do
    @level_design = "-+rm-\nc++m"
    @grid = MouseyRevenge::Grid.new(width: 5, height: 5, square_size: 1)
    @designer = MouseyRevenge::GridDesigner.new(@grid)
  end

  should 'write levels to grid' do
    @designer.write_to_grid(@level_design)
    assert_equal nil, @grid.get(x:0, y:0)
    assert_equal :block, @grid.get(x: 1, y: 0).name
    assert_equal :rock, @grid.get(x: 2, y: 0).name
    assert_equal :mouse, @grid.get(x: 3, y: 0).name
  end

  should 'track cat locations' do
    @designer.write_to_grid(@level_design)
    assert_equal [{ x: 0, y: 1 }], @designer.cat_locations
  end

  should 'create some base sprite classes' do
    assert_equal '/../../assets/rock.png', RockRepresentation.class_variable_get(:@@sprite_path)
    assert_equal '/../../assets/tile.png', BlockRepresentation.class_variable_get(:@@sprite_path)
  end
end
