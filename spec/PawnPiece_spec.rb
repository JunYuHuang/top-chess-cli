require './lib/PawnPiece'
require './spec/DummyPiece'

describe PawnPiece do
  describe "#initialize" do
    it "returns a non-nil object if called" do
      pawn = PawnPiece.new
      expect(pawn).to_not eql(nil)
    end
  end

  describe "#moves" do
    it "returns the correct int matrix if called with a valid cell and an otherwise empty board on a white pawn that has not moved yet" do
      empty_piece = DummyPiece.new({ color: :none, type: :empty })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, empty_piece) }
      board[6][3] = white_pawn

      res = white_pawn.moves([6,3], board)
      expected = [
        [5,3],   # up 1 step cell
        [4,3],   # up 2 steps cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and an otherwise empty board on a white pawn that has moved" do
      empty_piece = DummyPiece.new({ color: :none, type: :empty })
      white_pawn = PawnPiece.new({ color: :white, did_move: true })
      board = Array.new(8) { Array.new(8, empty_piece) }
      board[4][6] = white_pawn

      res = white_pawn.moves([4,6], board)
      expected = [
        [3,6],   # up 1 step cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and an otherwise empty board on a black pawn that has not moved yet" do
      empty_piece = DummyPiece.new({ color: :none, type: :empty })
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, empty_piece) }
      board[1][3] = black_pawn

      res = black_pawn.moves([1,3], board)
      expected = [
        [2,3],   # down 1 step cell
        [3,3],   # down 2 steps cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and an otherwise empty board on a black pawn that has moved" do
      empty_piece = DummyPiece.new({ color: :none, type: :empty })
      black_pawn = PawnPiece.new({ color: :black, did_move: true })
      board = Array.new(8) { Array.new(8, empty_piece) }
      board[3][6] = black_pawn

      res = black_pawn.moves([3,6], board)
      expected = [
        [4,6],   # down 1 step cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and an otherwise empty board on a white pawn that has not moved yet with a black pawn in the cell directly above it" do
      empty_piece = DummyPiece.new({ color: :none, type: :empty })
      black_pawn = DummyPiece.new({ color: :black, did_move: true })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, empty_piece) }
      board[5][3] = black_pawn
      board[6][3] = white_pawn

      res = white_pawn.moves([6,3], board)
      expected = []
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and an otherwise empty board on a white pawn that has not moved yet with a black pawn in the cell above the cell directly above it" do
      empty_piece = DummyPiece.new({ color: :none, type: :empty })
      black_pawn = DummyPiece.new({ color: :black, did_move: true })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, empty_piece) }
      board[4][3] = black_pawn
      board[6][3] = white_pawn

      res = white_pawn.moves([6,3], board)
      expected = [
        [5,3],   # up 1 step cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end
  end
end
