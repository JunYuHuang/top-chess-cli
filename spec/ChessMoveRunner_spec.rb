require './lib/ChessMoveRunner'
require './lib/Game'
require './lib/PieceFactory'

describe ChessMoveRunner do
  describe "#initialize" do
    it "returns a non-nil object called with a mock game object" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      expect(chess_move_runner).not_to eql(nil)
    end

    it "returns a non-nil object if called with a real game object" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      expect(chess_move_runner).to_not eql(nil)
    end
  end

  describe "#can_chess_move?" do
    it "returns false if called with a valid move syntax on a mock game" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.can_chess_move?('a2xb3')
      expect(res).to eql(false)
    end

    it "returns false if called with ('d7xe8', :white) on a valid game with a custom board and 'd7' is a square occupied by a white pawn that must promote and 'e8' is a square occupied by a non-king black piece" do
      pieces = [
        {
          cell: [0,4],
          color: :black,
          type: :rook,
          is_capturable: true,
        },
        {
          cell: [1,3],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_chess_move?('d7xe8', :white)
      expect(res).to eql(false)
    end

    it "returns true if called with ('f5xe6', :white) on a valid game with a certain board and 'f5' is a square occupied by a white pawn and 'e5' is a square occupied by a black pawn that is marked as capturable en-passant (i.e. it double stepped forward last move)" do
      pieces = [
        {
          cell: [3,4],
          color: :black,
          type: :pawn,
          is_capturable: true,
          is_capturable_en_passant: true
        },
        {
          cell: [3,5],
          color: :white,
          type: :pawn,
          is_capturable: true
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_chess_move?('f5xe6', :white)
      expect(res).to eql(true)
    end

    it "returns true if called with ('e3xd2', :black) on a valid game with a custom board and 'e3' is a square occupied by a black pawn and 'd2' is a square occupied by a white non-king piece" do
      pieces = [
        {
          cell: [6,3],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: false,
        },
        {
          cell: [5,4],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_chess_move?('e3xd2', :black)
      expect(res).to eql(true)
    end
  end

  describe "#execute_chess_move!" do
    it "does nothing if called with ('d7xe8', :white) on a valid game with a custom board and 'd7' is a square occupied by a white pawn that must promote and 'e8' is a square occupied by a non-king black piece" do
      pieces = [
        {
          cell: [0,4],
          color: :black,
          type: :rook,
          is_capturable: true,
          did_move: true,
        },
        {
          cell: [1,3],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.execute_chess_move!('d7xe8', :white)
      black_rook = game.board[0][4]
      white_pawn = game.board[1][3]
      expect(black_rook.nil?).to eql(false)
      expect(black_rook.type).to eql(:rook)
      expect(white_pawn.nil?).to eql(false)
      expect(white_pawn.type).to eql(:pawn)
    end

    it "modifies the board correctly if called with ('f5xe6', :white) on a valid game with a certain board and 'f5' is a square occupied by a white pawn and 'e5' is a square occupied by a black pawn that is marked as capturable en-passant (i.e. it double stepped forward last move)" do
      pieces = [
        {
          cell: [3,4],
          color: :black,
          type: :pawn,
          is_capturable: true,
          is_capturable_en_passant: true
        },
        {
          cell: [3,5],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.execute_chess_move!('f5xe6', :white)
      black_pawn = game.board[3][4]
      white_pawn_old_cell = game.board[3][5]
      white_pawn_new_cell = game.board[2][4]
      expect(black_pawn.nil?).to eql(true)
      expect(white_pawn_old_cell.nil?).to eql(true)
      expect(white_pawn_new_cell.nil?).to eql(false)
      expect(white_pawn_new_cell.type).to eql(:pawn)
      expect(white_pawn_new_cell.did_move).to eql(true)
    end

    it "modifies the board correctly if called with ('e3xd2', :black) on a valid game with a custom board and 'e3' is a square occupied by a black pawn and 'd2' is a square occupied by a white non-king piece" do
      pieces = [
        {
          cell: [6,3],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: false,
        },
        {
          cell: [5,4],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.execute_chess_move!('e3xd2', :black)
      black_pawn_old_cell = game.board[5][4]
      black_pawn_new_cell = game.board[6][3]
      expect(black_pawn_old_cell.nil?).to eql(true)
      expect(black_pawn_new_cell.nil?).to eql(false)
      expect(black_pawn_new_cell.type).to eql(:pawn)
      expect(black_pawn_new_cell.color).to eql(:black)
    end
  end

  describe "#is_valid_piece_char_syntax?" do
    it "returns false if called with a non-String" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_piece_char_syntax?(nil)
      expect(res).to eql(false)
    end

    it "returns false if called with an uppercase letter that does not represent a valid chess piece" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_piece_char_syntax?('D')
      expect(res).to eql(false)
    end

    it "returns false if called with a lowercase letter that represents a valid chess piece" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_piece_char_syntax?('r')
      expect(res).to eql(false)
    end

    it "returns true if called with ''" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_piece_char_syntax?('')
      expect(res).to eql(true)
    end

    it "returns true if called with 'R'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_piece_char_syntax?('R')
      expect(res).to eql(true)
    end

    it "returns true if called with 'N'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_piece_char_syntax?('N')
      expect(res).to eql(true)
    end

    it "returns true if called with 'B'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_piece_char_syntax?('B')
      expect(res).to eql(true)
    end

    it "returns true if called with 'Q'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_piece_char_syntax?('Q')
      expect(res).to eql(true)
    end

    it "returns true if called with 'K'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_piece_char_syntax?('K')
      expect(res).to eql(true)
    end
  end

  describe "#is_valid_coords_syntax?" do
    it "returns false if called with a non-String" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_coords_syntax?(nil)
      expect(res).to eql(false)
    end

    it "returns false if called with 'A1'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_coords_syntax?('A1')
      expect(res).to eql(false)
    end

    it "returns false if called with 'a0'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_coords_syntax?('a0')
      expect(res).to eql(false)
    end

    it "returns true if called with 'a1'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_coords_syntax?('a1')
      expect(res).to eql(true)
    end

    it "returns true if called with 'h8'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_coords_syntax?('h8')
      expect(res).to eql(true)
    end
  end

  describe "#is_valid_move_syntax?" do
    it "returns false if called with a non-String" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_move_syntax?(nil)
      expect(res).to eql(false)
    end

    it "returns true if called with 'a2-a4'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_move_syntax?('a2-a4')
      expect(res).to eql(true)
    end

    it "returns true if called with 'a2a4'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_move_syntax?('a2a4')
      expect(res).to eql(true)
    end

    it "returns true if called with 'Qd5-b7'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_move_syntax?('Qd5-b7')
      expect(res).to eql(true)
    end

    it "returns true if called with 'Qd5b7'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_move_syntax?('Qd5b7')
      expect(res).to eql(true)
    end
  end

  describe "#is_valid_capture_syntax?" do
    it "returns false if called with a non-String" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_capture_syntax?(nil)
      expect(res).to eql(false)
    end

    it "returns true if called with 'Bc1xg5'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_capture_syntax?('Bc1xg5')
      expect(res).to eql(true)
    end

    it "returns true if called with 'f5xe6'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_capture_syntax?('f5xe6')
      expect(res).to eql(true)
    end
  end

  describe "#is_valid_capture_en_passant_syntax?" do
    it "returns false if called with a non-String" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_capture_en_passant_syntax?(nil)
      expect(res).to eql(false)
    end

    it "returns false if called with 'Bf5xg6'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_capture_en_passant_syntax?('Bf5xg6')
      expect(res).to eql(false)
    end

    it "returns false if called with 'f4xg5'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_capture_en_passant_syntax?('f4xg5')
      expect(res).to eql(false)
    end

    it "returns true if called with 'f5xg6'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_capture_en_passant_syntax?('f5xg6')
      expect(res).to eql(true)
    end

    it "returns true if called with 'f5xe6'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_capture_en_passant_syntax?('f5xe6')
      expect(res).to eql(true)
    end

    it "returns true if called with 'c4xd3'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_capture_en_passant_syntax?('c4xd3')
      expect(res).to eql(true)
    end

    it "returns true if called with 'c4xb3'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_capture_en_passant_syntax?('c4xb3')
      expect(res).to eql(true)
    end
  end

  describe "#is_valid_promote_syntax?" do
    it "returns false if called with a non-String" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_promote_syntax?(nil)
      expect(res).to eql(false)
    end

    it "returns false if called with a 'Rc7-c8=Q'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new('Rc7-c8=Q')
      res = chess_move_runner.is_valid_promote_syntax?('Rc7-c8=Q')
      expect(res).to eql(false)
    end

    it "returns false if called with 'c7-c8=K'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_promote_syntax?('c7-c8=K')
      expect(res).to eql(false)
    end

    it "returns false if called with 'c6-c8=Q'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_promote_syntax?('c6-c8=Q')
      expect(res).to eql(false)
    end

    it "returns true if called with 'c7-c8=R'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_promote_syntax?('c7-c8=R')
      expect(res).to eql(true)
    end

    it "returns true if called with 'c7-c8=N'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_promote_syntax?('c7-c8=N')
      expect(res).to eql(true)
    end

    it "returns true if called with 'c7c8=B'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_promote_syntax?('c7-c8=B')
      expect(res).to eql(true)
    end

    it "returns true if called with 'c7xb8=Q'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_promote_syntax?('c7xb8=Q')
      expect(res).to eql(true)
    end

    it "returns false if called with a 'Rf2-f1=Q'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new('Rf2-f1=Q')
      res = chess_move_runner.is_valid_promote_syntax?(nil)
      expect(res).to eql(false)
    end

    it "returns false if called with 'f3-f1=Q'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_promote_syntax?('f3-f1=Q')
      expect(res).to eql(false)
    end

    it "returns false if called with 'f2-f1=K'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_promote_syntax?('f2-f1=K')
      expect(res).to eql(false)
    end

    it "returns true if called with 'f2-f1=R'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_promote_syntax?('f2-f1=R')
      expect(res).to eql(true)
    end

    it "returns true if called with 'f2f1=N'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_promote_syntax?('f2f1=N')
      expect(res).to eql(true)
    end

    it "returns true if called with 'f2xg1=B'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_promote_syntax?('f2xg1=B')
      expect(res).to eql(true)
    end
  end

  describe "#is_valid_queenside_castle_syntax?" do
    it "returns false if called with a non-String" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_queenside_castle_syntax?(nil)
      expect(res).to eql(false)
    end

    it "returns false if called with 'o-o-o'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_queenside_castle_syntax?('o-o-o')
      expect(res).to eql(false)
    end

    it "returns false if called with '0-0'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_queenside_castle_syntax?('0-0')
      expect(res).to eql(false)
    end

    it "returns false if called with 'O-O'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_queenside_castle_syntax?('O-O')
      expect(res).to eql(false)
    end

    it "returns false if called with 'O-O-O-O'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_queenside_castle_syntax?('O-O-O-O')
      expect(res).to eql(false)
    end

    it "returns true if called with '0-0-0'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_queenside_castle_syntax?('0-0-0')
      expect(res).to eql(true)
    end

    it "returns true if called with 'O-O-O'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_queenside_castle_syntax?('O-O-O')
      expect(res).to eql(true)
    end
  end

  describe "#is_valid_kingside_castle_syntax?" do
    it "returns false if called with a non-String" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_kingside_castle_syntax?(nil)
      expect(res).to eql(false)
    end

    it "returns false if called with 'o-o'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_kingside_castle_syntax?('o-o')
      expect(res).to eql(false)
    end

    it "returns false if called with '0-0-0'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_kingside_castle_syntax?('0-0-0')
      expect(res).to eql(false)
    end

    it "returns false if called with 'O-O-O'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_kingside_castle_syntax?('O-O-O')
      expect(res).to eql(false)
    end

    it "returns true if called with '0-0'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_kingside_castle_syntax?('0-0')
      expect(res).to eql(true)
    end

    it "returns true if called with 'O-O'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_kingside_castle_syntax?('O-O')
      expect(res).to eql(true)
    end
  end

  describe "#is_valid_syntax?" do
    it "returns false if called with a non-String" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_syntax?(nil)
      expect(res).to eql(false)
    end

    it "returns false if called with non-valid Long AN syntax" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_syntax?('Rc7-c8=Q')
      expect(res).to eql(false)
    end

    it "returns true if called with 'O-O'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_syntax?('O-O')
      expect(res).to eql(true)
    end
  end

  describe "#coords_to_matrix_cell" do
    it "returns [0,0] if called with 'a8'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.coords_to_matrix_cell('a8')
      expect(res).to eql([0,0])
    end

    it "returns [7,0] if called with 'a1'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.coords_to_matrix_cell('a1')
      expect(res).to eql([7,0])
    end

    it "returns [0,7] if called with 'h8'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.coords_to_matrix_cell('h8')
      expect(res).to eql([0,7])
    end

    it "returns [7,7] if called with 'h1'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.coords_to_matrix_cell('h1')
      expect(res).to eql([7,7])
    end

    it "returns [4,2] if called with 'c4'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.coords_to_matrix_cell('c4')
      expect(res).to eql([4,2])
    end

    it "returns [3,5] if called with 'f5'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.coords_to_matrix_cell('f5')
      expect(res).to eql([3,5])
    end
  end

  describe "#matrix_cell_to_coords" do
    it "returns 'a8' if called with [0,0]" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.matrix_cell_to_coords([0,0])
      expect(res).to eql('a8')
    end

    it "returns 'a1' if called with [7,0]" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.matrix_cell_to_coords([7,0])
      expect(res).to eql('a1')
    end

    it "returns 'h8' if called with [0,7]" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.matrix_cell_to_coords([0,7])
      expect(res).to eql('h8')
    end

    it "returns 'h1' if called with [7,7]" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.matrix_cell_to_coords([7,7])
      expect(res).to eql('h1')
    end

    it "returns 'c4' if called with [4,2]" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.matrix_cell_to_coords([4,2])
      expect(res).to eql('c4')
    end

    it "returns 'f5' if called with [3,5]" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.matrix_cell_to_coords([3,5])
      expect(res).to eql('f5')
    end
  end

  describe "#is_matching_piece?" do
    it "returns false if called with nil" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_matching_piece?(nil)
      expect(res).to eql(false)
    end

    it "returns false if called with a dict that is missing a required key on a valid game" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      args = {
        piece_type: :pawn,
        piece_color: :white,
      }
      res = chess_move_runner.is_matching_piece?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with a dict with a cell value that references an empty cell on a valid game" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      args = {
        piece_type: :pawn,
        piece_color: :white,
        cell: [4,0]
      }
      res = chess_move_runner.is_matching_piece?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with a dict with a cell value that references a piece with a mismatched color on the board on a valid game" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      args = {
        piece_type: :pawn,
        piece_color: :black,
        cell: [6,0]
      }
      res = chess_move_runner.is_matching_piece?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with a dict with a cell value that references a piece with a mismatched type on the board on a valid game" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      args = {
        piece_type: :king,
        piece_color: :white,
        cell: [6,0]
      }
      res = chess_move_runner.is_matching_piece?(args)
      expect(res).to eql(false)
    end

    it "returns true if called with a dict with a cell value that references a matching piece on the board on a valid game" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      args = {
        piece_type: :pawn,
        piece_color: :white,
        cell: [6,0]
      }
      res = chess_move_runner.is_matching_piece?(args)
      expect(res).to eql(true)
    end
  end

  describe "#move_syntax_to_hash" do
    it "returns the correct hash if called with ('a2-a4', :white)" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.move_syntax_to_hash('a2-a4', :white)
      exp = {
        src_piece_type: :pawn,
        src_piece_color: :white,
        src_cell: [6,0],
        dst_cell: [4,0]
      }
      expect(res).to eql(exp)
    end

    it "returns the correct hash if called with ('a2a4', :white)" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.move_syntax_to_hash('a2a4', :white)
      exp = {
        src_piece_type: :pawn,
        src_piece_color: :white,
        src_cell: [6,0],
        dst_cell: [4,0]
      }
      expect(res).to eql(exp)
    end

    it "returns the correct hash if called with ('Ra8b8', :black)" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.move_syntax_to_hash('Ra8b8', :black)
      exp = {
        src_piece_type: :rook,
        src_piece_color: :black,
        src_cell: [0,0],
        dst_cell: [0,1]
      }
      expect(res).to eql(exp)
    end

    it "returns the correct hash if called with ('Qa8-b8', :black)" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.move_syntax_to_hash('Qa8-b8', :black)
      exp = {
        src_piece_type: :queen,
        src_piece_color: :black,
        src_cell: [0,0],
        dst_cell: [0,1]
      }
      expect(res).to eql(exp)
    end
  end

  describe "#capture_syntax_to_hash" do
    it "returns the correct hash if called with ('Bc1xg5', :white)" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.capture_syntax_to_hash('Bc1xg5', :white)
      exp = {
        src_piece_type: :bishop,
        src_piece_color: :white,
        src_cell: [7,2],
        dst_cell: [3,6]
      }
      expect(res).to eql(exp)
    end

    it "returns the correct hash if called with ('Bc1xg5') on a game whose turn is the black player's" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      game.turn_color = :black
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.capture_syntax_to_hash('Bc1xg5')
      exp = {
        src_piece_type: :bishop,
        src_piece_color: :black,
        src_cell: [7,2],
        dst_cell: [3,6]
      }
      expect(res).to eql(exp)
    end
  end

  describe "#capture_en_passant_syntax_to_hash" do
    it "returns the correct hash if called with ('f5xg6', :white)" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.capture_en_passant_syntax_to_hash('f5xg6', :white)
      exp = {
        src_piece_type: :pawn,
        src_piece_color: :white,
        src_cell: [3,5],
        dst_cell: [2,6]
      }
      expect(res).to eql(exp)
    end

    it "returns the correct hash if called with ('c4xd3') on a game whose turn is the black player's" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      game.turn_color = :black
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.capture_en_passant_syntax_to_hash('c4xd3')
      exp = {
        src_piece_type: :pawn,
        src_piece_color: :black,
        src_cell: [4,2],
        dst_cell: [5,3]
      }
      expect(res).to eql(exp)
    end
  end

  describe "#promote_syntax_to_hash" do
    it "returns the correct hash if called with ('c7-c8=Q', :white)" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.promote_syntax_to_hash('c7-c8=Q', :white)
      exp = {
        src_piece_type: :pawn,
        src_piece_color: :white,
        src_cell: [1,2],
        dst_cell: [0,2],
        promo_piece_type: :queen
      }
      expect(res).to eql(exp)
    end

    it "returns the correct hash if called with ('h2h1=B', :black)" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.promote_syntax_to_hash('h2h1=B', :black)
      exp = {
        src_piece_type: :pawn,
        src_piece_color: :black,
        src_cell: [6,7],
        dst_cell: [7,7],
        promo_piece_type: :bishop
      }
      expect(res).to eql(exp)
    end

    it "returns the correct hash if called with ('h2xg1=N', :black)" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.promote_syntax_to_hash('h2xg1=N', :black)
      exp = {
        src_piece_type: :pawn,
        src_piece_color: :black,
        src_cell: [6,7],
        dst_cell: [7,6],
        promo_piece_type: :knight
      }
      expect(res).to eql(exp)
    end
  end

  describe "#move_hash_to_syntax" do
    it "returns 'a2-a4' if called with a certain hash" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      hash = {
        src_piece_type: :pawn,
        src_cell: [6,0],
        dst_cell: [4,0]
      }
      res = chess_move_runner.move_hash_to_syntax(hash)
      expect(res).to eql('a2-a4')
    end

    it "returns 'Ra8-b8' if called with a certain hash" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      hash = {
        src_piece_type: :rook,
        src_cell: [0,0],
        dst_cell: [0,1]
      }
      res = chess_move_runner.move_hash_to_syntax(hash)
      expect(res).to eql('Ra8-b8')
    end

    it "returns 'Qa8-b8' if called with a certain hash" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      hash = {
        src_piece_type: :queen,
        src_cell: [0,0],
        dst_cell: [0,1]
      }
      res = chess_move_runner.move_hash_to_syntax(hash)
      expect(res).to eql('Qa8-b8')
    end
  end

  describe "#capture_hash_to_syntax" do
    it "returns 'Bc1xg5' if called with a certain hash" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      hash = {
        src_piece_type: :bishop,
        src_cell: [7,2],
        dst_cell: [3,6]
      }
      res = chess_move_runner.capture_hash_to_syntax(hash)
      expect(res).to eql('Bc1xg5')
    end

    it "returns 'Ng1xf3' if called with a certain hash" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      hash = {
        src_piece_type: :knight,
        src_cell: [7,6],
        dst_cell: [5,5]
      }
      res = chess_move_runner.capture_hash_to_syntax(hash)
      expect(res).to eql('Ng1xf3')
    end
  end

  describe "#capture_en_passant_hash_to_syntax" do
    it "returns 'f5xg6' if called with a certain hash" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      hash = {
        src_piece_type: :pawn,
        src_cell: [3,5],
        dst_cell: [2,6]
      }
      res = chess_move_runner.capture_en_passant_hash_to_syntax(hash)
      expect(res).to eql('f5xg6')
    end

    it "returns 'c4xd3' if called with a certain hash" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      hash = {
        src_piece_type: :pawn,
        src_cell: [4,2],
        dst_cell: [5,3]
      }
      res = chess_move_runner.capture_en_passant_hash_to_syntax(hash)
      expect(res).to eql('c4xd3')
    end
  end

  describe "#promote_hash_to_syntax" do
    it "returns 'c7-c8=Q' if called with a certain hash" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      hash = {
        src_cell: [1,2],
        dst_cell: [0,2],
        promo_piece_type: :queen,
        is_capture: false
      }
      res = chess_move_runner.promote_hash_to_syntax(hash)
      expect(res).to eql('c7-c8=Q')
    end

    it "returns 'h2-h1=B' if called with a certain hash" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      hash = {
        src_cell: [6,7],
        dst_cell: [7,7],
        promo_piece_type: :bishop,
        is_capture: false
      }
      res = chess_move_runner.promote_hash_to_syntax(hash)
      expect(res).to eql('h2-h1=B')
    end

    it "returns 'h2xg1=N' if called with a certain hash" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      hash = {
        src_cell: [6,7],
        dst_cell: [7,6],
        promo_piece_type: :knight,
        is_capture: true
      }
      res = chess_move_runner.promote_hash_to_syntax(hash)
      expect(res).to eql('h2xg1=N')
    end
  end

  describe "#castle_hash_to_syntax" do
    it "returns '0-0' if called with a certain hash" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      hash = { is_kingside: true }
      res = chess_move_runner.castle_hash_to_syntax(hash)
      expect(res).to eql('0-0')
    end

    it "returns '0-0-0' if called with a certain hash" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      hash = { is_kingside: false }
      res = chess_move_runner.castle_hash_to_syntax(hash)
      expect(res).to eql('0-0-0')
    end
  end

  describe "#can_move?" do
    it "returns false if called with 'asd13fa' on a mock game" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.can_move?('asd13fa')
      expect(res).to eql(false)
    end

    it "returns false if called with a valid move syntax on a mock game" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.can_move?('a2-a3')
      expect(res).to eql(false)
    end

    it "returns false if called with ('Ra1a2', :white) on a valid game with the default starting board and 'a2' is not an empty square" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_move?('Ra1a2', :white)
      expect(res).to eql(false)
    end

    it "returns false if called with ('Ra1a2', :black) on a valid game with the default starting board and 'a1' is not a square occupied by a black rook piece" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_move?('Ra1a2', :black)
      expect(res).to eql(false)
    end

    it "returns false if called with ('a2-a5', :white) on a valid game with the default starting board and 'a5' is NOT a square that the white pawn can move to in the current turn" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_move?('a2-a5', :white)
      expect(res).to eql(false)
    end

    it "returns true if called with ('a2a4', :white) on a valid game with the default starting board and 'a4' is a square that the white pawn can move to in the current turn" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_move?('a2a4', :white)
      expect(res).to eql(true)
    end

    it "returns true if called with ('a2a3', :white) on a valid game with the default starting board and 'a3' is a square that the white pawn can move to in the current turn" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_move?('a2a3', :white)
      expect(res).to eql(true)
    end

    it "returns false if called with ('d7d8', :white) on a valid game with a custom board and 'd7' has a white pawn that must promote" do
      pieces = [
        {
          cell: [1,3],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_move?('d7d8', :white)
      expect(res).to eql(false)
    end

    it "returns true if called with ('d6-d7', :white) on a valid game with a custom board and 'd6' has a white pawn that cannot promote" do
      pieces = [
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
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_move?('d6-d7', :white)
      expect(res).to eql(true)
    end

    it "returns false if called with ('e2e1', :black) on a valid game with a custom board and 'e2' has a black pawn that must promote" do
      pieces = [
        {
          cell: [6,4],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_move?('e2e1', :black)
      expect(res).to eql(false)
    end

    it "returns true if called with ('e3-e2', :black) on a valid game with a custom board and 'e3' has a black pawn that cannot promote" do
      pieces = [
        {
          cell: [5,4],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_move?('e3-e2', :black)
      expect(res).to eql(true)
    end
  end

  describe "#move!" do
    it "does nothing if called with ('a2-a5', :white) on a valid game with the default starting board" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.move!('a2-a5', :white)
      expect(game.board[6][0].nil?).to eql(false)
      expect(game.board[3][0].nil?).to eql(true)
    end

    it "correctly modifies the game board if called with ('a2-a3', :white) on a valid game with the default starting board" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.move!('a2-a3', :white)
      old_cell = game.board[6][0]
      white_pawn = game.board[5][0]
      expect(old_cell.nil?).to eql(true)
      expect(white_pawn.color).to eql(:white)
      expect(white_pawn.type).to eql(:pawn)
      expect(white_pawn.did_move?).to eql(true)
      expect(white_pawn.is_capturable_en_passant?).to eql(false)
    end

    it "correctly modifies the game board if called with ('a2-a4', :white) on a valid game with the default starting board" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.move!('a2-a4', :white)
      old_cell = game.board[6][0]
      white_pawn = game.board[4][0]
      expect(old_cell.nil?).to eql(true)
      expect(white_pawn.color).to eql(:white)
      expect(white_pawn.type).to eql(:pawn)
      expect(white_pawn.did_move?).to eql(true)
      expect(white_pawn.is_capturable_en_passant?).to eql(true)
    end

    it "correctly modifies the game board if called with ('Rh1h5', :white) on a valid game with a custom board that only has the white rook that did not move before" do
      pieces = [
        {
          cell: [7,7],
          color: :white,
          type: :rook,
          is_capturable: true,
          did_move: false,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.move!('Rh1h5', :white)
      old_cell = game.board[7][7]
      white_rook = game.board[3][7]
      expect(old_cell.nil?).to eql(true)
      expect(white_rook.color).to eql(:white)
      expect(white_rook.type).to eql(:rook)
      expect(white_rook.did_move?).to eql(true)
    end
  end

  describe "#can_capture?" do
    it "returns false if called with a valid move syntax on a mock game" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.can_capture?('a2xb3')
      expect(res).to eql(false)
    end

    it "returns false if called with ('Bc1xg5', :white) on a valid game with a certain board and 'g5' is an empty square" do
      pieces = [
        {
          cell: [7,2],
          color: :white,
          type: :bishop,
          is_capturable: true
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_capture?('Bc1xg5', :white)
      expect(res).to eql(false)
    end

    it "returns false if called with ('Bc1xg5', :white) on a valid game with a certain board and 'c1' is not a square occupied by a white bishop piece and 'g5' is occupied by a black non-king piece" do
      pieces = [
        {
          cell: [3,6],
          color: :black,
          type: :queen,
          is_capturable: true
        },
        {
          cell: [7,2],
          color: :white,
          type: :queen,
          is_capturable: true
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_capture?('Bc1xg5', :white)
      expect(res).to eql(false)
    end

    it "returns false if called with ('Bc1xg5', :white) on a valid game with a certain board and 'g5' is occupied by a white piece" do
      pieces = [
        {
          cell: [3,6],
          color: :white,
          type: :pawn,
          is_capturable: true
        },
        {
          cell: [7,2],
          color: :white,
          type: :bishop,
          is_capturable: true
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_capture?('Bc1xg5', :white)
      expect(res).to eql(false)
    end

    it "returns false if called with ('Bc1xg5', :white) on a valid game with a certain board and 'g5' is occupied by a black king piece" do
      pieces = [
        {
          cell: [3,6],
          color: :black,
          type: :king,
          is_capturable: false
        },
        {
          cell: [7,2],
          color: :white,
          type: :bishop,
          is_capturable: true
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_capture?('Bc1xg5', :white)
      expect(res).to eql(false)
    end

    it "returns false if called with ('Rc1xg5', :white) on a valid game with a certain board and 'g5' is a square occupied by a black non-king piece that the white rook cannot capture in the current turn" do
      pieces = [
        {
          cell: [3,6],
          color: :black,
          type: :pawn,
          is_capturable: true
        },
        {
          cell: [7,2],
          color: :white,
          type: :rook,
          is_capturable: true
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_capture?('Rc1xg5', :white)
      expect(res).to eql(false)
    end

    it "returns false if called with ('Qc1xg5', :white) on a valid game with a certain board and 'f4' is a square occupied by a black non-king piece that blocks the white queen on square 'c1' from capturing the black non-king piece on square 'g5'" do
      pieces = [
        {
          cell: [3,6],
          color: :black,
          type: :pawn,
          is_capturable: true
        },
        {
          cell: [4,5],
          color: :black,
          type: :pawn,
          is_capturable: true
        },
        {
          cell: [7,2],
          color: :white,
          type: :queen,
          is_capturable: true
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_capture?('Qc1xg5', :white)
      expect(res).to eql(false)
    end

    it "returns false if called with ('d7xe8', :white) on a valid game with a custom board and 'd7' is a square occupied by a white pawn that must promote and 'e8' is a square occupied by a non-king black piece" do
      pieces = [
        {
          cell: [0,4],
          color: :black,
          type: :rook,
          is_capturable: true,
        },
        {
          cell: [1,3],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_capture?('d7xe8', :white)
      expect(res).to eql(false)
    end

    it "returns true if called with ('d6xe7', :white) on a valid game with a custom board and 'd6' is a square occupied by a white pawn that cannot promote and 'e7' is a square occupied by a non-king black piece" do
      pieces = [
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
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_capture?('d6xe7', :white)
      expect(res).to eql(true)
    end

    it "returns true if called with ('e3xd2', :black) on a valid game with a custom board and 'e3' is a square occupied by a black pawn that cannot promote and 'd2' is a square occupied by a white non-king piece" do
      pieces = [
        {
          cell: [6,3],
          color: :white,
          type: :bishop,
          is_capturable: true,
        },
        {
          cell: [5,4],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_capture?('e3xd2', :black)
      expect(res).to eql(true)
    end
  end

  describe "#capture!" do
    it "does nothing if called with ('a2xb3', :white) on a valid game with the default starting board" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.capture!('a2xb3', :white)
      expect(game.board[6][0].nil?).to eql(false)
      expect(game.board[5][1].nil?).to eql(true)
    end

    it "correctly modifies the game board if called with ('Rh1xh7', :white) on a valid game with a custom board where 'h1' is a square with a white rook and 'h7' is a square with a black non-king piece" do
      pieces = [
        {
          cell: [1,7],
          color: :black,
          type: :pawn,
          is_capturable: true,
        },
        {
          cell: [7,7],
          color: :white,
          type: :rook,
          is_capturable: true,
        },
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.capture!('Rh1xh7', :white)
      old_cell = game.board[7][7]
      white_rook = game.board[1][7]
      expect(old_cell.nil?).to eql(true)
      expect(white_rook.color).to eql(:white)
      expect(white_rook.type).to eql(:rook)
      expect(white_rook.did_move?).to eql(true)
    end
  end

  describe "#can_promote?" do
    it "returns false if called with ('b6-b7=R', :white) on a ChessMoveRunner object that has a valid game object whose square 'b6' is actually a white rook" do
      pieces = [
        {
          cell: [2,1],
          color: :white,
          type: :rook,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_promote?('b6-b7=R', :white)
      expect(res).to eql(false)
    end

    it "returns false if called with ('b6-b7=Q', :white) on a ChessMoveRunner object that has a valid game object whose square 'b6' is a white pawn" do
      pieces = [
        {
          cell: [2,1],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_promote?('b6-b7=Q', :white)
      expect(res).to eql(false)
    end

    it "returns false if called with ('b7b8=Q', :white) on a ChessMoveRunner object that has a valid game object whose square 'b7' is a white pawn and square 'b8' is a black knight" do
      pieces = [
        {
          cell: [1,1],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        },
        {
          cell: [0,1],
          color: :black,
          type: :knight,
          is_capturable: true,
          did_move: false,
        },
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_promote?('b7b8=Q', :white)
      expect(res).to eql(false)
    end

    it "returns true if called with ('b7b8=Q', :white) on a ChessMoveRunner object that has a valid game object whose square 'b7' is a white pawn" do
      pieces = [
        {
          cell: [1,1],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_promote?('b7b8=Q', :white)
      expect(res).to eql(true)
    end

    it "returns true if called with ('b7-b8=R', :white) on a ChessMoveRunner object that has a valid game object whose square 'b7' is a white pawn" do
      pieces = [
        {
          cell: [1,1],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_promote?('b7-b8=R', :white)
      expect(res).to eql(true)
    end

    it "returns true if called with ('b7xa8=B', :white) on a ChessMoveRunner object that has a valid game object whose square 'b7' is a white pawn and square 'a8' is a black rook" do
      pieces = [
        {
          cell: [1,1],
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
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_promote?('b7xa8=B', :white)
      expect(res).to eql(true)
    end

    it "returns false if called with ('g3-g2=Q', :black) on a ChessMoveRunner object that has a valid game object whose square 'g3' is a black pawn" do
      pieces = [
        {
          cell: [5,6],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_promote?('g3-g2=Q', :black)
      expect(res).to eql(false)
    end

    it "returns false if called with ('g2g1=Q', :black) on a ChessMoveRunner object that has a valid game object whose square 'g2' is a black pawn and square 'g1' is a white knight" do
      pieces = [
        {
          cell: [6,6],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        },
        {
          cell: [7,6],
          color: :white,
          type: :knight,
          is_capturable: true,
          did_move: false,
        },
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_promote?('g2g1=Q', :black)
      expect(res).to eql(false)
    end

    it "returns true if called with ('g2g1=Q', :black) on a ChessMoveRunner object that has a valid game object whose square 'g2' is a black pawn" do
      pieces = [
        {
          cell: [6,6],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_promote?('g2g1=Q', :black)
      expect(res).to eql(true)
    end

    it "returns true if called with ('g2-g1=R', :black) on a ChessMoveRunner object that has a valid game object whose square 'g2' is a black pawn" do
      pieces = [
        {
          cell: [6,6],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_promote?('g2-g1=R', :black)
      expect(res).to eql(true)
    end

    it "returns true if called with ('g2xh1=B', :black) on a ChessMoveRunner object that has a valid game object whose square 'g2' is a black pawn and square 'h1' is a white rook" do
      pieces = [
        {
          cell: [6,6],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        },
        {
          cell: [7,7],
          color: :white,
          type: :rook,
          is_capturable: true,
          did_move: false,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_promote?('g2xh1=B', :black)
      expect(res).to eql(true)
    end
  end

  describe "#promote!" do
    it "does nothing if called with ('b6-b7=Q', :white) on a ChessMoveRunner object that has a valid game object whose square 'b6' is a white pawn" do
      pieces = [
        {
          cell: [2,1],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.promote!('b6-b7=Q', :white)
      src_cell = game.board[2][1]
      dst_cell = game.board[1][1]
      expect(src_cell.nil?).to eql(false)
      expect(dst_cell.nil?).to eql(true)
    end

    it "modifies the game board correctly if called with ('b7-b8=R', :white) on a ChessMoveRunner object that has a valid game object whose square 'b7' is a white pawn" do
      pieces = [
        {
          cell: [1,1],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.promote!('b7-b8=R', :white)
      src_cell = game.board[1][1]
      dst_cell = game.board[0][1]
      expect(src_cell.nil?).to eql(true)
      expect(dst_cell.nil?).to eql(false)
      expect(dst_cell.color).to eql(:white)
      expect(dst_cell.type).to eql(:rook)
    end

    it "does nothing if called with ('g3-g2=Q', :black) on a ChessMoveRunner object that has a valid game object whose square 'g3' is a black pawn" do
      pieces = [
        {
          cell: [5,6],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.promote!('g3-g2=Q', :black)
      src_cell = game.board[5][6]
      dst_cell = game.board[6][6]
      expect(src_cell.nil?).to eql(false)
      expect(dst_cell.nil?).to eql(true)
    end

    it "modifies the game board correctly if called with ('g2xh1=B', :black) on a ChessMoveRunner object that has a valid game object whose square 'g2' is a black pawn and square 'h1' is a white rook" do
      pieces = [
        {
          cell: [6,6],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
        },
        {
          cell: [7,7],
          color: :white,
          type: :rook,
          is_capturable: true,
          did_move: false,
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.promote!('g2xh1=B', :black)
      src_cell = game.board[6][6]
      dst_cell = game.board[7][7]
      expect(src_cell.nil?).to eql(true)
      expect(dst_cell.nil?).to eql(false)
      expect(dst_cell.color).to eql(:black)
      expect(dst_cell.type).to eql(:bishop)
    end
  end

  describe "#can_queenside_castle?" do
    it "returns false if called with ('0-0-0', :white) on a ChessMoveRunner object that has a valid game object with a certain board that has a black rook that checks the white king" do
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
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_queenside_castle?('0-0-0', :white)
      expect(res).to eql(false)
    end

    it "returns true if called with ('O-O-O', :white) on a ChessMoveRunner object that has a valid game object with a certain board that has a white rook and the white king" do
      pieces = [
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
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_queenside_castle?('O-O-O', :white)
      expect(res).to eql(true)
    end

    it "returns false if called with ('O-O-O', :black) on a ChessMoveRunner object that has a valid game object with a certain board that has a white rook that checks the black king" do
      pieces = [
        {
          cell: [5,2],
          color: :white,
          type: :rook,
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
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_queenside_castle?('O-O-O', :black)
      expect(res).to eql(false)
    end

    it "returns true if called with ('0-0-0', :black) on a ChessMoveRunner object that has a valid game object with a certain board that has a black rook and the black king" do
      pieces = [
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
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_queenside_castle?('0-0-0', :black)
      expect(res).to eql(true)
    end
  end

  describe "#queenside_castle!" do
    it "does nothing if called with ('0-0-0', :white) on a ChessMoveRunner object that has a valid game object with a certain board that has a black rook that checks the white king" do
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
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.queenside_castle!('0-0-0', :white)
      white_rook = game.board[7][0]
      white_king = game.board[7][4]
      expect(white_rook.type).to eql(:rook)
      expect(white_king.type).to eql(:king)
    end

    it "modifies the game board correctly if called with ('O-O-O', :white) on a ChessMoveRunner object that has a valid game object with a certain board that has a white rook and the white king" do
      pieces = [
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
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.queenside_castle!('O-O-O', :white)
      old_rook_cell = game.board[7][0]
      old_king_cell = game.board[7][4]
      new_rook_cell = game.board[7][3]
      new_king_cell = game.board[7][2]
      expect(old_rook_cell.nil?).to eql(true)
      expect(old_king_cell.nil?).to eql(true)
      expect(new_rook_cell.nil?).to eql(false)
      expect(new_rook_cell.type).to eql(:rook)
      expect(new_rook_cell.color).to eql(:white)
      expect(new_rook_cell.did_move?).to eql(true)
      expect(new_king_cell.type).to eql(:king)
      expect(new_king_cell.color).to eql(:white)
      expect(new_king_cell.did_move?).to eql(true)
    end

    it "does nothing if called with ('O-O-O', :black) on a ChessMoveRunner object that has a valid game object with a certain board that has a white rook that checks the black king" do
      pieces = [
        {
          cell: [5,2],
          color: :white,
          type: :rook,
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
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.queenside_castle!('O-O-O', :black)
      black_rook = game.board[0][0]
      black_king = game.board[0][4]
      expect(black_rook.type).to eql(:rook)
      expect(black_king.type).to eql(:king)
    end

    it "modifies the game board correctly if called with ('0-0-0', :black) on a ChessMoveRunner object that has a valid game object with a certain board that has a black rook and the black king" do
      pieces = [
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
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.queenside_castle!('0-0-0', :black)
      old_rook_cell = game.board[0][0]
      old_king_cell = game.board[0][4]
      new_rook_cell = game.board[0][3]
      new_king_cell = game.board[0][2]
      expect(old_rook_cell.nil?).to eql(true)
      expect(old_king_cell.nil?).to eql(true)
      expect(new_rook_cell.nil?).to eql(false)
      expect(new_rook_cell.type).to eql(:rook)
      expect(new_rook_cell.color).to eql(:black)
      expect(new_rook_cell.did_move?).to eql(true)
      expect(new_king_cell.type).to eql(:king)
      expect(new_king_cell.color).to eql(:black)
      expect(new_king_cell.did_move?).to eql(true)
    end
  end

  describe "#can_kingside_castle?" do
    it "returns false if called with ('0-0', :white) on a ChessMoveRunner object that has a valid game object with a certain board that has a black rook that would check the white king if the king were to castle" do
      pieces = [
        {
          cell: [2,6],
          color: :black,
          type: :rook,
          is_capturable: true,
          did_move: true,
        },
        {
          cell: [7,7],
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
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_kingside_castle?('0-0', :white)
      expect(res).to eql(false)
    end

    it "returns true if called with ('O-O', :white) on a ChessMoveRunner object that has a valid game object with a certain board that has a white rook and the white king" do
      pieces = [
        {
          cell: [7,7],
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
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_kingside_castle?('O-O', :white)
      expect(res).to eql(true)
    end

    it "returns false if called with ('O-O', :black) on a ChessMoveRunner object that has a valid game object with a certain board that has a white rook that checks the black king" do
      pieces = [
        {
          cell: [5,6],
          color: :white,
          type: :rook,
          is_capturable: true,
          did_move: true,
        },
        {
          cell: [0,7],
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
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_kingside_castle?('O-O', :black)
      expect(res).to eql(false)
    end

    it "returns true if called with ('0-0', :black) on a ChessMoveRunner object that has a valid game object with a certain board that has a black rook and the black king" do
      pieces = [
        {
          cell: [0,7],
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
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_kingside_castle?('0-0', :black)
      expect(res).to eql(true)
    end
  end

  describe "#kingside_castle!" do
    it "does nothing if called with ('0-0', :white) on a ChessMoveRunner object that has a valid game object with a certain board that has a black rook that checks the white king" do
      pieces = [
        {
          cell: [2,6],
          color: :black,
          type: :rook,
          is_capturable: true,
          did_move: true,
        },
        {
          cell: [7,7],
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
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.kingside_castle!('0-0', :white)
      white_rook = game.board[7][7]
      white_king = game.board[7][4]
      expect(white_rook.type).to eql(:rook)
      expect(white_king.type).to eql(:king)
    end

    it "modifies the game board correctly if called with ('O-O', :white) on a ChessMoveRunner object that has a valid game object with a certain board that has a white rook and the white king" do
      pieces = [
        {
          cell: [7,7],
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
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.kingside_castle!('O-O', :white)
      old_rook_cell = game.board[7][7]
      old_king_cell = game.board[7][4]
      new_rook_cell = game.board[7][5]
      new_king_cell = game.board[7][6]
      expect(old_rook_cell.nil?).to eql(true)
      expect(old_king_cell.nil?).to eql(true)
      expect(new_rook_cell.nil?).to eql(false)
      expect(new_rook_cell.type).to eql(:rook)
      expect(new_rook_cell.color).to eql(:white)
      expect(new_rook_cell.did_move?).to eql(true)
      expect(new_king_cell.type).to eql(:king)
      expect(new_king_cell.color).to eql(:white)
      expect(new_king_cell.did_move?).to eql(true)
    end

    it "does nothing if called with ('O-O', :black) on a ChessMoveRunner object that has a valid game object with a certain board that has a white rook that checks the black king" do
      pieces = [
        {
          cell: [5,6],
          color: :white,
          type: :rook,
          is_capturable: true,
          did_move: true,
        },
        {
          cell: [0,7],
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
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.kingside_castle!('O-O', :black)
      black_rook = game.board[0][7]
      black_king = game.board[0][4]
      expect(black_rook.type).to eql(:rook)
      expect(black_king.type).to eql(:king)
    end

    it "modifies the game board correctly if called with ('0-0', :black) on a ChessMoveRunner object that has a valid game object with a certain board that has a black rook and the black king" do
      pieces = [
        {
          cell: [0,7],
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
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.kingside_castle!('0-0', :black)
      old_rook_cell = game.board[0][7]
      old_king_cell = game.board[0][4]
      new_rook_cell = game.board[0][5]
      new_king_cell = game.board[0][6]
      expect(old_rook_cell.nil?).to eql(true)
      expect(old_king_cell.nil?).to eql(true)
      expect(new_rook_cell.nil?).to eql(false)
      expect(new_rook_cell.type).to eql(:rook)
      expect(new_rook_cell.color).to eql(:black)
      expect(new_rook_cell.did_move?).to eql(true)
      expect(new_king_cell.type).to eql(:king)
      expect(new_king_cell.color).to eql(:black)
      expect(new_king_cell.did_move?).to eql(true)
    end
  end

  describe "#can_capture_en_passant?" do
    it "returns false if called with a valid move syntax on a mock invalid game" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.can_capture_en_passant?('f5xe6')
      expect(res).to eql(false)
    end

    it "returns false if called with ('f5xe6', :white) on a valid game with a certain board and 'f5' is not a square occupied by a white pawn" do
      pieces = [
        {
          cell: [3,5],
          color: :black,
          type: :pawn,
          is_capturable: true
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_capture_en_passant?('f5xe6', :white)
      expect(res).to eql(false)
    end

    it "returns false if called with ('f5xe6', :white) on a valid game with a certain board and 'f5' is a square occupied by a white pawn and 'e5' is a square occupied by a black pawn that is not marked as capturable en-passant (i.e. it did not double step forward last move)" do
      pieces = [
        {
          cell: [3,4],
          color: :black,
          type: :pawn,
          is_capturable: true,
          is_capturable_en_passant: false
        },
        {
          cell: [3,5],
          color: :white,
          type: :pawn,
          is_capturable: true
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_capture_en_passant?('f5xe6', :white)
      expect(res).to eql(false)
    end

    it "returns true if called with ('f5xe6', :white) on a valid game with a certain board and 'f5' is a square occupied by a white pawn and 'e5' is a square occupied by a black pawn that is marked as capturable en-passant (i.e. it double stepped forward last move)" do
      pieces = [
        {
          cell: [3,4],
          color: :black,
          type: :pawn,
          is_capturable: true,
          is_capturable_en_passant: true
        },
        {
          cell: [3,5],
          color: :white,
          type: :pawn,
          is_capturable: true
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_capture_en_passant?('f5xe6', :white)
      expect(res).to eql(true)
    end

    it "returns true if called with ('c4xb3', :black) on a valid game with a certain board and 'f5' is a square occupied by a black pawn and 'e5' is a square occupied by a white pawn that is marked as capturable en-passant (i.e. it double stepped forward last move)" do
      pieces = [
        {
          cell: [4,1],
          color: :white,
          type: :pawn,
          is_capturable: true,
          is_capturable_en_passant: true
        },
        {
          cell: [4,2],
          color: :black,
          type: :pawn,
          is_capturable: true
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.can_capture_en_passant?('c4xb3', :black)
      expect(res).to eql(true)
    end
  end

  describe "#capture_en_passant!" do
    it "does nothing if called with ('f5xe6', :white) on a valid game with a certain board and 'f5' is a square occupied by a white pawn and 'e5' is a square occupied by a black pawn that is not marked as capturable en-passant (i.e. it did not double step forward last move)" do
      pieces = [
        {
          cell: [3,4],
          color: :black,
          type: :pawn,
          is_capturable: true,
          is_capturable_en_passant: false
        },
        {
          cell: [3,5],
          color: :white,
          type: :pawn,
          is_capturable: true
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.capture_en_passant!('f5xe6', :white)
      black_pawn = game.board[3][4]
      white_pawn = game.board[3][5]
      expect(black_pawn.nil?).to eql(false)
      expect(black_pawn.color).to eql(:black)
      expect(black_pawn.type).to eql(:pawn)
      expect(white_pawn.nil?).to eql(false)
      expect(white_pawn.color).to eql(:white)
      expect(white_pawn.type).to eql(:pawn)
      expect(white_pawn.did_move?).to eql(false)
    end

    it "modifies the board correctly if called with ('f5xe6', :white) on a valid game with a certain board and 'f5' is a square occupied by a white pawn and 'e5' is a square occupied by a black pawn that is as capturable en-passant (i.e. it double stepped forward last move)" do
      pieces = [
        {
          cell: [3,4],
          color: :black,
          type: :pawn,
          is_capturable: true,
          is_capturable_en_passant: true
        },
        {
          cell: [3,5],
          color: :white,
          type: :pawn,
          is_capturable: true
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.capture_en_passant!('f5xe6', :white)
      captive_cell = game.board[3][4]
      old_white_pawn_cell = game.board[3][5]
      new_white_pawn_cell = game.board[2][4]
      expect(captive_cell.nil?).to eql(true)
      expect(old_white_pawn_cell.nil?).to eql(true)
      expect(new_white_pawn_cell.nil?).to eql(false)
      expect(new_white_pawn_cell.color).to eql(:white)
      expect(new_white_pawn_cell.type).to eql(:pawn)
      expect(new_white_pawn_cell.did_move?).to eql(true)
    end

    it "modifies the board correctly if called with ('f5xg6', :white) on a valid game with a certain board and 'f5' is a square occupied by a white pawn and 'g5' is a square occupied by a black pawn that is as capturable en-passant (i.e. it double stepped forward last move)" do
      pieces = [
        {
          cell: [3,6],
          color: :black,
          type: :pawn,
          is_capturable: true,
          is_capturable_en_passant: true
        },
        {
          cell: [3,5],
          color: :white,
          type: :pawn,
          is_capturable: true
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.capture_en_passant!('f5xg6', :white)
      captive_cell = game.board[3][6]
      old_white_pawn_cell = game.board[3][5]
      new_white_pawn_cell = game.board[2][6]
      expect(captive_cell.nil?).to eql(true)
      expect(old_white_pawn_cell.nil?).to eql(true)
      expect(new_white_pawn_cell.nil?).to eql(false)
      expect(new_white_pawn_cell.color).to eql(:white)
      expect(new_white_pawn_cell.type).to eql(:pawn)
      expect(new_white_pawn_cell.did_move?).to eql(true)
    end

    it "modifies the board correctly if called with ('c4xd3', :black) on a valid game with a certain board and 'c4' is a square occupied by a black pawn and 'd4' is a square occupied by a white pawn that is as capturable en-passant (i.e. it double stepped forward last move)" do
      pieces = [
        {
          cell: [4,3],
          color: :white,
          type: :pawn,
          is_capturable: true,
          is_capturable_en_passant: true
        },
        {
          cell: [4,2],
          color: :black,
          type: :pawn,
          is_capturable: true
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.capture_en_passant!('c4xd3', :black)
      captive_cell = game.board[4][3]
      old_black_pawn_cell = game.board[4][2]
      new_black_pawn_cell = game.board[5][3]
      expect(captive_cell.nil?).to eql(true)
      expect(old_black_pawn_cell.nil?).to eql(true)
      expect(new_black_pawn_cell.nil?).to eql(false)
      expect(new_black_pawn_cell.color).to eql(:black)
      expect(new_black_pawn_cell.type).to eql(:pawn)
      expect(new_black_pawn_cell.did_move?).to eql(true)
    end

    it "modifies the board correctly if called with ('c4xb3', :black) on a valid game with a certain board and 'c4' is a square occupied by a black pawn and 'b4' is a square occupied by a white pawn that is as capturable en-passant (i.e. it double stepped forward last move)" do
      pieces = [
        {
          cell: [4,1],
          color: :white,
          type: :pawn,
          is_capturable: true,
          is_capturable_en_passant: true
        },
        {
          cell: [4,2],
          color: :black,
          type: :pawn,
          is_capturable: true
        }
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.capture_en_passant!('c4xb3', :black)
      captive_cell = game.board[4][1]
      old_black_pawn_cell = game.board[4][2]
      new_black_pawn_cell = game.board[5][1]
      expect(captive_cell.nil?).to eql(true)
      expect(old_black_pawn_cell.nil?).to eql(true)
      expect(new_black_pawn_cell.nil?).to eql(false)
      expect(new_black_pawn_cell.color).to eql(:black)
      expect(new_black_pawn_cell.type).to eql(:pawn)
      expect(new_black_pawn_cell.did_move?).to eql(true)
    end
  end

  describe "#set_enemy_pawns_non_capturable_en_passant!" do
    it "does nothing if called with :white on a valid game with a certain board with a white pawn and a black pawn" do
      pieces = [
        {
          cell: [1,2],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: false,
          is_capturable_en_passant: false
        },
        {
          cell: [6,6],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: false,
          is_capturable_en_passant: false
        },
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.set_enemy_pawns_non_capturable_en_passant!(:white)
      black_pawn_c7 = game.board[1][2]
      white_pawn_g2 = game.board[6][6]
      expect(black_pawn_c7.nil?).to eql(false)
      expect(black_pawn_c7.is_capturable_en_passant?).to eql(false)
      expect(white_pawn_g2.nil?).to eql(false)
      expect(white_pawn_g2.is_capturable_en_passant?).to eql(false)
    end

    it "modifies the board correctly if called with :black on a valid game with a certain board with a white pawn and a black pawn" do
      pieces = [
        {
          cell: [1,5],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: false,
          is_capturable_en_passant: false
        },
        {
          cell: [3,2],
          color: :black,
          type: :pawn,
          is_capturable: true,
          did_move: true,
          is_capturable_en_passant: true
        },
        {
          cell: [4,6],
          color: :white,
          type: :pawn,
          is_capturable: true,
          did_move: true,
          is_capturable_en_passant: true
        },
      ]
      options = {
        piece_factory_class: PieceFactory,
        pieces: pieces
      }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      chess_move_runner.set_enemy_pawns_non_capturable_en_passant!(:black)
      black_pawn_f7 = game.board[1][5]
      black_pawn_c5 = game.board[3][2]
      white_pawn_g4 = game.board[4][6]
      expect(black_pawn_f7.nil?).to eql(false)
      expect(black_pawn_f7.is_capturable_en_passant?).to eql(false)
      expect(black_pawn_c5.nil?).to eql(false)
      expect(black_pawn_c5.is_capturable_en_passant?).to eql(false)
      expect(white_pawn_g4.nil?).to eql(false)
      expect(white_pawn_g4.is_capturable_en_passant?).to eql(true)
    end
  end
end
