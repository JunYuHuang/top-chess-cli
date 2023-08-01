require './lib/HumanPlayer'

describe HumanPlayer do
  describe "#initialize" do
    it "returns a non-nil object if called" do
      human_player = HumanPlayer.new({ game: nil })
      expect(human_player).to_not eql(nil)
    end
  end
end
