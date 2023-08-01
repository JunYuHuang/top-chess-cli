require './lib/Player'

describe Player do
  describe "#initialize" do
    it "returns a non-nil object if called" do
      expect(Player.new).to_not eql(nil)
    end
  end

  describe "#to_s" do
    it "returns the correct string if called on a Player object with no set '@name' property" do
      player = Player.new
      expect(player.to_s).to eql("Unnamed Player")
    end

    it "returns the correct string if called on a Player object with a hash that has a nil name" do
      player = Player.new({ name: nil })
      expect(player.to_s).to eql("INVALID_COLOR (Invalid Player)")
    end

    it "returns the correct string if called on a Player object with a set '@name' property" do
      player = Player.new({ name: "Bagool" })
      expect(player.to_s).to eql("Bagool")
    end
  end

  describe "#to_hash" do
    it "returns the correct hash if called on a Player object instantiated with no explicit arguments" do
      player = Player.new
      expected = {
        piece_color: :invalid_color,
        type: :invalid,
        name: "Unnamed Player",
      }
      expect(player.to_hash).to eql(expected)
    end

    it "returns the correct hash if called on a Player object instantiated with a certain valid hash argument" do
      options = {
        piece_color: :white,
        type: :human,
        name: "WHITE (Human Player 1)"
      }
      player = Player.new(options)
      expect(player.to_hash).to eql(options)
    end
  end
end
