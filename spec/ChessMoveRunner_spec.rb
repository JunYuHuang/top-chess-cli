require './lib/ChessMoveRunner'
require './lib/Game'
require './lib/PieceFactory'
require './spec/MockPlayer'

describe ChessMoveRunner do
  describe "#initialize" do
    it "works if called with a game object" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      expect(chess_move_runner).not_to eql(nil)
    end
  end
end
