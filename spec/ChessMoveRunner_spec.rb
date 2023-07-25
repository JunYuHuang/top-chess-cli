require './lib/ChessMoveRunner'
require './lib/Game'
require './lib/PieceFactory'
require './spec/PieceUtilsClass'

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
      game.current_player_color = :black
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
      expect(white_pawn.did_double_step?).to eql(false)
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
      expect(white_pawn.did_double_step?).to eql(true)
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

  describe "#must_promote?" do
    it "returns false if called with anything on a ChessMoveRunner object that has a null game object property" do
      chess_move_runner = ChessMoveRunner.new(nil)
      res = chess_move_runner.must_promote?(nil)
      expect(res).to eql(false)
    end

    it "returns false if called with an invalid cell on a ChessMoveRunner object that has a valid game object" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      chess_move_runner = ChessMoveRunner.new(game)
      res = chess_move_runner.must_promote?([0,-1])
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell that references a non-Pawn piece on a ChessMoveRunner object that has a valid game object" do
      pieces = [
        {
          cell: [1,7],
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
      res = chess_move_runner.must_promote?([1,7])
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell that references a white pawn and is not in the 2nd top-most row on a ChessMoveRunner object that has a valid game object" do
      pieces = [
        {
          cell: [0,7],
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
      res = chess_move_runner.must_promote?([0,7])
      expect(res).to eql(false)
    end

    it "returns false if called with a valid cell that references a black pawn and is not in the 2nd bottom-most row on a ChessMoveRunner object that has a valid game object" do
      pieces = [
        {
          cell: [5,2],
          color: :black,
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
      res = chess_move_runner.must_promote?([5,2])
      expect(res).to eql(false)
    end

    it "returns true if called with a valid cell that references a white pawn and is in the 2nd top-most row on a ChessMoveRunner object that has a valid game object" do
      pieces = [
        {
          cell: [1,7],
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
      res = chess_move_runner.must_promote?([1,7])
      expect(res).to eql(true)
    end

    it "returns true if called with a valid cell that references a black pawn and is in the 2nd bottom-most row on a ChessMoveRunner object that has a valid game object" do
      pieces = [
        {
          cell: [6,2],
          color: :black,
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
      res = chess_move_runner.must_promote?([6,2])
      expect(res).to eql(true)
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
end
