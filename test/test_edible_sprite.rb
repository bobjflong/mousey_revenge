require 'helper'

class TestObject
  SPRITE_PATH = 'foo'

  include MouseyRevenge::EdibleSprite

  def grid
    MouseyRevenge::Grid.new(width: 5, height: 5, square_size: 10)
  end

  def position
    { x: 0, y: 0 }
  end

  def uuid
    '1234'
  end
end

class TestEdibleSprite < Test::Unit::TestCase
  setup do
    @edible = TestObject.new
  end

  should 'fallback to the normal sprite image path' do
    assert_equal 'foo', @edible.sprite_path
  end

  should 'use the alternative sprite image path when edible' do
    @edible.turn_into_cheese
    assert_equal '/../../assets/cheese.png', @edible.sprite_path
  end
end
