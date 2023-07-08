require './lib/RookPiece'
require './spec/MockPiece'

describe RookPiece do
  describe "#initialize" do
    it "returns a non-nil object if called" do
      rook = RookPiece.new
      expect(rook).to_not eql(nil)
    end
  end

  describe "#moves" do
    it "returns the correct int matrix if called with a valid cell and a board with a white pawn and a black pawn" do
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
      white_rook = RookPiece.new({ color: :white, did_move: true })
      board = Array.new(8) { Array.new(8, nil) }
      board[1][2] = black_pawn
      board[6][2] = white_pawn
      board[4][2] = white_rook

      res = white_rook.moves([4,2], board)
      expected = [
        [4,0], [4,1],                       # left cells
        [4,3], [4,4], [4,5], [4,6], [4,7],  # right cells
        [3,2], [2,2],                       # up cells
        [5,2]                               # down cells
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and an otherwise empty board" do
      white_rook = RookPiece.new({ color: :white, did_move: true })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][2] = white_rook

      res = white_rook.moves([4,2], board)
      expected = [
        [4,0], [4,1],                       # left cells
        [4,3], [4,4], [4,5], [4,6], [4,7],  # right cells
        [3,2], [2,2], [1,2], [0,2],         # up cells
        [5,2], [6,2], [7,2]                 # down cells
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end
  end

  describe "#captures" do
    it "returns the correct int matrix if called with a valid cell and a board with a white pawn and a black pawn" do
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
      white_rook = RookPiece.new({ color: :white, did_move: true })
      board = Array.new(8) { Array.new(8, nil) }
      board[1][2] = black_pawn
      board[6][2] = white_pawn
      board[4][2] = white_rook

      res = white_rook.captures([4,2], board)
      expected = [
        [1,2] # up cells
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns an empty int matrix if called with a valid cell and an otherwise empty board" do
      white_rook = RookPiece.new({ color: :white, did_move: true })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][2] = white_rook

      res = white_rook.captures([4,2], board)
      expect(res.size).to eql(0)
      expect(res).to eql([])
    end
  end

  describe "#move" do
    it "returns the correct board if called with all valid arguments on a white rook" do
      board = Array.new(8) { Array.new(8, nil) }
      white_rook = RookPiece.new({ color: :white })
      board[7][0] = white_rook
      res = white_rook.move([7,0], [5,0], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[5][0] = white_rook
      expect(res).to eql(expected)
    end
  end

  describe "#capture" do
    it "returns the correct board if called with all valid arguments on a white rook" do
      board = Array.new(8) { Array.new(8, nil) }
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
      white_rook = RookPiece.new({ color: :white })
      board[5][0] = black_pawn
      board[7][0] = white_rook
      res = white_rook.capture([7,0], [5,0], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[5][0] = white_rook
      expect(res).to eql(expected)
    end
  end
end
