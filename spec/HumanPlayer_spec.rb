require './lib/HumanPlayer'

describe HumanPlayer do
  describe "#initialize" do
    it "returns a non-nil object if called" do
      human_player = HumanPlayer.new({ game: nil })
      expect(human_player).to_not eql(nil)
    end
  end

  describe "#to_s" do
    it "returns the correct string if called on a HumanPlayer object with no set '@name' property" do
      human_player = HumanPlayer.new({ game: nil })
      res = human_player.to_s
      exp = "WHITE (Human Player)"
      expect(res).to eql(exp)
    end

    it "returns the correct string if called on a HumanPlayer object with a set '@name' property" do
      human_player = HumanPlayer.new({
        game: nil, name: "Bagool"
      })
      res = human_player.to_s
      exp = "Bagool"
      expect(res).to eql(exp)
    end
  end
end
