require './lib/Game'
require './lib/PieceFactory'

describe Game do
  describe "#initialize" do
    it "returns a non-nil object if called" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      expect(game).to_not eql(nil)
    end

    # TODO - add more tests with different options
  end

  describe "#build_start_board" do
    it "returns the correct matrix of Piece objects if called" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      res = game.build_start_board
      rows = 8
      cols = 8
      exp = Array.new(rows) { Array.new(cols, nil) }
      cols.times do |c|
        exp[0][c] = PieceFactory.create(:rook, { color: :black }) if (c == 0 or c == 7)
        exp[0][c] = PieceFactory.create(:knight, { color: :black }) if (c == 1 or c == 6)
        exp[0][c] = PieceFactory.create(:bishop, { color: :black }) if (c == 2 or c == 5)
        exp[0][3] = PieceFactory.create(:queen, { color: :black })
        exp[0][4] = PieceFactory.create(:king, { color: :black })
        exp[1][c] = PieceFactory.create(:pawn, { color: :black })
        exp[6][c] = PieceFactory.create(:pawn, { color: :white })
        exp[7][c] = PieceFactory.create(:rook, { color: :white }) if (c == 0 or c == 7)
        exp[7][c] = PieceFactory.create(:knight, { color: :white }) if (c == 1 or c == 6)
        exp[7][c] = PieceFactory.create(:bishop, { color: :white }) if (c == 2 or c == 5)
        exp[7][3] = PieceFactory.create(:queen, { color: :white })
        exp[7][4] = PieceFactory.create(:king, { color: :white })
      end

      rows.times do |r|
        cols.times do |c|
          next if exp[r][c].nil?
          expect(res[r][c].color).to eql(exp[r][c].color)
          expect(res[r][c].type).to eql(exp[r][c].type)
        end
      end
    end
  end
end
