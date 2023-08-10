require './lib/Game'
require './lib/PieceFactory'
require './lib/ChessMoveRunner'
require './spec/MockPlayer'
require './lib/ComputerPlayer'

describe ComputerPlayer do
  describe "#initialize" do
    it "returns a non-nil object if called" do
      mock_args = { game: nil }
      expect(ComputerPlayer.new(mock_args)).to_not eql(nil)
    end

    it "returns a non-nil object if called with a valid game" do
      options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer,
        human_player_class: MockPlayer,
        chess_move_runner_class: ChessMoveRunner
      }
      game = Game.new(options)
      game.remove_players!({ color: :white })
      args = { game: game, piece_color: :white }
      expect(ComputerPlayer.new(args)).to_not eql(nil)
    end
  end

  describe "#random_item" do
    it "returns nil if called with a non-array" do
      args = { game: nil }
      computer_player = ComputerPlayer.new(args)
      res = computer_player.random_item({})
      expect(res).to eql(nil)
    end

    it "returns nil if called with an empty array" do
      args = { game: nil }
      computer_player = ComputerPlayer.new(args)
      res = computer_player.random_item([])
      expect(res).to eql(nil)
    end

    it "returns the first element if called with an array of size 1" do
      args = { game: nil }
      computer_player = ComputerPlayer.new(args)
      res = computer_player.random_item([1])
      expect(res).to eql(1)
    end

    it "returns a random element if called with an array that has 2 or more elements" do
      args = { game: nil }
      computer_player = ComputerPlayer.new(args)
      res = computer_player.random_item([1,2,3])
      expected = [1,2,3]
      expect(expected.include?(res)).to eql(true)
    end
  end

  describe "#random_piece" do
    it "returns a hash that represents a random chess piece that can be played in the current turn and is the same color as the ComputerPlayer object it is called on for a game with the default starting board" do
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      res = computer_player.random_piece
      res_moves = res[:piece].moves(res[:cell], game.board)
      expected_types = [:pawn, :knight]
      expect(res.class).to eql(Hash)
      expect(res[:piece].color).to eql(:white)
      expect(expected_types.include?(res[:piece].type)).to eql(true)
      expect(res_moves.size > 0).to eql(true)
    end
  end

  describe "#random_capture" do
    it "returns nil if called with a piece that has no available captures for a game with the default starting board" do
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      piece = { piece: game.board[6][0], cell: [6,0] }
      res = computer_player.random_capture(piece)
      expect(res).to eql(nil)
    end

    it "returns nil if called with a piece that is not owned by the ComputerPlayer obj that calls it and that has no available captures for a game with a certain board with 2 pieces" do
      pieces = [
        {
          cell: [1,4],
          color: :white,
          type: :rook,
          is_capturable: true,
        },
        {
          cell: [2,3],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner,
        pieces: pieces
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      piece = { piece: game.board[2][3], cell: [2,3] }
      res = computer_player.random_capture(piece)
      expect(res).to eql(nil)
    end

    it "returns nil if called with a piece that has no available captures for a game with a certain board with 2 pieces" do
      pieces = [
        {
          cell: [1,4],
          color: :white,
          type: :rook,
          is_capturable: true,
        },
        {
          cell: [2,3],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner,
        pieces: pieces
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      piece = { piece: game.board[2][3], cell: [2,3] }
      res = computer_player.random_capture(piece)
      expect(res).to eql(nil)
    end

    it "returns a legal Long AN string if called with a piece that has at least 1 available capture for a game with a certain board with 3 pieces" do
      pieces = [
        {
          cell: [1,2],
          color: :black,
          type: :bishop,
          is_capturable: true,
        },
        {
          cell: [1,4],
          color: :black,
          type: :rook,
          is_capturable: true,
        },
        {
          cell: [2,3],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner,
        pieces: pieces
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      piece = { piece: game.board[2][3], cell: [2,3] }
      res = computer_player.random_capture(piece)
      expected = ['d6xe7', 'd6xc7']
      expect(expected.include?(res)).to eql(true)
    end
  end

  describe "#random_move" do
    it "returns nil if called with a piece that has no available moves for a game with the default starting board" do
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      piece = { piece: game.board[7][0], cell: [7,0] }
      res = computer_player.random_move(piece)
      expect(res).to eql(nil)
    end

    it "returns nil if called with a piece that is not owned by the ComputerPlayer obj that calls it and has at least 1 available move for a game with a certain board with 2 pieces" do
      pieces = [
        {
          cell: [1,4],
          color: :white,
          type: :rook,
          is_capturable: true,
        },
        {
          cell: [2,3],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner,
        pieces: pieces
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      piece = { piece: game.board[2][3], cell: [2,3] }
      res = computer_player.random_move(piece)
      expect(res).to eql(nil)
    end

    it "returns nil if called with a piece that has no available moves for a game with a certain board with 2 pieces" do
      pieces = [
        {
          cell: [1,3],
          color: :black,
          type: :bishop,
          is_capturable: true,
        },
        {
          cell: [2,3],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner,
        pieces: pieces
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      piece = { piece: game.board[2][3], cell: [2,3] }
      res = computer_player.random_move(piece)
      expect(res).to eql(nil)
    end

    it "returns a legal Long AN string if called with a piece that has at least 1 available move for a game with a certain board with 3 pieces" do
      pieces = [
        {
          cell: [0,0],
          color: :black,
          type: :rook,
          is_capturable: true,
        },
        {
          cell: [4,7],
          color: :black,
          type: :bishop,
          is_capturable: true,
        },
        {
          cell: [6,0],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: false,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner,
        pieces: pieces
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      piece = { piece: game.board[6][0], cell: [6,0] }
      res = computer_player.random_move(piece)
      expected = ['a2-a3', 'a2-a4']
      expect(expected.include?(res)).to eql(true)
    end
  end

  describe "#capture_en_passant" do
    it "returns nil if called with a pawn that has no available en-passant capture for a game with the default starting board" do
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      pawn = { piece: game.board[6][0], cell: [6,0] }
      res = computer_player.capture_en_passant(pawn)
      expect(res).to eql(nil)
    end

    it "returns nil if called with a pawn that is not owned by the ComputerPlayer obj that calls it with a certain board with 2 pieces" do
      pieces = [
        {
          cell: [4,3],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
          is_capturable_en_passant: false
        },
        {
          cell: [4,2],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner,
        pieces: pieces
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      pawn = { piece: game.board[4][2], cell: [4,2] }
      res = computer_player.capture_en_passant(pawn)
      expect(res).to eql(nil)
    end

    it "returns nil if called with a pawn that has no available en-passant capture for a game with a certain board with 2 pieces" do
      pieces = [
        {
          cell: [3,4],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
          is_capturable_en_passant: false
        },
        {
          cell: [3,5],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner,
        pieces: pieces
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      pawn = { piece: game.board[3][5], cell: [3,5] }
      res = computer_player.capture_en_passant(pawn)
      expect(res).to eql(nil)
    end

    it "returns the legal Long AN string if called with a pawn that has an available en-passant capture for a game with a certain board with 3 pieces" do
      pieces = [
        {
          cell: [3,4],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
          is_capturable_en_passant: false
        },
        {
          cell: [3,6],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
          is_capturable_en_passant: true
        },
        {
          cell: [3,5],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner,
        pieces: pieces
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      piece = { piece: game.board[3][5], cell: [3,5] }
      res = computer_player.capture_en_passant(piece)
      expect(res).to eql('f5xg6')
    end
  end

  describe "#random_promote" do
    it "returns nil if called with a pawn that has no available promotions for a game with the default starting board" do
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      pawn = { piece: game.board[6][0], cell: [6,0] }
      res = computer_player.random_promote(pawn)
      expect(res).to eql(nil)
    end

    it "returns nil if called with a pawn that is not owned by the ComputerPlayer obj that calls it with a certain board with 2 pieces" do
      pieces = [
        {
          cell: [6,3],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        },
        {
          cell: [7,3],
          color: :white,
          type: :knight,
          is_capturable: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner,
        pieces: pieces
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      pawn = { piece: game.board[6][3], cell: [6,3] }
      res = computer_player.random_promote(pawn)
      expect(res).to eql(nil)
    end

    it "returns nil if called with a pawn that has no available promotions for a game with a certain board with 3 pieces" do
      pieces = [
        {
          cell: [0,5],
          color: :black,
          type: :bishop,
          is_capturable: true
        },
        {
          cell: [1,5],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner,
        pieces: pieces
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      pawn = { piece: game.board[1][5], cell: [1,5] }
      res = computer_player.random_promote(pawn)
      expect(res).to eql(nil)
    end

    it "returns a legal Long AN string if called with a pawn that has at least 1 available promotion for a game with a certain board with 3 pieces" do
      pieces = [
        {
          cell: [0,6],
          color: :black,
          type: :bishop,
          is_capturable: true
        },
        {
          cell: [0,4],
          color: :black,
          type: :queen,
          is_capturable: true
        },
        {
          cell: [1,5],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner,
        pieces: pieces
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      pawn = { piece: game.board[1][5], cell: [1,5] }
      expected = [
        'f7-f8=R', 'f7-f8=N', 'f7-f8=B', 'f7-f8=Q',
        'f7xe8=R', 'f7xe8=N', 'f7xe8=B', 'f7xe8=Q',
        'f7xg8=R', 'f7xg8=N', 'f7xg8=B', 'f7xg8=Q',
      ]
      res = computer_player.random_promote(pawn)
      expect(expected.include?(res)).to eql(true)
    end
  end

  describe "#queenside_castle" do
    it "returns nil if called with a king that cannot queenside castle for a game with the default starting board" do
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      king = { piece: game.board[7][4], cell: [7,4] }
      res = computer_player.queenside_castle(king)
      expect(res).to eql(nil)
    end

    it "returns nil if called with a king that is not owned by the ComputerPlayer obj that calls it for a game with a certain board with 3 pieces" do
      pieces = [
        {
          cell: [5,2],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        },
        {
          cell: [0,0],
          color: :black,
          type: :rook,
          is_capturable: true,
          did_move: false,
        },
        {
          cell: [0,4],
          color: :black,
          type: :king,
          is_capturable: false,
          did_move: false,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner,
        pieces: pieces
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      king = { piece: game.board[0][4], cell: [0,4] }
      res = computer_player.queenside_castle(king)
      expect(res).to eql(nil)
    end

    it "returns nil if called with a king that is in position to queenside castle but is checked for a game with a certain board with 3 pieces" do
      pieces = [
        {
          cell: [2,2],
          color: :black,
          type: :rook,
          is_capturable: true,
          did_move: true,
        },
        {
          cell: [7,0],
          color: :white,
          type: :rook,
          is_capturable: true,
          did_move: false,
        },
        {
          cell: [7,4],
          color: :white,
          type: :king,
          is_capturable: false,
          did_move: false,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner,
        pieces: pieces
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      king = { piece: game.board[7][4], cell: [7,4] }
      res = computer_player.queenside_castle(king)
      expect(res).to eql(nil)
    end

    it "returns the correct Long AN string if called with a king that can queenside castle for a game with a certain board with 3 pieces" do
      pieces = [
        {
          cell: [2,2],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        },
        {
          cell: [7,0],
          color: :white,
          type: :rook,
          is_capturable: true,
          did_move: false,
        },
        {
          cell: [7,4],
          color: :white,
          type: :king,
          is_capturable: false,
          did_move: false,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        chess_move_runner_class: ChessMoveRunner,
        pieces: pieces
      }
      game = Game.new(options)
      game.add_player!(MockPlayer, { piece_color: :black })
      computer_player = game.add_player!(
        ComputerPlayer, { piece_color: :white, type: :computer }
      )
      king = { piece: game.board[7][4], cell: [7,4] }
      res = computer_player.queenside_castle(king)
      expect(res).to eql('0-0-0')
    end
  end
end
