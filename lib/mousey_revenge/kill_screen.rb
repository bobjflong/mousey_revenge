module MouseyRevenge
  class KillScreen
    SPRITE_PATH = '/../../assets/youlose.png'

    include Drawable

    def initialize(*)
      @position = {
        x: 4.4,
        y: 8.4
      }
    end

    def mouse_position
      { x: 0, y: 0 }
    end

    def mouse_score
    end

    private

    attr_reader :position
  end
end
