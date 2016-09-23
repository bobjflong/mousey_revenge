module MouseyRevenge
  InvalidScene = Class.new(StandardError)
  UnknownSceneMessage = Class.new(StandardError)

  attr_reader :scene

  class SceneManager
    def initialize(game:)
      @game = game
      @scene = nil
    end

    def transition_to(scene_class)
      transition_scene = scene_class.new(game: game)
      fail InvalidScene unless transition_scene.respond_to?(:draw)
      @scene = transition_scene
    end

    def method_missing(msg, *args)
      return scene.send(msg, *args) if scene.respond_to?(msg)
      super
    end

    def respond_to_missing?(msg, _)
      scene.respond_to?(msg)
    end

    private

    attr_reader :game, :scene
  end
end
