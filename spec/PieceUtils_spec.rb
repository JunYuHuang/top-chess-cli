require './spec/PieceUtilsClass'
require './spec/MockPiece'

describe "PieceUtils" do
  describe "deep_copy" do
    it "returns a deep copy of the board it was called with" do
      board = Array.new(8) { Array.new(8, nil) }
      board_copy = PieceUtilsClass.deep_copy(board)
      expect(board).to eql(board_copy)
    end

    it "returns a deep copy of the board it was called with that does not affect the original if the copy is modified" do
      board = Array.new(8) { Array.new(8, nil) }
      board_copy = PieceUtilsClass.deep_copy(board)
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      board_copy[6][3] = white_pawn
      expect(board).not_to eql(board_copy)
    end
  end
end
