require './lib/Game'
require './lib/PieceFactory'
require './lib/ChessMoveRunner'
require './spec/MockPlayer'
require './lib/ComputerPlayer'

describe ComputerPlayer do
  describe "#initialize" do
    it "returns a non-nil object if called" do
      mock_args = { game: nil }
      expect(ComputerPlayer.new(mock_args)).to_not eql(nil)
    end

    it "returns a non-nil object if called with a valid game" do
      options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer,
        human_player_class: MockPlayer,
        chess_move_runner_class: ChessMoveRunner
      }
      game = Game.new(options)
      game.remove_players!({ color: :white })
      args = { game: game, piece_color: :white }
      expect(ComputerPlayer.new(args)).to_not eql(nil)
    end
  end

  # TODO
end
