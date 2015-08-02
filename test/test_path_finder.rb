require 'helper'

class TestPathFinder < Test::Unit::TestCase
  setup do
    @cache = { [0,1] => [:foo, :bar] }
    @finder = MouseyRevenge::PathFinder.new(@cache, mock)

    @first_node = MouseyRevenge::SearchRepresentation.new(x:0, y: 0, cost: 0)
    @second_node = MouseyRevenge::SearchRepresentation.new(x:1, y: 0, cost: 0, parent: @first_node)
    @third_node = MouseyRevenge::SearchRepresentation.new(x:2, y: 0, cost: 0, parent: @second_node)

    @searcher = mock
    @searcher.stubs(:find_path_to).with(x: 3, y: 0).returns(@third_node)

    @finder.stubs(:searcher).returns(@searcher)
  end

  should 'find cached paths' do
    assert_equal :foo, @finder.find_cached_path(target_position: { x: 0, y: 1})
  end

  should 'find new paths' do
    assert_equal [1, 0], @finder.find_path(source_position: { x: 0, y: 0 }, target_position: { x: 3, y: 0})
  end

  should 'maintain the cache' do
    @finder.find_path(source_position: { x: 0, y: 0 }, target_position: { x: 3, y: 0})
    assert_equal [[2, 0]], @finder.cache[[3, 0]]
  end
end
