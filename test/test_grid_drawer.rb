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
end
