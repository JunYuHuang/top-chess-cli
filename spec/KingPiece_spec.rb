require './lib/KingPiece'
require './spec/DummyPiece'

describe KingPiece do
  describe "#initialize" do
    it "returns a non-nil object if called" do
      king = KingPiece.new
      expect(king).to_not eql(nil)
    end
  end

  describe "#is_checked?" do
    it "returns false if called with a valid cell and an otherwise empty board on a white king" do
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[7][4] = white_king

      res = white_king.is_checked?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and an otherwise empty board on a black king" do
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[0][4] = black_king

      res = black_king.is_checked?([0,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a board with a black rook and a white pawn on a white king" do
      black_rook = DummyPiece.new({
        color: :black,
        type: :rook,
        did_move: true
      })
      white_pawn = DummyPiece.new({ color: :white, type: :pawn })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][4] = black_rook
      board[6][4] = white_pawn
      board[7][4] = white_king

      res = white_king.is_checked?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns true if called with a valid cell and a board with a black rook on a white king" do
      black_rook = DummyPiece.new({
        color: :black,
        type: :rook,
        did_move: true
      })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][4] = black_rook
      board[7][4] = white_king

      res = white_king.is_checked?([7,4], board)
      expect(res).to eql(true)
    end

    it "returns true if called with a valid cell and a board with a white rook on a black king" do
      white_rook = DummyPiece.new({
        color: :white,
        type: :rook,
        did_move: true
      })
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = white_rook
      board[0][4] = black_king

      res = black_king.is_checked?([0,4], board)
      expect(res).to eql(true)
    end

    it "returns true if called with a valid cell and a board with a black knight on a white king" do
      black_knight = DummyPiece.new({
        color: :black,
        type: :knight,
        did_move: true
      })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[5][3] = black_knight
      board[7][4] = white_king

      res = white_king.is_checked?([7,4], board)
      expect(res).to eql(true)
    end

    it "returns true if called with a valid cell and a board with a black bishop on a white king" do
      black_bishop = DummyPiece.new({
        color: :black,
        type: :bishop,
        did_move: true
      })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][7] = black_bishop
      board[7][4] = white_king

      res = white_king.is_checked?([7,4], board)
      expect(res).to eql(true)
    end

    it "returns true if called with a valid cell and a board with a black queen on a white king" do
      black_queen = DummyPiece.new({
        color: :black,
        type: :queen,
        did_move: true
      })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][0] = black_queen
      board[7][4] = white_king

      res = white_king.is_checked?([7,4], board)
      expect(res).to eql(true)
    end

    it "returns true if called with a valid cell and a board with a black pawn on a white king" do
      black_pawn = DummyPiece.new({
        color: :black,
        type: :pawn,
        did_move: true
      })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][3] = black_pawn
      board[7][4] = white_king

      res = white_king.is_checked?([7,4], board)
      expect(res).to eql(true)
    end
  end

  describe "#moves" do
    it "returns the correct int matrix if called with a valid cell and an otherwise empty board on a white king" do
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][3] = white_king

      res = white_king.moves([4,3], board)
      expected = [
        [4,2],   # left cell
        [4,4],   # right cell
        [3,3],   # up cell
        [5,3],   # down cell
        [3,2],   # up left cell
        [3,4],   # up right cell
        [5,2],   # down left cell
        [5,4]    # down right cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and an otherwise empty board on a black king" do
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][3] = black_king

      res = black_king.moves([4,3], board)
      expected = [
        [4,2],   # left cell
        [4,4],   # right cell
        [3,3],   # up cell
        [5,3],   # down cell
        [3,2],   # up left cell
        [3,4],   # up right cell
        [5,2],   # down left cell
        [5,4]    # down right cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and a board with 3 white pawns, a white queen, and a white bishop on a white king" do
      white_pawn = DummyPiece.new({ color: :white, type: :pawn })
      white_bishop = DummyPiece.new({ color: :white, type: :bishop })
      white_queen = DummyPiece.new({ color: :white, type: :queen })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][3] = white_pawn
      board[6][4] = white_pawn
      board[6][5] = white_pawn
      board[7][3] = white_queen
      board[7][5] = white_bishop
      board[7][4] = white_king

      res = white_king.moves([7,4], board)
      expected = []
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and a board with 3 black pawns, a black queen, and a black bishop on a black king" do
      black_pawn = DummyPiece.new({ color: :black, type: :pawn })
      black_bishop = DummyPiece.new({ color: :black, type: :bishop })
      black_queen = DummyPiece.new({ color: :black, type: :queen })
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[1][3] = black_pawn
      board[1][4] = black_pawn
      board[1][5] = black_pawn
      board[0][3] = black_queen
      board[0][5] = black_bishop
      board[0][4] = black_king

      res = black_king.moves([0,4], board)
      expected = []
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and a board with a black rook on a white king" do
      black_rook = DummyPiece.new({
        color: :black,
        type: :rook,
        did_move: true
      })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][4] = black_rook
      board[7][4] = white_king

      res = white_king.moves([7,4], board)
      expected = [
        [7,3],   # left cell
        [7,5],   # right cell
        [6,3],   # up left cell
        [6,5],   # up right cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and a board with a white rook on a black king" do
      white_rook = DummyPiece.new({
        color: :white,
        type: :rook,
        did_move: true
      })
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = white_rook
      board[0][4] = black_king

      res = black_king.moves([0,4], board)
      expected = [
        [0,3],   # left cell
        [0,5],   # right cell
        [1,3],   # down left cell
        [1,5],   # down right cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end
  end

  describe "#captures" do
    it "returns an empty int matrix if called with a valid cell and an otherwise empty board on a white king" do
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][3] = white_king

      res = white_king.captures([4,3], board)
      expect(res.size).to eql(0)
      expect(res).to eql([])
    end

    it "returns the correct int matrix if called with a valid cell and a board with a black pawn on a white king" do
      black_pawn = DummyPiece.new({ color: :black, type: :pawn })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][2] = black_pawn
      board[4][3] = white_king

      res = white_king.captures([4,3], board)
      expected = [
        [4,2]    # left cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |capture|
        expect(res.include?(capture)).to eql(true)
      end
    end

    it "returns an empty int matrix if called with a valid cell and a board with a black pawn on a white king" do
      black_pawn = DummyPiece.new({ color: :black, type: :pawn })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][1] = black_pawn
      board[4][3] = white_king

      res = white_king.captures([4,3], board)
      expected = []
      expect(res.size).to eql(expected.size)
      expected.each do |capture|
        expect(res.include?(capture)).to eql(true)
      end
    end

    it "returns an empty int matrix if called with a valid cell and a board with a black queen and a black pawn on a white king" do
      black_queen = DummyPiece.new({ color: :black, type: :queen })
      black_pawn = DummyPiece.new({ color: :black, type: :pawn })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][1] = black_queen
      board[4][2] = black_pawn
      board[4][3] = white_king

      res = white_king.captures([4,3], board)
      expected = []
      expect(res.size).to eql(expected.size)
      expected.each do |capture|
        expect(res.include?(capture)).to eql(true)
      end
    end
  end
end
