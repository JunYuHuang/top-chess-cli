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

  describe "#random_item" do
    it "returns nil if called with a non-array" do
      args = { game: nil }
      computer_player = ComputerPlayer.new(args)
      res = computer_player.random_item({})
      expect(res).to eql(nil)
    end

    it "returns nil if called with an empty array" do
      args = { game: nil }
      computer_player = ComputerPlayer.new(args)
      res = computer_player.random_item([])
      expect(res).to eql(nil)
    end

    it "returns the first element if called with an array of size 1" do
      args = { game: nil }
      computer_player = ComputerPlayer.new(args)
      res = computer_player.random_item([1])
      expect(res).to eql(1)
    end

    it "returns a random element if called with an array that has 2 or more elements" do
      args = { game: nil }
      computer_player = ComputerPlayer.new(args)
      res = computer_player.random_item([1,2,3])
      expected = [1,2,3]
      expect(expected.include?(res)).to eql(true)
    end
  end
end
