# NB: THIS CLASS IS A MESS
# Also it's untested
# I'm using it to scope out Gosu :)

require 'gosu'
require 'wisper'
require 'mousey_revenge/level_scene'

module MouseyRevenge
  def self.headless?
    ENV.fetch('headless', false)
  end

  def self.display
    GridWindow.new.show unless headless?
  end

  def self.superclass
    headless? ? FakeWindow : Gosu::Window
  end

  class GridWindow < superclass
    include Wisper::Publisher

    extend Forwardable

    def_delegator :level_scene, :mouse_position
    def_delegator :level_scene, :mouse_score

    attr_reader :grid, :designer

    def initialize
      super(REAL_WIDTH, REAL_WIDTH)
      @level_scene = LevelScene.new(game: self)
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
      font.draw("Score: #{mouse_score || 0}", 0, 0, 1.0)
      level_scene.draw
    end

    private

    attr_reader :level_scene

    def font
      @font ||= Gosu::Font.new(self, Gosu::default_font_name, 18)
    end
  end
end

MouseyRevenge.display
