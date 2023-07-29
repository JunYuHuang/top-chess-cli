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
    it "returns nil if called with any missing arguments" do
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
    it "returns nil if called with any missing arguments" do
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

  describe "#pieces" do
    it "returns an array of the correct piece hashes if called with a certain board and a certain filter" do
      board = Array.new(8) { Array.new(8, nil) }
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      8.times do |col|
        board[6][col] = white_pawn
      end
      filters = { color: :white }
      res = PieceUtilsClass.pieces(board, filters)
      expect(res.size).to eql(8)
      res.each do |piece_hash|
        expect(piece_hash[:piece].class).to eql(MockPiece)
        expect(piece_hash[:cell].class).to eql(Array)
      end
    end

    it "returns an array of the correct piece hashes if called with a certain board and a certain filter" do
      board = Array.new(8) { Array.new(8, nil) }
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
      board[6][0] = white_pawn
      board[1][0] = black_pawn
      filters = { color: :white }
      res = PieceUtilsClass.pieces(board, filters)
      expect(res.size).to eql(1)
    end

    it "returns an array of the correct piece hashes if called with a certain board and a certain filter" do
      board = Array.new(8) { Array.new(8, nil) }
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
      black_king = MockPiece.new({ color: :black, type: :king })
      board[6][0] = white_pawn
      board[1][0] = black_pawn
      board[0][4] = black_king
      filters = { type: :pawn }
      res = PieceUtilsClass.pieces(board, filters)
      expect(res.size).to eql(2)
    end

    it "returns an array of the correct piece hashes if called with a certain board and a certain filter" do
      board = Array.new(8) { Array.new(8, nil) }
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      white_rook = MockPiece.new({ color: :white, type: :rook })
      board[6][0] = white_pawn
      board[7][0] = white_rook
      filters = { type: :rook }
      res = PieceUtilsClass.pieces(board, filters)
      expect(res.size).to eql(1)
    end

    it "returns an array of the correct piece hashes if called with a certain board and a certain filter" do
      board = Array.new(8) { Array.new(8, nil) }
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      white_rook = MockPiece.new({ color: :white, type: :rook })
      board[6][0] = white_pawn
      board[7][0] = white_rook
      filters = { color: :black }
      res = PieceUtilsClass.pieces(board, filters)
      expect(res.size).to eql(0)
    end
  end

  describe "#count_col_cells_amid_two_cells" do
    it "returns 0 if called with ([0,0],[1,0])" do
      cells = [[0,0],[1,0]]
      res = PieceUtilsClass.count_col_cells_amid_two_cells(*cells)
      expect(res).to eql(0)
    end

    it "returns -1 if called with ([0,0],[0,0])" do
      cells = [[0,0],[0,0]]
      res = PieceUtilsClass.count_col_cells_amid_two_cells(*cells)
      expect(res).to eql(-1)
    end

    it "returns -1 if called with ([7,0],[5,0])" do
      cells = [[7,0],[5,0]]
      res = PieceUtilsClass.count_col_cells_amid_two_cells(*cells)
      expect(res).to eql(1)
    end

    it "returns -1 if called with ([5,0],[7,0])" do
      cells = [[5,0],[7,0]]
      res = PieceUtilsClass.count_col_cells_amid_two_cells(*cells)
      expect(res).to eql(1)
    end
  end

  describe "#adjacent_cells" do
    it "returns the correct int matrix array if called with [0,0]" do
      res = PieceUtilsClass.adjacent_cells([0,0])
      expected = [
        [0, 1],     # right
        [1, 0],     # bot
        [1, 1],     # bot right
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |cell|
        expect(res.include?(cell)).to eql(true)
      end
    end

    it "returns the correct int matrix array if called with [0,7]" do
      res = PieceUtilsClass.adjacent_cells([0,7])
      expected = [
        [0, 6],     # left
        [1, 6],     # bot left
        [1, 7],     # bot
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |cell|
        expect(res.include?(cell)).to eql(true)
      end
    end

    it "returns the correct int matrix array if called with [7,7]" do
      res = PieceUtilsClass.adjacent_cells([7,7])
      expected = [
        [6, 6],     # top left
        [6, 7],     # top
        [7, 6],     # left
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |cell|
        expect(res.include?(cell)).to eql(true)
      end
    end

    it "returns the correct int matrix array if called with [3,3]" do
      res = PieceUtilsClass.adjacent_cells([3,3])
      expected = [
        [2, 2],     # top left
        [2, 3],     # top
        [2, 4],     # top right
        [3, 2],     # left
        [3, 4],     # right
        [4, 2],     # bot left
        [4, 3],     # bot
        [4, 4],     # bot right
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |cell|
        expect(res.include?(cell)).to eql(true)
      end
    end
  end

  describe "#en_passant_captive_cell" do
    it "returns nil if called with ([2,8], :white)" do
      res = PieceUtilsClass.en_passant_captive_cell([2,8], :white)
      expect(res).to eql(nil)
    end

    it "returns [3,4] if called with ([2,4], :white)" do
      res = PieceUtilsClass.en_passant_captive_cell([2,4], :white)
      expect(res).to eql([3,4])
    end

    it "returns [3,6] if called with ([2,6], :white)" do
      res = PieceUtilsClass.en_passant_captive_cell([2,6], :white)
      expect(res).to eql([3,6])
    end

    it "returns [4,1] if called with ([5,1], :black)" do
      res = PieceUtilsClass.en_passant_captive_cell([5,1], :black)
      expect(res).to eql([4,1])
    end

    it "returns [4,3] if called with ([5,3], :black)" do
      res = PieceUtilsClass.en_passant_captive_cell([5,3], :black)
      expect(res).to eql([4,3])
    end
  end
end
