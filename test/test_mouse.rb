require 'helper'
require 'mocha/test_unit'

class TestMouse < Test::Unit::TestCase
  setup do
    @level_design = "----\n--+-"
    @grid = MouseyRevenge::Grid.new(width: 5, height: 5, square_size: 1)
    MouseyRevenge::GridDesigner.new(@grid).write_to_grid(@level_design)

    @sprite = mock()
    @sprite.stubs(:draw)

    @subscriber = mock()
    @subscriber.expects(:subscribe)

    position = { x: 0, y: 0 }

    @mouse = MouseyRevenge::Mouse.new(game: @subscriber, grid: @grid, position: position)
    @mouse.stubs(:sprite).returns(@sprite)
    @grid.overwrite(x: 0, y: 0, value: @mouse)
  end

  should 'be named as a mouse' do
    assert_equal :mouse, @mouse.name
  end

  should 'move around' do
    @mouse.draw
    @mouse.update(right: true)
    assert_equal @mouse, @grid.get(x: 1, y: 0)
    @mouse.update(right: true)
    assert_equal @mouse, @grid.get(x: 2, y: 0)
    @mouse.update(left: true)
    assert_equal @mouse, @grid.get(x: 1, y: 0)
    @mouse.update(down: true)
    assert_equal @mouse, @grid.get(x: 1, y: 1)
    @mouse.update(up: true)
    assert_equal @mouse, @grid.get(x: 1, y: 0)
  end

  should 'shift blocks' do
    @mouse.instance_variable_set(:@position, x: 1, y: 1)
    @grid.overwrite(x: 1, y: 1, value: @mouse)
    @mouse.update(right: true)
    assert_equal true, @grid.get(x: 3, y: 1).can_slide?
  end
end
