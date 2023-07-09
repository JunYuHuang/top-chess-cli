require './lib/PieceFactory'
require './lib/BishopPiece'
require './lib/KingPiece'
require './lib/KnightPiece'
require './lib/PawnPiece'
require './lib/QueenPiece'
require './lib/RookPiece'

describe PieceFactory do
  describe "#initialize" do
    it "works if called properly" do
      pieces_dict = {
        bishop: BishopPiece,
        king: KingPiece,
        knight: KnightPiece,
        pawn: PawnPiece,
        queen: QueenPiece,
        rook: RookPiece
      }
      res = PieceFactory.new(pieces_dict)
      expect(res).not_to eql(nil)
    end
  end

  describe "#spawn" do
    it "returns nil if called with an invalid chess symbol" do
      piece_factory = PieceFactory.new({})
      dummy = piece_factory.spawn(:dummy)
      expect(dummy).to eql(nil)
    end

    # TODO - failing test
    it "returns the correct object if called with a valid chess symbol" do
      pieces_dict = {
        bishop: BishopPiece,
        king: KingPiece,
        knight: KnightPiece,
        pawn: PawnPiece,
        queen: QueenPiece,
        rook: RookPiece
      }
      piece_factory = PieceFactory.new(pieces_dict)
      pawn = piece_factory.spawn(:pawn)
      expect(pawn.class).to eql(PawnPiece)
    end
  end
end
