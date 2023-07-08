require './lib/BishopPiece'
require './spec/MockPiece'

describe BishopPiece do
  describe "#initialize" do
    it "returns a non-nil object if called" do
      bishop = BishopPiece.new
      expect(bishop).to_not eql(nil)
    end
  end

  describe "#moves" do
    it "returns the correct int matrix if called with a valid cell and an otherwise empty board" do
      white_bishop = BishopPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][3] = white_bishop

      res = white_bishop.moves([4,3], board)
      expected = [
        [3,2], [2,1], [1,0],          # up left cells
        [3,4], [2,5], [1,6], [0,7],   # up right cells
        [5,2], [6,1], [7,0],          # down left cells
        [5,4], [6,5], [7,6]           # down right cells
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and a board with 2 white pawns and 2 black pawns" do
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
      white_bishop = BishopPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[1][0] = black_pawn
      board[1][6] = black_pawn
      board[6][1] = white_pawn
      board[6][5] = white_pawn
      board[4][3] = white_bishop

      res = white_bishop.moves([4,3], board)
      expected = [
        [3,2], [2,1],   # up left cells
        [3,4], [2,5],   # up right cells
        [5,2],          # down left cells
        [5,4]           # down right cells
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end
  end

  describe "#captures" do
    it "returns an empty int matrix if called with a valid cell and an otherwise empty board" do
      white_bishop = BishopPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][3] = white_bishop

      res = white_bishop.captures([4,3], board)
      expect(res.size).to eql(0)
      expect(res).to eql([])
    end

    it "returns the correct int matrix if called with a valid cell and a board with 2 white pawns and 2 black pawns" do
      white_pawn = MockPiece.new({ color: :white, type: :pawn })
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
      white_bishop = BishopPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[1][0] = black_pawn
      board[1][6] = black_pawn
      board[6][1] = white_pawn
      board[6][5] = white_pawn
      board[4][3] = white_bishop

      res = white_bishop.captures([4,3], board)
      expected = [
        [1,0],  # up left cell
        [1,6]   # up right cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end
  end

  describe "#move" do
    it "returns the correct board if called with all valid arguments on a white bishop" do
      board = Array.new(8) { Array.new(8, nil) }
      white_bishop = BishopPiece.new({ color: :white })
      board[7][2] = white_bishop
      res = white_bishop.move([7,2], [5,0], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[5][0] = white_bishop
      expect(res).to eql(expected)
    end
  end

  describe "#capture" do
    it "returns the correct board if called with all valid arguments on a white bishop" do
      board = Array.new(8) { Array.new(8, nil) }
      black_pawn = MockPiece.new({ color: :black, type: :pawn })
      white_bishop = BishopPiece.new({ color: :white })
      board[5][0] = black_pawn
      board[7][2] = white_bishop
      res = white_bishop.capture([7,2], [5,0], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[5][0] = white_bishop
      expect(res).to eql(expected)
    end
  end
end
