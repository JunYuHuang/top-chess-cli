require './lib/RookPiece'
require './spec/DummyPiece'

describe RookPiece do
  describe "#initialize" do
    it "returns a non-nil object if called" do
      rook = RookPiece.new
      expect(rook).to_not eql(nil)
    end
  end

  describe "#moves" do
    # failing test due to issue with DummyPiece constructor
    it "returns the correct int matrix if called with a valid cell and an otherwise empty board" do
      empty_piece = DummyPiece.new({ type: :empty })
      white_pawn = DummyPiece.new({ color: :white, type: :pawn })
      black_pawn = DummyPiece.new({ color: :black, type: :pawn })
      white_rook = RookPiece.new({ did_move: true })
      board = Array.new(8) { Array.new(8, empty_piece) }
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
  end
end
