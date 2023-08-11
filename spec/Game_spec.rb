require './lib/Game'
require './lib/PieceFactory'
require './spec/MockPlayer'

describe Game do
  describe "#initialize" do
    it "returns a non-nil object if called" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      expect(game).to_not eql(nil)
    end

    it "returns a non-nil object and builds a custom board if called with a hash that contains a valid pieces array" do
      pieces = [
        {
          cell: [0,4], color: :black, type: :king,
          is_capturable: false,
        },
        {
          cell: [7,4], color: :white, type: :king,
          is_capturable: false,
        },
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      expect(game).to_not eql(nil)
      expect(game.board[0][3].nil?).to eql(true)
      expect(game.board[0][4].type).to eql(:king)
    end

    it "returns a non-nil object and adds 2 players to the game if called with a hash that contains a 'Player' subclass" do
      options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(options)
      expect(game).to_not eql(nil)
      expect(game.players.size).to eql(2)
    end
  end

  describe "#add_player!" do
    it "does nothing if called on a game that already has 2 players" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      mock_player = nil
      game.players = [mock_player, mock_player]
      game.add_player!(MockPlayer)
      expect(game.players.size).to eql(2)
    end

    it "adds the first player if called on a game that has 0 players" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      game.add_player!(MockPlayer)
      player_1 =  game.players[0]
      expect(game.players.size).to eql(1)
      expect(player_1.name).to eql("WHITE (Human Player 1)")
      expect(player_1.piece_color).to eql(:white)
    end

    it "adds the second player if called on a game that has 1 player" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      mock_player = nil
      game.players = [mock_player]
      game.add_player!(MockPlayer)
      player_2 =  game.players[1]
      expect(game.players.size).to eql(2)
      expect(player_2.name).to eql("BLACK (Human Player 2)")
      expect(player_2.piece_color).to eql(:black)
    end

    it "adds a player with custom parameters if called on a game with a Player class or subclass and a hash" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      player_options = {
        type: :alien, piece_color: :green,
        name: "GREEN (Alien Player)"
      }
      game.add_player!(MockPlayer, player_options)
      player_1 = game.players[0]
      expect(game.players.size).to eql(1)
      expect(player_1.name).to eql("GREEN (Alien Player)")
      expect(player_1.type).to eql(:alien)
      expect(player_1.piece_color).to eql(:green)
    end
  end

  describe "#remove_players!" do
    it "does nothing if called on a game with no players with a hash" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      delete_filters = { piece_color: :white }
      game.remove_players!(delete_filters)
      expect(game.players.size).to eql(0)
    end

    it "does nothing if called on a game with 1 player with an argument that is not a hash" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      game.players = [nil]
      delete_filters = nil
      game.remove_players!(delete_filters)
      expect(game.players.size).to eql(1)
    end

    it "removes the white player if called on a game that has 2 players with a certain filter hash object" do
      options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(options)
      delete_filters = { piece_color: :white }
      game.remove_players!(delete_filters)
      expect(game.players.size).to eql(1)
      expect(game.players[0].piece_color).to eql(:black)
    end

    it "removes the black computer player if called on a game that has 2 players with a certain filter hash object" do
      options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(options)
      game.players[1].type = :computer
      delete_filters = { piece_color: :black, type: :computer }
      game.remove_players!(delete_filters)
      expect(game.players.size).to eql(1)
      expect(game.players[0].piece_color).to eql(:white)
    end

    it "removes both human players if called on a game that has 2 players with a certain filter hash object" do
      options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(options)
      delete_filters = { type: :human }
      game.remove_players!(delete_filters)
      expect(game.players.size).to eql(0)
    end
  end

  describe "#player" do
    it "returns the white player if called with (:white) on a game that has 2 players" do
      options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(options)
      res = game.player(:white)
      expect(res.piece_color).to eql(:white)
    end

    it "returns the black player if called with (:black) on a game that has 2 players" do
      options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(options)
      res = game.player(:black)
      expect(res.piece_color).to eql(:black)
    end
  end

  describe "#switch_players!" do
    it "sets the game's player turn to :black if called on a game whose current player turn is set to :white" do
      options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(options)
      game.turn_color = :white
      game.switch_players!
      expect(game.turn_color).to eql(:black)
    end

    it "sets the game's player turn to :white if called on a game whose current player turn is set to :black" do
      options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(options)
      game.turn_color = :black
      game.switch_players!
      expect(game.turn_color).to eql(:white)
    end
  end

  describe "#did_player_win?" do
    it "returns false if called on a game with insufficient players" do
      options = {
        piece_factory_class: PieceFactory,
      }
      game = Game.new(options)
      mock_player = nil
      game.players = [mock_player]
      res = game.did_player_win?(:white)
      expect(res).to eql(false)
    end

    it "returns false if called with :white on a game with a certain board where the black king is checked but not checkmated" do
      pieces = [
        {
          cell: [0,4], color: :black, type: :king,
          is_capturable: false,
        },
        {
          cell: [3,4], color: :white, type: :rook,
          is_capturable: true, did_move: true
        },
        {
          cell: [7,4], color: :white, type: :king,
          is_capturable: false,
        },
      ]
      options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer,
        pieces: pieces
      }
      game = Game.new(options)
      res = game.did_player_win?(:white)
      expect(res).to eql(false)
    end

    it "returns true if called with :white on a game with a certain board where the black king is checkmated" do
      pieces = [
        {
          cell: [0,7], color: :black, type: :king,
          is_capturable: false, did_move: true
        },
        {
          cell: [0,4], color: :white, type: :rook,
          is_capturable: true, did_move: true
        },
        {
          cell: [2,7], color: :white, type: :king,
          is_capturable: false, did_move: true
        },
      ]
      options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer,
        pieces: pieces
      }
      game = Game.new(options)
      res = game.did_player_win?(:white)
      expect(res).to eql(true)
    end
  end

  describe "#did_tie?" do
    it "returns false if called on a game with insufficient players" do
      options = {
        piece_factory_class: PieceFactory,
      }
      game = Game.new(options)
      mock_player = nil
      game.players = [mock_player]
      res = game.did_tie?
      expect(res).to eql(false)
    end

    it "returns false if called on a game with a certain board where the black king is checked but not checkmated" do
      pieces = [
        {
          cell: [0,4], color: :black, type: :king,
          is_capturable: false,
        },
        {
          cell: [3,4], color: :white, type: :rook,
          is_capturable: true, did_move: true
        },
        {
          cell: [7,4], color: :white, type: :king,
          is_capturable: false,
        },
      ]
      options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer,
        pieces: pieces
      }
      game = Game.new(options)
      res = game.did_tie?
      expect(res).to eql(false)
    end

    it "returns false if called on a game with a certain board where the black king is checkmated" do
      pieces = [
        {
          cell: [0,7], color: :black, type: :king,
          is_capturable: false, did_move: true
        },
        {
          cell: [0,4], color: :white, type: :rook,
          is_capturable: true, did_move: true
        },
        {
          cell: [2,7], color: :white, type: :king,
          is_capturable: false, did_move: true
        },
      ]
      options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer,
        pieces: pieces
      }
      game = Game.new(options)
      res = game.did_tie?
      expect(res).to eql(false)
    end

    it "returns true if called on a game with a certain board where the black king is stalemated" do
      pieces = [
        {
          cell: [0,7], color: :black, type: :king,
          is_capturable: false, did_move: true
        },
        {
          cell: [2,6], color: :white, type: :rook,
          is_capturable: true, did_move: true
        },
        {
          cell: [2,7], color: :white, type: :king,
          is_capturable: false, did_move: true
        },
      ]
      options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer,
        pieces: pieces
      }
      game = Game.new(options)
      res = game.did_tie?
      expect(res).to eql(true)
    end

    it "returns true if called on a game with a certain board where the white king is stalemated" do
      pieces = [
        {
          cell: [5,0], color: :black, type: :king,
          is_capturable: false, did_move: true
        },
        {
          cell: [5,1], color: :black, type: :rook,
          is_capturable: true, did_move: true
        },
        {
          cell: [7,0], color: :white, type: :king,
          is_capturable: false, did_move: true
        },
      ]
      options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer,
        pieces: pieces
      }
      game = Game.new(options)
      res = game.did_tie?
      expect(res).to eql(true)
    end
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

    it "returns false if called with a hash array that has a piece hash that represents a black pawn whose `:is_capturable_en_passant` value is nil" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      pieces = [
        {
          cell: [1,0],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: false,
          is_capturable_en_passant: nil
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

  describe "#build_pieces" do
    it "returns the correct array of hashes if called on a valid game with a custom board" do
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
          cell: [7,4], color: :white, type: :king,
          is_capturable: false,
        },
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      res = game.build_pieces

      expected = [
        {
          cell: [0,0], color: :black, type: :rook,
          is_capturable: true, did_move: false
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
          is_capturable: false, did_move: false
        },
        {
          cell: [1,0], color: :black, type: :pawn,
          is_capturable: true, did_move: false,
          is_capturable_en_passant: false
        },
        {
          cell: [7,4], color: :white, type: :king,
          is_capturable: false, did_move: false
        },
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |piece_hash|
        expect(res.include?(piece_hash)).to eql(true)
      end
    end

    it "returns an empty array if called on a valid game with a custom board with no pieces" do
      options = {
        piece_factory_class: PieceFactory,
        pieces: []
      }
      game = Game.new(options)
      res = game.build_pieces
      expect(res.size).to eql(0)
    end
  end

  describe "#simple_state" do
    it "returns nil if called on a valid game with insufficient players" do
      options = {
        piece_factory_class: PieceFactory,
      }
      game = Game.new(options)
      res = game.simple_state
      expect(res).to eql(nil)
    end

    it "returns the correct hash if called on a valid game with 2 players and a custom board" do
      pieces = [
        {
          cell: [0,4], color: :black, type: :king,
          is_capturable: false
        },
        {
          cell: [3,4], color: :white, type: :rook,
          is_capturable: true, did_move: true
        },
        {
          cell: [7,4], color: :white, type: :king,
          is_capturable: false
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer,
        pieces: pieces,
        turn_color: :black,
        white_captured: {
          pawn: 8, bishop: 2, knight: 2, rook: 2, queen: 1
        },
        black_captured: {
          pawn: 8, bishop: 2, knight: 2, rook: 1, queen: 1
        }
      }
      game = Game.new(options)
      res = game.simple_state
      expected = {
        turn_color: :black,
        players: [
          {
            piece_color: :white, type: :human,
            name: "WHITE (Human Player 1)"
          },
          {
            piece_color: :black, type: :human,
            name: "BLACK (Human Player 2)"
          }
        ],
        pieces: [
          {
            cell: [0,4], color: :black, type: :king,
            is_capturable: false, did_move: false
          },
          {
            cell: [3,4], color: :white, type: :rook,
            is_capturable: true, did_move: true
          },
          {
            cell: [7,4], color: :white, type: :king,
            is_capturable: false, did_move: false
          }
        ],
        white_captured: {
          pawn: 8, bishop: 2, knight: 2, rook: 2, queen: 1
        },
        black_captured: {
          pawn: 8, bishop: 2, knight: 2, rook: 1, queen: 1
        }
      }
      expect(res).to eql(expected)
    end
  end

  describe "#add_captured_piece!" do
    it "does nothing if called with an invalid cell on a valid game with the default starting board" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      game.add_captured_piece!([0,9])
      expect(game.white_captured.size).to eql(0)
      expect(game.black_captured.size).to eql(0)
    end

    it "does nothing if called with an empty cell on a valid game with the default starting board" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      game.add_captured_piece!([3,0])
      expect(game.white_captured.size).to eql(0)
      expect(game.black_captured.size).to eql(0)
    end

    it "modifies the game state properly if called with a valid cell that has a piece on it on a valid game with a custom board" do
      pieces = [
        {
          cell: [3,4],
          color: :white,
          type: :rook,
          is_capturable: true,
          did_move: true
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      game.add_captured_piece!([3,4])
      expect(game.white_captured.size).to eql(0)
      expect(game.black_captured.size).to eql(1)
      expect(game.black_captured[:rook]).to eql(1)
    end

    it "modifies the game state properly if called with a valid cell that has a piece on it on a valid game with a custom board" do
      pieces = [
        {
          cell: [5,3],
          color: :black,
          type: :queen,
          is_capturable: true
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      game.add_captured_piece!([5,3])
      expect(game.white_captured.size).to eql(1)
      expect(game.white_captured[:queen]).to eql(1)
      expect(game.black_captured.size).to eql(0)
    end
  end
end
