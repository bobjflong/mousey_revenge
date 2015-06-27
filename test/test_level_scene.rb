require 'helper'

class TestLevelScene < Test::Unit::TestCase
  setup do
    game = mock
    game.stub_everything

    test_image_class = mock
    test_image_class.stubs(:new).returns(:sprite)

    MouseyRevenge::LevelScene.any_instance.stubs(:image_class).returns(test_image_class)
    @level_scene = MouseyRevenge::LevelScene.new(game: game)
  end

  should 'create a grid' do
    assert_equal MouseyRevenge::Grid, @level_scene.grid.class
  end

  should 'create a block sprite' do
    assert_equal :sprite, @level_scene.instance_variable_get(:@block)
  end

  should 'create a background sprite' do
    assert_equal :sprite, @level_scene.instance_variable_get(:@background)
  end

  should 'create a level designer' do
    assert_equal MouseyRevenge::GridDesigner, @level_scene.designer.class
  end

  should 'create a cat_group' do
    assert_equal MouseyRevenge::CatGroup, @level_scene.instance_variable_get(:@cat_group).class
  end

  should 'add a mouse to the grid' do
    grid_data = @level_scene.grid.send(:grid_data).flatten
    assert_equal true, grid_data.any? { |i| MouseyRevenge::Mouse === i }
  end

  should 'assign a mouse' do
    assert_equal MouseyRevenge::Mouse, @level_scene.instance_variable_get(:@mouse).class
  end

  should 'send :draw to the cat_group when drawing npcs' do
    cat_group = mock
    cat_group.expects(:draw)
    @level_scene.instance_variable_set(:@cat_group, cat_group)
    @level_scene.send(:draw_npcs)
  end

  should 'draw the grid' do
    block = mock
    block.expects(:draw)

    background = mock
    background.expects(:draw)

    mouse = mock
    mouse.stubs(:name).returns(:mouse)
    mouse.expects(:draw)

    cat = mock
    cat.stubs(:name).returns(:cat)
    cat.expects(:draw)

    grid = MouseyRevenge::Grid.new(width: 2, height: 2, square_size: 1)
    grid.instance_variable_set(:@grid_data, [[nil, OpenStruct.new(name: :block)], [cat, mouse]])
    @level_scene.instance_variable_set(:@grid, grid)
    @level_scene.instance_variable_set(:@block, block)
    @level_scene.instance_variable_set(:@background, background)
    @level_scene.send(:draw_grid)
  end
end
