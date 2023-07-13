require './lib/HumanPlayer'

describe HumanPlayer do
  describe "#initialize" do
    it "returns a non-nil object if called" do
      human_player = HumanPlayer.new(nil, "Player 1", :white)
      expect(human_player).to_not eql(nil)
    end
  end

  describe "#initialize" do
    it "returns the correct string if called" do
      human_player = HumanPlayer.new(nil, "Player 1", :white)
      res = human_player.to_s
      exp = "WHITE (Player 1)"
      expect(res).to eql(exp)
    end
  end
end
