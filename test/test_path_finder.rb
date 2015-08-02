require 'helper'

class TestPathFinder < Test::Unit::TestCase
  setup do
    @cache = { [0,1] => [:foo, :bar] }
    @finder = MouseyRevenge::PathFinder.new(@cache, mock)
  end

  should 'work' do
    assert_equal :foo, @finder.find_cached_path(target_position: { x: 0, y: 1})
  end
end
