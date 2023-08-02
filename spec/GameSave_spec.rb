require './lib/Game'
require './lib/PieceFactory'
require './lib/GameSave'

describe GameSave do
  describe "#initialize" do
    it "returns a non-nil object called with no explicit arguments" do
      game_save = GameSave.new
      expect(game_save).not_to eql(nil)
    end

    it "returns a non-nil object if called with a real game object" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      game_save = GameSave.new({ game: game })
      expect(game_save).to_not eql(nil)
    end
  end
end
