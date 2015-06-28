require 'helper'
require 'mousey_revenge/scene_manager'

class TestScene
  class << self
    attr_accessor :game, :draw_count
  end

  def initialize(game:)
    TestScene.game = game
  end

  def draw
    TestScene.draw_count = (@draw_count || 0) + 1
  end
end

class TestSceneManager < Test::Unit::TestCase
  setup do
    @manager = MouseyRevenge::SceneManager.new(game: :game)
  end

  should 'transition to scenes' do
    @manager.transition_to(TestScene)
    assert_equal :game, TestScene.game
  end

  should 'forward messages to the scenes' do
    TestScene.draw_count = 0
    @manager.transition_to(TestScene)
    @manager.draw
    assert_equal 1, TestScene.draw_count
  end
end
