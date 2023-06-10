require './lib/Game'

describe Game do
  describe "#initialize" do
    it "returns a non-nil object if called" do
      game = Game.new
      expect(game).to_not eql(nil)
    end
  end
end
