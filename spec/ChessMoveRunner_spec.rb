require './lib/ChessMoveRunner'
require './lib/Game'
require './lib/PieceFactory'
require './spec/MockPlayer'

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

  describe "#is_valid_promotion_syntax?" do
    it "returns false if called with a non-String" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_promotion_syntax?(nil)
      expect(res).to eql(false)
    end

    it "returns false if called with a 'Rc7-c8=Q'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new('Rc7-c8=Q')
      res = chess_move_runner.is_valid_promotion_syntax?(nil)
      expect(res).to eql(false)
    end

    it "returns true if called with 'c7-c8=Q'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_promotion_syntax?('c7-c8=Q')
      expect(res).to eql(true)
    end

    it "returns true if called with 'c7c8=Q'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_promotion_syntax?('c7-c8=Q')
      expect(res).to eql(true)
    end

    it "returns true if called with 'c7xb8=Q'" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.is_valid_promotion_syntax?('c7xb8=Q')
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

  describe "#promotion_syntax_to_hash" do
    it "returns the correct hash if called with ('c7-c8=Q', :white)" do
      mock_game = nil
      chess_move_runner = ChessMoveRunner.new(mock_game)
      res = chess_move_runner.promotion_syntax_to_hash('c7-c8=Q', :white)
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
      res = chess_move_runner.promotion_syntax_to_hash('h2h1=B', :black)
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
      res = chess_move_runner.promotion_syntax_to_hash('h2xg1=N', :black)
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
end
