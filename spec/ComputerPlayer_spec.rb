require './lib/Game'
require './lib/PieceFactory'
require './lib/ChessMoveRunner'
require './spec/MockPlayer'
require './lib/ComputerPlayer'

# TODO
describe ComputerPlayer do
  describe "#initialize" do
    it "returns a non-nil object if called" do
      mock_args = { game: nil }
      expect(ComputerPlayer.new(mock_args)).to_not eql(nil)
    end
  end
end
