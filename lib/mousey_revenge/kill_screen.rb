module MouseyRevenge
  class KillScreen
    SPRITE_PATH = '/../../assets/youlose.png'

    include Drawable

    def initialize
      @position = {
        x: 4.4,
        y: 8.4
      }
    end

    private

    attr_reader :position
  end
end
