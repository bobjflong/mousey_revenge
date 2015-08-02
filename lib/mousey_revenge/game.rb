require 'gosu'
require 'wisper'
require 'mousey_revenge/scene_manager'
require 'mousey_revenge/level_scene'

module MouseyRevenge
  def self.headless?
    ENV.fetch('headless', false)
  end

  def self.display
    Game.new.show unless headless?
  end

  def self.superclass
    headless? ? FakeWindow : Gosu::Window
  end

  class Game < superclass
    include Wisper::Publisher

    extend Forwardable

    def_delegator :scene_manager, :mouse_score
    def_delegator :scene_manager, :mouse_position
    def_delegator :scene_manager, :transition_to

    attr_reader :grid, :designer

    def initialize
      super(REAL_WIDTH, REAL_WIDTH)
      broadcast(:update, mouse_location: mouse_position)
    end

    def update
      params = {
        right: Gosu.button_down?(Gosu::KbRight),
        left: Gosu.button_down?(Gosu::KbLeft),
        up: Gosu.button_down?(Gosu::KbUp),
        down: Gosu.button_down?(Gosu::KbDown),
        mouse_location: mouse_position
      }
      broadcast(:update, params) if params != @last_params
      @last_params = params
    end

    def draw
      scene_manager.draw
    end

    private

    def scene_manager
      @scene_manager ||= SceneManager.new(game: self).tap do |manager|
        manager.transition_to(MouseyRevenge::LevelScene)
      end
    end
  end
end

MouseyRevenge.display
