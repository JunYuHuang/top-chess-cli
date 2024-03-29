require './lib/KingPiece'
require './spec/MockPiece'

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

    it "returns false if called with a valid cell and a certain board with a black rook and a white pawn on a white king" do
      black_rook = MockPiece.new({
        color: :black,
        type: :rook,
        did_move: true
      })
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][4] = black_rook
      board[6][4] = white_pawn
      board[7][4] = white_king

      res = white_king.is_checked?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns true if called with a valid cell and a certain board with a black rook on a white king" do
      black_rook = MockPiece.new({
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

    it "returns true if called with a valid cell and a certain board with a white rook on a black king" do
      white_rook = MockPiece.new({
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

    it "returns true if called with a valid cell and a certain board with a black knight on a white king" do
      black_knight = MockPiece.new({
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

    it "returns true if called with a valid cell and a certain board with a black bishop on a white king" do
      black_bishop = MockPiece.new({
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

    it "returns true if called with a valid cell and a certain board with a black queen on a white king" do
      black_queen = MockPiece.new({
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

    it "returns true if called with a valid cell and a certain board with a black pawn on a white king" do
      black_pawn = MockPiece.new({
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

    it "returns the correct int matrix if called with a valid cell and a certain board with 3 white pawns, a white queen, and a white bishop on a white king" do
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      white_bishop = MockPiece.new({ color: :white, type: :bishop })
      white_queen = MockPiece.new({ color: :white, type: :queen })
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

    it "returns the correct int matrix if called with a valid cell and a certain board with 3 black pawns, a black queen, and a black bishop on a black king" do
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
      black_bishop = MockPiece.new({ color: :black, type: :bishop })
      black_queen = MockPiece.new({ color: :black, type: :queen })
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

    it "returns the correct int matrix if called with a valid cell and a certain board with a black rook on a white king" do
      black_rook = MockPiece.new({
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

    it "returns the correct int matrix if called with a valid cell and a certain board with a white rook on a black king" do
      white_rook = MockPiece.new({
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

    it "returns the correct int matrix if called with a valid cell and a certain board with a black pawn on a white king" do
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
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

    it "returns an empty int matrix if called with a valid cell and a certain board with a black pawn on a white king" do
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
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

    it "returns an empty int matrix if called with a valid cell and a certain board with a black queen and a black pawn on a white king" do
      black_queen = MockPiece.new({ color: :black, type: :queen })
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
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

  describe "#is_checkmated?" do
    it "returns false if called with a valid cell and an otherwise empty board on a white king" do
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[7][4] = white_king

      res = white_king.is_checkmated?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a white rook and a white king on a black king" do
      white_rook = MockPiece.new({ color: :white, type: :rook })
      white_king = KingPiece.new({ color: :white })
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = white_rook
      board[7][4] = white_king
      board[0][4] = black_king

      res = black_king.is_checkmated?([0,4], board)
      expect(res).to eql(false)
    end

    it "returns true if called with a valid cell and a certain board with a white rook and a white king on a black king" do
      white_rook = MockPiece.new({ color: :white, type: :rook })
      white_king = KingPiece.new({ color: :white })
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[0][4] = white_rook
      board[2][7] = white_king
      board[0][7] = black_king

      res = black_king.is_checkmated?([0,7], board)
      expect(res).to eql(true)
    end

    it "returns false if called with a valid cell and a certain board with a white rook and a white king on a black king" do
      white_rook = MockPiece.new({ color: :white, type: :rook })
      white_king = KingPiece.new({ color: :white })
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[2][6] = white_rook
      board[2][7] = white_king
      board[0][7] = black_king

      res = black_king.is_checkmated?([0,7], board)
      expect(res).to eql(false)
    end
  end

  describe "#is_stalemated?" do
    it "returns false if called with a valid cell and an otherwise empty board on a white king" do
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[7][4] = white_king

      res = white_king.is_stalemated?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a white rook and a white king on a black king" do
      white_rook = MockPiece.new({ color: :white, type: :rook })
      white_king = KingPiece.new({ color: :white })
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = white_rook
      board[7][4] = white_king
      board[0][4] = black_king

      res = black_king.is_stalemated?([0,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a white rook and a white king on a black king" do
      white_rook = MockPiece.new({ color: :white, type: :rook })
      white_king = KingPiece.new({ color: :white })
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[0][4] = white_rook
      board[2][7] = white_king
      board[0][7] = black_king

      res = black_king.is_stalemated?([0,7], board)
      expect(res).to eql(false)
    end

    it "returns true if called with a valid cell and a certain board with a white rook and a white king on a black king" do
      white_rook = MockPiece.new({ color: :white, type: :rook })
      white_king = KingPiece.new({ color: :white })
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[2][6] = white_rook
      board[2][7] = white_king
      board[0][7] = black_king

      res = black_king.is_stalemated?([0,7], board)
      expect(res).to eql(true)
    end

    it "returns false if called on a black king with a valid cell and a certain board with itself, a white rook, a white king, and 2 black pawns " do
      white_rook = MockPiece.new({ color: :white, type: :rook })
      white_king = KingPiece.new({ color: :white })
      black_king = KingPiece.new({ color: :black })
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
      board = Array.new(8) { Array.new(8, nil) }
      board[2][6] = white_rook
      board[2][7] = white_king
      board[0][7] = black_king
      board[1][6] = black_pawn
      board[1][7] = black_pawn

      res = black_king.is_stalemated?([0,7], board)
      expect(res).to eql(false)
    end

    it "returns false if called on a black king with a valid cell and a certain board with itself, a white rook, a white king, 2 black pawns, and a black queen" do
      white_rook = MockPiece.new({ color: :white, type: :rook })
      white_king = KingPiece.new({ color: :white })
      black_king = KingPiece.new({ color: :black })
      black_queen = MockPiece.new({ color: :black, type: :queen })
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
      board = Array.new(8) { Array.new(8, nil) }
      board[2][6] = white_rook
      board[2][7] = white_king
      board[0][7] = black_king
      board[1][5] = black_queen
      board[1][6] = black_pawn
      board[1][7] = black_pawn

      res = black_king.is_stalemated?([0,7], board)
      expect(res).to eql(false)
    end

    it "returns true if called on a black king with a valid cell and a certain board with itself, a white queen, and a white king" do
      white_queen = MockPiece.new({ color: :white, type: :queen })
      white_king = KingPiece.new({ color: :white, did_move: true })
      black_king = KingPiece.new({ color: :black, did_move: true })
      board = Array.new(8) { Array.new(8, nil) }
      board[2][6] = white_queen
      board[7][0] = white_king
      board[0][7] = black_king

      res = black_king.is_stalemated?([0,7], board)
      expect(res).to eql(true)
    end

    it "returns false if called on a black king with a valid cell and a certain board with itself, a black queen, a black bishop, and 3 black pawns" do
      black_queen = MockPiece.new({ color: :black, type: :queen })
      black_king = KingPiece.new({ color: :black })
      black_bishop = MockPiece.new({ color: :black, type: :bishop })
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
      board = Array.new(8) { Array.new(8, nil) }
      board[0][3] = black_queen
      board[0][4] = black_king
      board[0][5] = black_bishop
      board[1][3] = black_pawn
      board[1][4] = black_pawn
      board[1][5] = black_pawn

      res = black_king.is_stalemated?([0,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called on a white king with a valid cell and a certain board with itself, a white queen, a white bishop, and 3 white pawns" do
      white_queen = MockPiece.new({ color: :white, type: :queen })
      white_king = KingPiece.new({ color: :white })
      white_bishop = MockPiece.new({ color: :white, type: :bishop })
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      board = Array.new(8) { Array.new(8, nil) }
      board[7][3] = white_queen
      board[7][4] = white_king
      board[7][5] = white_bishop
      board[6][3] = white_pawn
      board[6][4] = white_pawn
      board[6][5] = white_pawn

      res = white_king.is_stalemated?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns true if called on a black king with a valid cell and a certain board with itself, a white pawn, and a white king" do
      black_king = KingPiece.new({ color: :black, did_move: true })
      white_king = KingPiece.new({ color: :white, did_move: true })
      white_pawn = MockPiece.new({
        color: :white, type: :pawn, did_move: true
      })
      board = Array.new(8) { Array.new(8, nil) }
      board[0][5] = black_king
      board[1][5] = white_pawn
      board[2][5] = white_king

      res = black_king.is_stalemated?([0,5], board)
      expect(res).to eql(true)
    end

    it "returns true if called on a black king with a valid cell and a certain board with itself, a black pawn, a white queen, and a white king" do
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
      black_king = KingPiece.new({ color: :black, did_move: true })
      white_king = KingPiece.new({ color: :white, did_move: true })
      white_queen = MockPiece.new({ color: :white, type: :queen })
      board = Array.new(8) { Array.new(8, nil) }
      board[7][0] = black_king
      board[6][0] = black_pawn
      board[5][1] = white_queen
      board[3][6] = white_king

      res = black_king.is_stalemated?([7,0], board)
      expect(res).to eql(true)
    end

    it "returns true if called on a black king with a valid cell and a certain board with itself, a white pawn, a white bishop, and a white king" do
      white_pawn = MockPiece.new({ color: :white, type: :pawn, did_move: true })
      black_king = KingPiece.new({ color: :black, did_move: true })
      white_king = KingPiece.new({ color: :white, did_move: true })
      white_bishop = MockPiece.new({ color: :white, type: :bishop })
      board = Array.new(8) { Array.new(8, nil) }
      board[0][0] = black_king
      board[1][0] = white_pawn
      board[4][5] = white_bishop
      board[2][0] = white_king

      res = black_king.is_stalemated?([0,0], board)
      expect(res).to eql(true)
    end
  end

  describe "#can_queenside_castle?" do
    it "returns false if called with an out-of-bounds cell and an otherwise empty board on a white king" do
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }

      res = white_king.can_queenside_castle?([1,8], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid but empty cell and an otherwise empty board on a white king" do
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }

      res = white_king.can_queenside_castle?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and an otherwise empty board on a white king that has moved" do
      white_king = KingPiece.new({ color: :white, did_move: true })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][4] = white_king

      res = white_king.can_queenside_castle?([6,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and an otherwise empty board with no left white rook on a white king" do
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[7][4] = white_king

      res = white_king.can_queenside_castle?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a left white rook that has moved on a white king" do
      left_white_rook = MockPiece.new({
        color: :white, type: :rook, did_move: true
      })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[7][0] = left_white_rook
      board[7][4] = white_king

      res = white_king.can_queenside_castle?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a left white rook and a black rook on a white king that is in check" do
      left_white_rook = MockPiece.new({
        color: :white, type: :rook
      })
      black_rook = MockPiece.new({ color: :black, type: :rook })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[2][4] = black_rook
      board[7][0] = left_white_rook
      board[7][4] = white_king

      res = white_king.can_queenside_castle?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a left white rook and a white bishop that blocks the white king from queenside castling on a white king" do
      left_white_rook = MockPiece.new({ color: :white, type: :rook })
      white_bishop = MockPiece.new({ color: :white, type: :bishop })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[7][2] = white_bishop
      board[7][0] = left_white_rook
      board[7][4] = white_king

      res = white_king.can_queenside_castle?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a left white rook and a black rook that would check the white king on cells the king would move across to queenside castle on a white king" do
      left_white_rook = MockPiece.new({
        color: :white, type: :rook
      })
      black_rook = MockPiece.new({ color: :black, type: :rook })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[2][3] = black_rook
      board[7][0] = left_white_rook
      board[7][4] = white_king

      res = white_king.can_queenside_castle?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a left white rook and a black rook that would check the white king on its destination queenside castle cell on a white king" do
      left_white_rook = MockPiece.new({
        color: :white, type: :rook
      })
      black_rook = MockPiece.new({ color: :black, type: :rook })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[2][2] = black_rook
      board[7][0] = left_white_rook
      board[7][4] = white_king

      res = white_king.can_queenside_castle?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns true if called with a valid cell and a certain board with an unmoved left white rook on a white king" do
      left_white_rook = MockPiece.new({ color: :white, type: :rook })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[7][0] = left_white_rook
      board[7][4] = white_king

      res = white_king.can_queenside_castle?([7,4], board)
      expect(res).to eql(true)
    end

    it "returns false if called with a valid cell and an otherwise empty board on a black king that has moved" do
      black_king = KingPiece.new({ color: :black, did_move: true })
      board = Array.new(8) { Array.new(8, nil) }
      board[0][4] = black_king

      res = black_king.can_queenside_castle?([0,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and an otherwise empty board with no left black rook on a black king" do
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[0][4] = black_king

      res = black_king.can_queenside_castle?([0,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a left black rook that has moved on a black king" do
      left_black_rook = MockPiece.new({
        color: :black, type: :rook, did_move: true
      })
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[0][0] = left_black_rook
      board[0][4] = black_king

      res = black_king.can_queenside_castle?([0,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a left black rook and a white rook on a black king that is in check" do
      left_black_rook = MockPiece.new({
        color: :black, type: :rook
      })
      white_rook = MockPiece.new({ color: :white, type: :rook })
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[5][4] = white_rook
      board[0][0] = left_black_rook
      board[0][4] = black_king

      res = black_king.can_queenside_castle?([0,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a left black rook and a black bishop that blocks the black king from queenside castling on a black king" do
      left_black_rook = MockPiece.new({ color: :black, type: :rook })
      black_bishop = MockPiece.new({ color: :black, type: :bishop })
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[0][2] = black_bishop
      board[0][0] = left_black_rook
      board[0][4] = black_king

      res = black_king.can_queenside_castle?([0,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a left black rook and a white rook that would check the black king on cells the king would move across to queenside castle on a black king" do
      left_black_rook = MockPiece.new({
        color: :black, type: :rook
      })
      white_rook = MockPiece.new({ color: :white, type: :rook })
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[5][3] = white_rook
      board[0][0] = left_black_rook
      board[0][4] = black_king

      res = black_king.can_queenside_castle?([0,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a left black rook and a white rook that would check the black king on its destination queenside castle cell on a black king" do
      left_black_rook = MockPiece.new({
        color: :black, type: :rook
      })
      white_rook = MockPiece.new({ color: :white, type: :rook })
      black_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[5][2] = white_rook
      board[0][0] = left_black_rook
      board[0][4] = black_king

      res = black_king.can_queenside_castle?([0,4], board)
      expect(res).to eql(false)
    end

    it "returns true if called with a valid cell and a certain board with an unmoved left black rook on a black king" do
      left_black_rook = MockPiece.new({ color: :black, type: :rook })
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[0][0] = left_black_rook
      board[0][4] = black_king

      res = black_king.can_queenside_castle?([0,4], board)
      expect(res).to eql(true)
    end
  end

  describe "#can_kingside_castle?" do
    it "returns false if called with an out-of-bounds cell and an otherwise empty board on a white king" do
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }

      res = white_king.can_kingside_castle?([1,8], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid but empty cell and an otherwise empty board on a white king" do
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }

      res = white_king.can_kingside_castle?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and an otherwise empty board on a white king that has moved" do
      white_king = KingPiece.new({ color: :white, did_move: true })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][4] = white_king

      res = white_king.can_kingside_castle?([6,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and an otherwise empty board with no right white rook on a white king" do
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[7][4] = white_king

      res = white_king.can_kingside_castle?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a right white rook that has moved on a white king" do
      right_white_rook = MockPiece.new({
        color: :white, type: :rook, did_move: true
      })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[7][7] = right_white_rook
      board[7][4] = white_king

      res = white_king.can_kingside_castle?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a right white rook and a black rook on a white king that is in check" do
      right_white_rook = MockPiece.new({
        color: :white, type: :rook
      })
      black_rook = MockPiece.new({ color: :black, type: :rook })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[2][4] = black_rook
      board[7][7] = right_white_rook
      board[7][4] = white_king

      res = white_king.can_kingside_castle?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a right white rook and a white bishop that blocks the white king from kingside castling on a white king" do
      right_white_rook = MockPiece.new({ color: :white, type: :rook })
      white_bishop = MockPiece.new({ color: :white, type: :bishop })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[7][5] = white_bishop
      board[7][7] = right_white_rook
      board[7][4] = white_king

      res = white_king.can_kingside_castle?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a right white rook and a black rook that would check the white king on cells the king would move across to kingside castle on a white king" do
      right_white_rook = MockPiece.new({
        color: :white, type: :rook
      })
      black_rook = MockPiece.new({ color: :black, type: :rook })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[2][5] = black_rook
      board[7][7] = right_white_rook
      board[7][4] = white_king

      res = white_king.can_kingside_castle?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a right white rook and a black rook that would check the white king on its destination kingside castle cell on a white king" do
      right_white_rook = MockPiece.new({
        color: :white, type: :rook
      })
      black_rook = MockPiece.new({ color: :black, type: :rook })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[2][6] = black_rook
      board[7][7] = right_white_rook
      board[7][4] = white_king

      res = white_king.can_kingside_castle?([7,4], board)
      expect(res).to eql(false)
    end

    it "returns true if called with a valid cell and a certain board with an unmoved right white rook on a white king" do
      right_white_rook = MockPiece.new({ color: :white, type: :rook })
      white_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[7][7] = right_white_rook
      board[7][4] = white_king

      res = white_king.can_kingside_castle?([7,4], board)
      expect(res).to eql(true)
    end

    it "returns false if called with a valid cell and an otherwise empty board on a black king that has moved" do
      black_king = KingPiece.new({ color: :black, did_move: true })
      board = Array.new(8) { Array.new(8, nil) }
      board[0][4] = black_king

      res = black_king.can_kingside_castle?([0,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and an otherwise empty board with no right black rook on a black king" do
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[0][4] = black_king

      res = black_king.can_kingside_castle?([0,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a right black rook that has moved on a black king" do
      right_black_rook = MockPiece.new({
        color: :black, type: :rook, did_move: true
      })
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[0][7] = right_black_rook
      board[0][4] = black_king

      res = black_king.can_kingside_castle?([0,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a right black rook and a white rook on a black king that is in check" do
      right_black_rook = MockPiece.new({
        color: :black, type: :rook
      })
      white_rook = MockPiece.new({ color: :white, type: :rook })
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[5][4] = white_rook
      board[0][7] = right_black_rook
      board[0][4] = black_king

      res = black_king.can_kingside_castle?([0,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a right black rook and a black bishop that blocks the black king from kingside castling on a black king" do
      right_black_rook = MockPiece.new({ color: :black, type: :rook })
      black_bishop = MockPiece.new({ color: :black, type: :bishop })
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[0][5] = black_bishop
      board[0][7] = right_black_rook
      board[0][4] = black_king

      res = black_king.can_kingside_castle?([0,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a right black rook and a white rook that would check the black king on cells the king would move across to kingside castle on a black king" do
      right_black_rook = MockPiece.new({
        color: :black, type: :rook
      })
      white_rook = MockPiece.new({ color: :white, type: :rook })
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[5][5] = white_rook
      board[0][7] = right_black_rook
      board[0][4] = black_king

      res = black_king.can_kingside_castle?([0,4], board)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell and a certain board with a right black rook and a white rook that would check the black king on its destination kingside castle cell on a black king" do
      right_black_rook = MockPiece.new({
        color: :black, type: :rook
      })
      white_rook = MockPiece.new({ color: :white, type: :rook })
      black_king = KingPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[5][6] = white_rook
      board[0][7] = right_black_rook
      board[0][4] = black_king

      res = black_king.can_kingside_castle?([0,4], board)
      expect(res).to eql(false)
    end

    it "returns true if called with a valid cell and a certain board with an unmoved right black rook on a black king" do
      right_black_rook = MockPiece.new({ color: :black, type: :rook })
      black_king = KingPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[0][7] = right_black_rook
      board[0][4] = black_king

      res = black_king.can_kingside_castle?([0,4], board)
      expect(res).to eql(true)
    end
  end

  describe "#move" do
    it "returns the correct board if called with all valid arguments on a white king" do
      board = Array.new(8) { Array.new(8, nil) }
      white_king = KingPiece.new({ color: :white })
      board[7][4] = white_king
      res = white_king.move([7,4], [6,4], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[6][4] = white_king
      expect(res).to eql(expected)
    end
  end

  describe "#capture" do
    it "returns the correct board if called with all valid arguments on a white king" do
      board = Array.new(8) { Array.new(8, nil) }
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
      white_king = KingPiece.new({ color: :white })
      board[6][4] = black_pawn
      board[7][4] = white_king
      res = white_king.capture([7,4], [6,4], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[6][4] = white_king
      expect(res).to eql(expected)
    end
  end

  describe "#queenside_castle" do
    it "returns the correct board if called with all valid arguments on a white king" do
      board = Array.new(8) { Array.new(8, nil) }
      white_king = KingPiece.new({ color: :white })
      board[7][4] = white_king
      res = white_king.queenside_castle([7,4], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[7][2] = white_king
      expect(res).to eql(expected)
    end

    it "returns the correct board if called with all valid arguments on a black king" do
      board = Array.new(8) { Array.new(8, nil) }
      black_king = KingPiece.new({ color: :black })
      board[0][4] = black_king
      res = black_king.queenside_castle([0,4], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[0][2] = black_king
      expect(res).to eql(expected)
    end
  end

  describe "#kingside_castle" do
    it "returns the correct board if called with all valid arguments on a white king" do
      board = Array.new(8) { Array.new(8, nil) }
      white_king = KingPiece.new({ color: :white })
      board[7][4] = white_king
      res = white_king.kingside_castle([7,4], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[7][6] = white_king
      expect(res).to eql(expected)
    end

    it "returns the correct board if called with all valid arguments on a black king" do
      board = Array.new(8) { Array.new(8, nil) }
      black_king = KingPiece.new({ color: :black })
      board[0][4] = black_king
      res = black_king.kingside_castle([0,4], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[0][6] = black_king
      expect(res).to eql(expected)
    end
  end
end
