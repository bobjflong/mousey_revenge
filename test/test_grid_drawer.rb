require 'mocha'
require 'mousey_revenge/fake_window'

class TestGridDrawer < Test::Unit::TestCase
  setup do
    ENV['headless'] = true.to_s
    require 'mousey_revenge/grid_drawer'
  end

  teardown do
    ENV['headless'] = false.to_s
  end

  should 'initialize sprites, grid, mouse, npcs' do
    designer = mock
    designer.stubs(:mouse_location)
    designer.stubs(:cat_locations)

    mouse = mock
    mouse.stubs(:position)

    MouseyRevenge::GridWindow
      .any_instance
      .stubs(:mouse).returns(mouse)

    MouseyRevenge::GridWindow
      .any_instance
      .stubs(:designer).returns(designer)

    %i(set_up_base_sprites set_up_grid
       set_up_mouse set_up_cats).each do |msg|
      MouseyRevenge::GridWindow
        .any_instance
        .expects(msg)
    end
    window = MouseyRevenge::GridWindow.new
  end
end
