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

  describe "#are_valid_pieces?" do
    it "returns false if called with nil" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      pieces = nil
      res = game.are_valid_pieces?(pieces)
      expect(res).to eql(false)
    end

    it "returns false if called with an array of size 64" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      pieces = Array.new(64, nil)
      res = game.are_valid_pieces?(pieces)
      expect(res).to eql(false)
    end

    it "returns false if called with an int array " do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      pieces = Array.new(5, 1)
      res = game.are_valid_pieces?(pieces)
      expect(res).to eql(false)
    end

    it "returns false if called with a hash array that has a piece hash that is missing any of the 4 required key-value pairs" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      pieces = [
        { cell: [1,0], color: :black, type: :pawn, is_cap: "lol" }
      ]
      res = game.are_valid_pieces?(pieces)
      expect(res).to eql(false)
    end

    it "returns false if called with a hash array that has a piece hash that has a string `:cell` value" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      pieces = [
        {
          cell: "lol",
          color: :black,
          type: :pawn,
          is_capturable: true
        }
      ]
      res = game.are_valid_pieces?(pieces)
      expect(res).to eql(false)
    end

    it "returns false if called with a hash array that has a piece hash that has a non-int array `:cell` value" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      pieces = [
        {
          cell: ["l", "o"],
          color: :black,
          type: :pawn,
          is_capturable: true
        }
      ]
      res = game.are_valid_pieces?(pieces)
      expect(res).to eql(false)
    end

    it "returns false if called with a hash array that has a piece hash whose `:cell` value represents an out-of-bounds position on the chess board" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      pieces = [
        {
          cell: [0,8],
          color: :black,
          type: :pawn,
          is_capturable: true
        }
      ]
      res = game.are_valid_pieces?(pieces)
      expect(res).to eql(false)
    end

    it "returns true if called with a hash array that has a piece hash that represents a valid black knight" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      pieces = [
        {
          cell: [0,1],
          color: :black,
          type: :knight,
          is_capturable: true
        }
      ]
      res = game.are_valid_pieces?(pieces)
      expect(res).to eql(true)
    end

    it "returns false if called with a hash array that has a piece hash that represents a black rook whose `:did_move` value is nil" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      pieces = [
        {
          cell: [0,0],
          color: :black,
          type: :rook,
          is_capturable: true,
          did_move: nil,
        }
      ]
      res = game.are_valid_pieces?(pieces)
      expect(res).to eql(false)
    end

    it "returns false if called with a hash array that has a piece hash that represents a black pawn whose `:did_double_step` value is nil" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      pieces = [
        {
          cell: [1,0],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: false,
          did_double_step: nil
        }
      ]
      res = game.are_valid_pieces?(pieces)
      expect(res).to eql(false)
    end

    it "returns true if called with a hash array that has a certain valid piece hash that represents a black queen" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      pieces = [
        {
          cell: [0,3],
          color: :black,
          type: :queen,
          is_capturable: true,
        }
      ]
      res = game.are_valid_pieces?(pieces)
      expect(res).to eql(true)
    end

    it "returns true if called with a hash array that has 2 certain valid piece hashes" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      pieces = [
        {
          cell: [1,0],
          color: :black,
          type: :pawn,
          is_capturable: true,
        },
        {
          cell: [7,0],
          color: :white,
          type: :pawn,
          is_capturable: true,
        }
      ]
      res = game.are_valid_pieces?(pieces)
      expect(res).to eql(true)
    end
  end

  describe "#build_board" do
    it "returns the correct matrix of Piece objects if called with a certain array of valid piece hashes" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      pieces = [
        {
          cell: [0,0], color: :black, type: :rook,
          is_capturable: true,
        },
        {
          cell: [0,1], color: :black, type: :knight,
          is_capturable: true,
        },
        {
          cell: [0,2], color: :black, type: :bishop,
          is_capturable: true,
        },
        {
          cell: [0,3], color: :black, type: :queen,
          is_capturable: true,
        },
        {
          cell: [0,4], color: :black, type: :king,
          is_capturable: false,
        },
        {
          cell: [1,0], color: :black, type: :pawn,
          is_capturable: true,
        },
        {
          cell: [6,0], color: :white, type: :pawn,
          is_capturable: true,
        },
        {
          cell: [7,0], color: :white, type: :rook,
          is_capturable: true,
        },
        {
          cell: [7,1], color: :white, type: :knight,
          is_capturable: true,
        },
        {
          cell: [7,2], color: :white, type: :bishop,
          is_capturable: true,
        },
        {
          cell: [7,3], color: :white, type: :queen,
          is_capturable: true,
        },
        {
          cell: [7,4], color: :white, type: :king,
          is_capturable: false,
        },
      ]
      res = game.build_board(pieces)

      rows = 8
      cols = 8
      exp = Array.new(rows) { Array.new(cols, nil) }
      exp[0][0] = PieceFactory.create(:rook, { color: :black })
      exp[0][1] = PieceFactory.create(:knight, { color: :black })
      exp[0][2] = PieceFactory.create(:bishop, { color: :black })
      exp[0][3] = PieceFactory.create(:queen, { color: :black })
      exp[0][4] = PieceFactory.create(:king, { color: :black })
      exp[1][0] = PieceFactory.create(:pawn, { color: :black })
      exp[6][0] = PieceFactory.create(:pawn, { color: :white })
      exp[7][0] = PieceFactory.create(:rook, { color: :white })
      exp[7][1] = PieceFactory.create(:knight, { color: :white })
      exp[7][2] = PieceFactory.create(:bishop, { color: :white })
      exp[7][3] = PieceFactory.create(:queen, { color: :white })
      exp[7][4] = PieceFactory.create(:king, { color: :white })

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
