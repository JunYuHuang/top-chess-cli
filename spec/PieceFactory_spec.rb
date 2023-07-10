require './lib/PieceFactory'

describe PieceFactory do
  describe "#create" do
    it "returns nil if called with an invalid chess symbol" do
      res = PieceFactory.create(:alien)
      expect(res).to eql(nil)
    end

    it "returns the correct piece object if called with a valid chess symbol" do
      pawn = PieceFactory.create(:pawn)
      expect(pawn).not_to eql(nil)
    end

    it "returns the correct piece object if called with a valid chess symbol and a valid options hash" do
      rook = PieceFactory.create(:rook, { did_move: true })
      expect(rook.did_move?).to eql(true)
    end
  end
end
