require 'helper'

class TestKillScreen < Test::Unit::TestCase
  setup do
    @kill_screen = MouseyRevenge::KillScreen.new
  end

  should 'use the kill screen image' do
    assert_equal '/../../assets/youlose.png', MouseyRevenge::KillScreen::SPRITE_PATH
  end
end
