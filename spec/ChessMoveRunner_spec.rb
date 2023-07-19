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
end
