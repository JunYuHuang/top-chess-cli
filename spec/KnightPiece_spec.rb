require './lib/KnightPiece'
require './spec/MockPiece'

describe KnightPiece do
  describe "#initialize" do
    it "returns a non-nil object if called" do
      knight = KnightPiece.new
      expect(knight).to_not eql(nil)
    end
  end

  describe "#moves" do
    it "returns the correct int matrix if called with a valid cell and an otherwise empty board" do
      white_knight = KnightPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = white_knight

      res = white_knight.moves([3,4], board)
      expected = [
        [2, 2],    # 2 lefts -> 1 up cell
        [4, 2],    # 2 lefts -> 1 down cell
        [2, 6],    # 2 rights -> 1 up cell
        [4, 6],    # 2 rights -> 1 down cell
        [1, 3],    # 2 ups -> 1 left cell
        [1, 5],    # 2 ups -> 1 right cell
        [5, 3],    # 2 downs -> 1 left cell
        [5, 5]     # 2 downs -> 1 right cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and a board with 2 white pawns and 2 black pawns" do
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
      white_knight = KnightPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[1][3] = black_pawn
      board[1][5] = black_pawn
      board[5][3] = white_pawn
      board[5][5] = white_pawn
      board[3][4] = white_knight

      res = white_knight.moves([3,4], board)
      expected = [
        [2, 2],    # 2 lefts -> 1 up cell
        [4, 2],    # 2 lefts -> 1 down cell
        [2, 6],    # 2 rights -> 1 up cell
        [4, 6],    # 2 rights -> 1 down cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end
  end

  describe "#captures" do
    it "returns an empty int matrix if called with a valid cell and an otherwise empty board" do
      white_knight = KnightPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = white_knight

      res = white_knight.captures([3,4], board)
      expect(res.size).to eql(0)
      expect(res).to eql([])
    end

    it "returns the correct int matrix if called with a valid cell and a board with 2 white pawns and 2 black pawns" do
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
      white_knight = KnightPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[1][3] = black_pawn
      board[1][5] = black_pawn
      board[5][3] = white_pawn
      board[5][5] = white_pawn
      board[3][4] = white_knight

      res = white_knight.captures([3,4], board)
      expected = [
        [1, 3],    # 2 ups -> 1 left cell
        [1, 5],    # 2 ups -> 1 right cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end
  end

  describe "#move" do
    it "returns the correct board if called with all valid arguments on a white knight" do
      board = Array.new(8) { Array.new(8, nil) }
      white_knight = KnightPiece.new({ color: :white })
      board[7][1] = white_knight
      res = white_knight.move([7,1], [5,2], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[5][2] = white_knight
      expect(res).to eql(expected)
    end
  end

  describe "#capture" do
    it "returns the correct board if called with all valid arguments on a white knight" do
      board = Array.new(8) { Array.new(8, nil) }
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
      white_knight = KnightPiece.new({ color: :white })
      board[5][2] = black_pawn
      board[7][1] = white_knight
      res = white_knight.capture([7,1], [5,2], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[5][2] = white_knight
      expect(res).to eql(expected)
    end
  end
end
