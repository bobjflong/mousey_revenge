module MouseyRevenge
  class ScoreDrawer
    attr_reader :game

    def initialize(game)
      @game = game
    end

    def draw(score:)
      font.draw("Score: #{score || 0}", 0, 0, 1.0)
    end

    private

    def font
      @font ||= Gosu::Font.new(game, Gosu.default_font_name, 18)
    end
  end
end
