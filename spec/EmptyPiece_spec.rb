require './lib/EmptyPiece'

describe EmptyPiece do
  describe ".type" do
    it "returns :empty if called on the class itself" do
      expect(EmptyPiece.type).to eql(:empty)
    end
  end

  describe ".is_interactive?" do
    it "returns false if called on the class itself" do
      expect(EmptyPiece.is_interactive?).to eql(false)
    end
  end

  describe ".is_capturable?" do
    it "returns false if called on the class itself" do
      expect(EmptyPiece.is_capturable?).to eql(false)
    end
  end
end
