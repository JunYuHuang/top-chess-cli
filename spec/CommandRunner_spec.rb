require './lib/ChessMoveRunner'
require './lib/Game'
require './lib/PieceFactory'
require './lib/GameSave'
require './spec/MockPlayer'
require './lib/CommandRunner'

describe CommandRunner do
  describe "#initialize" do
    it "returns a non-nil object if called with a hash containing a mock game object" do
      mock_game = nil
      command_runner = CommandRunner.new({ game: mock_game })
      expect(command_runner).not_to eql(nil)
    end
  end
end
