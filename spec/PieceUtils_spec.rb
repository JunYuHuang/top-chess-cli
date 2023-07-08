require './spec/PieceUtilsClass'
require './spec/MockPiece'

describe "PieceUtils" do
  describe "#deep_copy" do
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

  describe "#move" do
    it "returns nil called with any missing arguments" do
      board = Array.new(8) { Array.new(8, nil) }
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      board[6][2] = white_pawn
      args = {
        piece_obj: white_pawn,
        src_cell: [6,2],
        board: board
      }
      res = PieceUtilsClass.move(args)
      expect(res).to eql(nil)
    end

    it "returns the correct board if called with all valid arguments" do
      board = Array.new(8) { Array.new(8, nil) }
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      board[6][2] = white_pawn
      args = {
        piece_obj: white_pawn,
        src_cell: [6,2],
        dst_cell: [4,2],
        board: board
      }
      res = PieceUtilsClass.move(args)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[4][2] = white_pawn
      expect(res).to eql(expected)
    end
  end

  describe "#capture" do
    it "returns nil called with any missing arguments" do
      board = Array.new(8) { Array.new(8, nil) }
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      board[6][2] = white_pawn
      args = {
        piece_obj: white_pawn,
        src_cell: [6,2],
        board: board
      }
      res = PieceUtilsClass.capture(args)
      expect(res).to eql(nil)
    end

    it "returns the correct board if called with all valid arguments" do
      board = Array.new(8) { Array.new(8, nil) }
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
      board[5][1] = black_pawn
      board[6][2] = white_pawn
      args = {
        piece_obj: white_pawn,
        src_cell: [6,2],
        dst_cell: [5,1],
        board: board
      }
      res = PieceUtilsClass.capture(args)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[5][1] = white_pawn
      expect(res).to eql(expected)
    end

    it "returns the correct board if called with all valid arguments including an en-passant capture cell" do
      board = Array.new(8) { Array.new(8, nil) }
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
      board[3][4] = black_pawn
      board[3][5] = white_pawn
      args = {
        piece_obj: white_pawn,
        src_cell: [3,5],
        dst_cell: [2,4],
        board: board,
        en_passant_cap_cell: [3,4]
      }
      res = PieceUtilsClass.capture(args)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[2][4] = white_pawn
      expect(res).to eql(expected)
    end
  end
end
