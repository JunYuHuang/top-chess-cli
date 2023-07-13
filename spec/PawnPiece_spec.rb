require './lib/PawnPiece'
require './spec/MockPiece'

describe PawnPiece do
  describe "#initialize" do
    it "returns a non-nil object if called" do
      pawn = PawnPiece.new
      expect(pawn).to_not eql(nil)
    end

    it "returns a non-nil object with default property values if called no arguments" do
      pawn = PawnPiece.new
      expect(pawn.color).to eql(:white)
      expect(pawn.did_move?).to eql(false)
      expect(pawn.did_double_step?).to eql(false)
    end
  end

  describe "#moves" do
    it "returns the correct int matrix if called with a valid cell and an otherwise empty board on a white pawn that has not moved yet" do
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][3] = white_pawn

      res = white_pawn.moves([6,3], board)
      expected = [
        [5,3],   # up 1 step cell
        [4,3],   # up 2 steps cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and an otherwise empty board on a white pawn that has moved" do
      white_pawn = PawnPiece.new({ color: :white, did_move: true })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][6] = white_pawn

      res = white_pawn.moves([4,6], board)
      expected = [
        [3,6],   # up 1 step cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and an otherwise empty board on a black pawn that has not moved yet" do
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[1][3] = black_pawn

      res = black_pawn.moves([1,3], board)
      expected = [
        [2,3],   # down 1 step cell
        [3,3],   # down 2 steps cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and an otherwise empty board on a black pawn that has moved" do
      black_pawn = PawnPiece.new({ color: :black, did_move: true })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][6] = black_pawn

      res = black_pawn.moves([3,6], board)
      expected = [
        [4,6],   # down 1 step cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and an otherwise empty board on a white pawn that has not moved yet with a black pawn in the cell directly above it" do
      black_pawn = MockPiece.new({ color: :black, did_move: true })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[5][3] = black_pawn
      board[6][3] = white_pawn

      res = white_pawn.moves([6,3], board)
      expected = []
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and an otherwise empty board on a white pawn that has not moved yet with a black pawn in the cell above the cell directly above it" do
      black_pawn = MockPiece.new({ color: :black, did_move: true })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][3] = black_pawn
      board[6][3] = white_pawn

      res = white_pawn.moves([6,3], board)
      expected = [
        [5,3],   # up 1 step cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end
  end

  describe "#captures" do
    it "returns an empty int matrix if called with a valid cell and an otherwise empty board on a white pawn" do
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][3] = white_pawn

      res = white_pawn.captures([6,3], board)
      expect(res.size).to eql(0)
      expect(res).to eql([])
    end

    it "returns an empty int matrix if called with a valid cell and an otherwise empty board on a black pawn" do
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[1][3] = black_pawn

      res = black_pawn.captures([1,3], board)
      expect(res.size).to eql(0)
      expect(res).to eql([])
    end

    it "returns the correct int matrix if called with a valid cell and a board with 2 other black knights on a white pawn" do
      black_knight = MockPiece.new({ color: :black, type: :knight })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[5][2] = black_knight
      board[5][4] = black_knight
      board[6][3] = white_pawn

      res = white_pawn.captures([6,3], board)
      expected = [
        [5,2],  # up left cell
        [5,4]   # up right cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and a board with 2 other white knights on a black pawn" do
      white_knight = MockPiece.new({ color: :white, type: :knight })
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[2][2] = white_knight
      board[2][4] = white_knight
      board[1][3] = black_pawn

      res = black_pawn.captures([1,3], board)
      expected = [
        [2,2],  # down left cell
        [2,4]   # down right cell
      ]
      expect(res.size).to eql(expected.size)
      expected.each do |move|
        expect(res.include?(move)).to eql(true)
      end
    end
  end

  describe "#can_capture_en_passant?" do
    it "returns false if called with an empty args hash and no block on a white pawn" do
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][5] = white_pawn
      args = {}
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with an args hash with a missing board key-value pair and no block on a white pawn" do
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][5] = white_pawn
      args = { src_cell: [6,5], captive_cell: [0,0] }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with an args hash with an out-of-bounds src cell and no block on a white pawn" do
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][5] = white_pawn
      args = {
        src_cell: [0,8],
        captive_cell: [0,0],
        board: board
      }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with an args hash with an empty captive cell and no block on a white pawn" do
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][5] = white_pawn
      args = {
        src_cell: [6,5],
        captive_cell: [3,4],
        board: board
      }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid args hash and no block on a pawn with an invalid color" do
      black_pawn = PawnPiece.new({ color: :black })
      yellow_pawn = PawnPiece.new({ color: :yellow })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = black_pawn
      board[3][5] = yellow_pawn
      args = {
        src_cell: [3,5],
        captive_cell: [3,4],
        board: board
      }
      res = yellow_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with an args hash with a captive cell that has an allied piece on it and no block on a white pawn" do
      white_rook = MockPiece.new({ color: :white, type: :rook })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = white_rook
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        captive_cell: [3,4],
        board: board
      }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with an args hash with a captive cell that has a non-pawn enemy piece on it and no block on a white pawn" do
      black_rook = MockPiece.new({ color: :black, type: :rook })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = black_rook
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        captive_cell: [3,4],
        board: board
      }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with an args hash with a captive cell that has a black pawn on it in a different row and no block on a white pawn" do
      black_pawn = PawnPiece.new({ color: :black })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[2][4] = black_pawn
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        captive_cell: [2,4],
        board: board
      }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with an args hash with a captive cell that has a black pawn on it in the same row and no block on a white pawn" do
      black_pawn = PawnPiece.new({ color: :black })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = black_pawn
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        captive_cell: [3,4],
        board: board
      }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    # white-specific checks

    it "returns false if called with an args hash with both the src cell and captive cell not in the correct row and a valid block on a white pawn" do
      black_pawn = PawnPiece.new({ color: :black })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][4] = black_pawn
      board[4][5] = white_pawn
      args = {
        src_cell: [4,5],
        captive_cell: [4,4],
        board: board
      }
      # mock method that returns true
      def is_last_move_enemy_pawn_double_step?(args)
        true
      end

      res = white_pawn.can_capture_en_passant?(args) do |block_args|
        is_last_move_enemy_pawn_double_step?(block_args)
      end
      expect(res).to eql(false)
    end

    it "returns false if called with an args hash with the captive cell that is not directly left adjacent to the src cell and a valid block on a white pawn" do
      black_pawn = PawnPiece.new({ color: :black })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][3] = black_pawn
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        captive_cell: [3,3],
        board: board
      }
      # mock method that returns true
      def is_last_move_enemy_pawn_double_step?(args)
        true
      end

      res = white_pawn.can_capture_en_passant?(args) do |block_args|
        is_last_move_enemy_pawn_double_step?(block_args)
      end
      expect(res).to eql(false)
    end

    it "returns false if called with an args hash whose captive cell's top adjacent cell is not empty and a valid block on a white pawn" do
      black_rook = MockPiece.new({ color: :black, type: :rook })
      black_pawn = PawnPiece.new({ color: :black })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[2][4] = black_rook
      board[3][4] = black_pawn
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        captive_cell: [3,4],
        board: board
      }
      # mock method that returns true
      def is_last_move_enemy_pawn_double_step?(args)
        true
      end

      res = white_pawn.can_capture_en_passant?(args) do |block_args|
        is_last_move_enemy_pawn_double_step?(block_args)
      end
      expect(res).to eql(false)
    end

    it "returns false if called with an args hash whose captive cell has a black pawn that did not double step and a valid block on a white pawn" do
      black_pawn = PawnPiece.new({ color: :black, did_double_step: false })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = black_pawn
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        captive_cell: [3,4],
        board: board
      }
      # mock method that returns true
      def is_last_move_enemy_pawn_double_step?(args)
        true
      end

      res = white_pawn.can_capture_en_passant?(args) do |block_args|
        is_last_move_enemy_pawn_double_step?(block_args)
      end
      expect(res).to eql(false)
    end

    it "returns false if called with an args hash whose captive cell has a black pawn that double stepped and a valid block that returns false on a white pawn" do
      black_pawn = PawnPiece.new({ color: :black, did_double_step: true })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = black_pawn
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        captive_cell: [3,4],
        board: board
      }
      # mock method that returns false
      def is_last_move_enemy_pawn_double_step?(args)
        false
      end

      res = white_pawn.can_capture_en_passant?(args) do |block_args|
        is_last_move_enemy_pawn_double_step?(block_args)
      end
      expect(res).to eql(false)
    end

    it "returns true if called with an args hash whose captive cell has a black pawn that double stepped on the white pawn's adjacent left cell and a valid block that returns true on a white pawn" do
      black_pawn = PawnPiece.new({ color: :black, did_double_step: true })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = black_pawn
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        captive_cell: [3,4],
        board: board
      }
      # mock method that returns true
      def is_last_move_enemy_pawn_double_step?(args)
        true
      end

      res = white_pawn.can_capture_en_passant?(args) do |block_args|
        is_last_move_enemy_pawn_double_step?(block_args)
      end
      expect(res).to eql(true)
    end

    it "returns true if called with an args hash whose captive cell has a black pawn that double stepped on the white pawn's adjacent right cell and a valid block that returns true on a white pawn" do
      black_pawn = PawnPiece.new({ color: :black, did_double_step: true })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][6] = black_pawn
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        captive_cell: [3,6],
        board: board
      }
      # mock method that returns true
      def is_last_move_enemy_pawn_double_step?(args)
        true
      end

      res = white_pawn.can_capture_en_passant?(args) do |block_args|
        is_last_move_enemy_pawn_double_step?(block_args)
      end
      expect(res).to eql(true)
    end

    # black-specific checks

    it "returns false if called with an args hash with both the src cell and captive cell not in the correct row and a valid block on a black pawn" do
      white_pawn = PawnPiece.new({ color: :white })
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][1] = white_pawn
      board[3][2] = black_pawn
      args = {
        src_cell: [3,2],
        captive_cell: [3,1],
        board: board
      }
      # mock method that returns true
      def is_last_move_enemy_pawn_double_step?(args)
        true
      end

      res = black_pawn.can_capture_en_passant?(args) do |block_args|
        is_last_move_enemy_pawn_double_step?(block_args)
      end
      expect(res).to eql(false)
    end

    it "returns false if called with an args hash with the captive cell that is not directly left adjacent to the src cell and a valid block on a black pawn" do
      white_pawn = PawnPiece.new({ color: :white })
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][0] = white_pawn
      board[4][2] = black_pawn
      args = {
        src_cell: [4,2],
        captive_cell: [4,0],
        board: board
      }
      # mock method that returns true
      def is_last_move_enemy_pawn_double_step?(args)
        true
      end

      res = black_pawn.can_capture_en_passant?(args) do |block_args|
        is_last_move_enemy_pawn_double_step?(block_args)
      end
      expect(res).to eql(false)
    end

    it "returns false if called with an args hash whose captive cell's bot adjacent cell is not empty and a valid block on a black pawn" do
      white_rook = MockPiece.new({ color: :white, type: :rook })
      white_pawn = PawnPiece.new({ color: :white })
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[5][1] = white_rook
      board[4][1] = white_pawn
      board[4][2] = black_pawn
      args = {
        src_cell: [4,2],
        captive_cell: [4,1],
        board: board
      }
      # mock method that returns true
      def is_last_move_enemy_pawn_double_step?(args)
        true
      end

      res = black_pawn.can_capture_en_passant?(args) do |block_args|
        is_last_move_enemy_pawn_double_step?(block_args)
      end
      expect(res).to eql(false)
    end

    it "returns false if called with an args hash whose captive cell has a white pawn that did not double step and a valid block on a black pawn" do
      white_pawn = PawnPiece.new({ color: :white, did_double_step: false })
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][1] = white_pawn
      board[4][2] = black_pawn
      args = {
        src_cell: [4,2],
        captive_cell: [4,1],
        board: board
      }
      # mock method that returns true
      def is_last_move_enemy_pawn_double_step?(args)
        true
      end

      res = black_pawn.can_capture_en_passant?(args) do |block_args|
        is_last_move_enemy_pawn_double_step?(block_args)
      end
      expect(res).to eql(false)
    end

    it "returns false if called with an args hash whose captive cell has a white pawn that double stepped and a valid block that returns false on a black pawn" do
      white_pawn = PawnPiece.new({ color: :white, did_double_step: true })
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][1] = white_pawn
      board[4][2] = black_pawn
      args = {
        src_cell: [4,2],
        captive_cell: [4,1],
        board: board
      }
      # mock method that returns false
      def is_last_move_enemy_pawn_double_step?(args)
        false
      end

      res = black_pawn.can_capture_en_passant?(args) do |block_args|
        is_last_move_enemy_pawn_double_step?(block_args)
      end
      expect(res).to eql(false)
    end

    it "returns true if called with an args hash whose captive cell has a white pawn that double stepped on the black pawn's adjacent left cell and a valid block that returns true on a black pawn" do
      white_pawn = PawnPiece.new({ color: :white, did_double_step: true })
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][1] = white_pawn
      board[4][2] = black_pawn
      args = {
        src_cell: [4,2],
        captive_cell: [4,1],
        board: board
      }
      # mock method that returns true
      def is_last_move_enemy_pawn_double_step?(args)
        true
      end

      res = black_pawn.can_capture_en_passant?(args) do |block_args|
        is_last_move_enemy_pawn_double_step?(block_args)
      end
      expect(res).to eql(true)
    end

    it "returns true if called with an args hash whose captive cell has a white pawn that double stepped on the black pawn's adjacent right cell and a valid block that returns true on a black pawn" do
      white_pawn = PawnPiece.new({ color: :white, did_double_step: true })
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][3] = white_pawn
      board[4][2] = black_pawn
      args = {
        src_cell: [4,2],
        captive_cell: [4,3],
        board: board
      }
      # mock method that returns true
      def is_last_move_enemy_pawn_double_step?(args)
        true
      end

      res = black_pawn.can_capture_en_passant?(args) do |block_args|
        is_last_move_enemy_pawn_double_step?(block_args)
      end
      expect(res).to eql(true)
    end
  end

  describe "#capture_en_passant" do
    it "returns nil if called with an args hash whose captive cell has a black pawn that double stepped and a valid block that returns false on a white pawn" do
      black_pawn = PawnPiece.new({ color: :black, did_double_step: true })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = black_pawn
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        captive_cell: [3,4],
        board: board
      }
      # mock method that returns false
      def is_last_move_enemy_pawn_double_step?(args)
        false
      end

      res = white_pawn.capture_en_passant(args) do |block_args|
        is_last_move_enemy_pawn_double_step?(block_args)
      end
      expect(res).to eql(nil)
    end

    it "returns [2,4] if called with an args hash whose captive cell has a black pawn that double stepped on the white pawn's adjacent left cell and a valid block that returns true on a white pawn" do
      black_pawn = PawnPiece.new({ color: :black, did_double_step: true })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = black_pawn
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        captive_cell: [3,4],
        board: board
      }
      # mock method that returns true
      def is_last_move_enemy_pawn_double_step?(args)
        true
      end

      res = white_pawn.capture_en_passant(args) do |block_args|
        is_last_move_enemy_pawn_double_step?(block_args)
      end
      expect(res).to eql([2,4])
    end

    it "returns [2,6] if called with an args hash whose captive cell has a black pawn that double stepped on the white pawn's adjacent right cell and a valid block that returns true on a white pawn" do
      black_pawn = PawnPiece.new({ color: :black, did_double_step: true })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][6] = black_pawn
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        captive_cell: [3,6],
        board: board
      }
      # mock method that returns true
      def is_last_move_enemy_pawn_double_step?(args)
        true
      end

      res = white_pawn.capture_en_passant(args) do |block_args|
        is_last_move_enemy_pawn_double_step?(block_args)
      end
      expect(res).to eql([2,6])
    end

    it "returns [5,1] if called with an args hash whose captive cell has a white pawn that double stepped on the black pawn's adjacent left cell and a valid block that returns true on a black pawn" do
      white_pawn = PawnPiece.new({ color: :white, did_double_step: true })
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][1] = white_pawn
      board[4][2] = black_pawn
      args = {
        src_cell: [4,2],
        captive_cell: [4,1],
        board: board
      }
      # mock method that returns true
      def is_last_move_enemy_pawn_double_step?(args)
        true
      end

      res = black_pawn.capture_en_passant(args) do |block_args|
        is_last_move_enemy_pawn_double_step?(block_args)
      end
      expect(res).to eql([5,1])
    end

    it "returns [5,3] if called with an args hash whose captive cell has a white pawn that double stepped on the black pawn's adjacent right cell and a valid block that returns true on a black pawn" do
      white_pawn = PawnPiece.new({ color: :white, did_double_step: true })
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][3] = white_pawn
      board[4][2] = black_pawn
      args = {
        src_cell: [4,2],
        captive_cell: [4,3],
        board: board
      }
      # mock method that returns true
      def is_last_move_enemy_pawn_double_step?(args)
        true
      end

      res = black_pawn.capture_en_passant(args) do |block_args|
        is_last_move_enemy_pawn_double_step?(block_args)
      end
      expect(res).to eql([5,3])
    end
  end

  describe "#is_promotable?" do
    it "returns false if called with an out-of-bounds cell and a board" do
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][3] = white_pawn
      expect(white_pawn.is_promotable?([0,8], board)).to eql(false)
    end

    it "returns false if called with an empty cell and a board" do
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][3] = white_pawn
      expect(white_pawn.is_promotable?([6,4], board)).to eql(false)
    end

    it "returns false if called with a valid cell and a board on a pawn obj with an invalid color" do
      pawn = PawnPiece.new({ color: :blue })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][3] = pawn
      expect(pawn.is_promotable?([6,3], board)).to eql(false)
    end

    it "returns true if called with a cell in the top row and a board on a white pawn" do
      white_pawn = PawnPiece.new({ color: :white, did_move: true })
      board = Array.new(8) { Array.new(8, nil) }
      board[0][3] = white_pawn
      expect(white_pawn.is_promotable?([0,3], board)).to eql(true)
    end

    it "returns true if called with a cell in the bottom row and a board on a black pawn" do
      black_pawn = PawnPiece.new({ color: :black, did_move: true })
      board = Array.new(8) { Array.new(8, nil) }
      board[7][3] = black_pawn
      expect(black_pawn.is_promotable?([7,3], board)).to eql(true)
    end
  end

  describe "#is_valid_promotable?" do
    it "returns false if called with nil" do
      white_pawn = PawnPiece.new({ color: :white })
      res = white_pawn.is_valid_promotion?(nil)
      expect(res).to eql(false)
    end

    it "returns false if called with :pawn" do
      white_pawn = PawnPiece.new({ color: :white })
      res = white_pawn.is_valid_promotion?(:pawn)
      expect(res).to eql(false)
    end

    it "returns false if called with :king" do
      white_pawn = PawnPiece.new({ color: :white })
      res = white_pawn.is_valid_promotion?(:king)
      expect(res).to eql(false)
    end

    it "returns true if called with :rook" do
      white_pawn = PawnPiece.new({ color: :white })
      res = white_pawn.is_valid_promotion?(:rook)
      expect(res).to eql(true)
    end

    it "returns true if called with :knight" do
      white_pawn = PawnPiece.new({ color: :white })
      res = white_pawn.is_valid_promotion?(:knight)
      expect(res).to eql(true)
    end

    it "returns true if called with :bishop" do
      white_pawn = PawnPiece.new({ color: :white })
      res = white_pawn.is_valid_promotion?(:bishop)
      expect(res).to eql(true)
    end

    it "returns true if called with :queen" do
      white_pawn = PawnPiece.new({ color: :white })
      res = white_pawn.is_valid_promotion?(:queen)
      expect(res).to eql(true)
    end
  end

  describe "#move" do
    it "returns the correct board if called with all valid arguments on a white pawn" do
      board = Array.new(8) { Array.new(8, nil) }
      white_pawn = PawnPiece.new({ color: :white })
      board[3][5] = white_pawn
      res = white_pawn.move([3,5], [2,5], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[2][5] = white_pawn
      expect(res).to eql(expected)
    end
  end

  describe "#capture" do
    it "returns the correct board if called with all valid arguments on a white pawn" do
      board = Array.new(8) { Array.new(8, nil) }
      black_pawn = PawnPiece.new({ color: :black })
      white_pawn = PawnPiece.new({ color: :white })
      board[2][4] = black_pawn
      board[3][5] = white_pawn
      res = white_pawn.capture([3,5], [2,4], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[2][4] = white_pawn
      expect(res).to eql(expected)
    end

    it "returns the correct board if called with all valid arguments for an en-passant capture on a white pawn " do
      board = Array.new(8) { Array.new(8, nil) }
      black_pawn = PawnPiece.new({ color: :black, did_double_step: true })
      white_pawn = PawnPiece.new({ color: :white })
      board[3][4] = black_pawn
      board[3][5] = white_pawn
      res = white_pawn.capture([3,5], [2,4], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[2][4] = white_pawn
      expect(res).to eql(expected)
    end

    it "returns the correct board if called with all valid arguments for an en-passant capture on a white pawn " do
      board = Array.new(8) { Array.new(8, nil) }
      black_pawn = PawnPiece.new({ color: :black, did_double_step: true })
      white_pawn = PawnPiece.new({ color: :white })
      board[3][6] = black_pawn
      board[3][5] = white_pawn
      res = white_pawn.capture([3,5], [2,6], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[2][6] = white_pawn
      expect(res).to eql(expected)
    end

    it "returns the correct board if called with all valid arguments for an en-passant capture on a black pawn " do
      board = Array.new(8) { Array.new(8, nil) }
      white_pawn = PawnPiece.new({ color: :white, did_double_step: true })
      black_pawn = PawnPiece.new({ color: :black })
      board[4][1] = white_pawn
      board[4][2] = black_pawn
      res = black_pawn.capture([4,2], [5,1], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[5][1] = black_pawn
      expect(res).to eql(expected)
    end

    it "returns the correct board if called with all valid arguments for an en-passant capture on a black pawn " do
      board = Array.new(8) { Array.new(8, nil) }
      white_pawn = PawnPiece.new({ color: :white, did_double_step: true })
      black_pawn = PawnPiece.new({ color: :black })
      board[4][3] = white_pawn
      board[4][2] = black_pawn
      res = black_pawn.capture([4,2], [5,3], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[5][3] = black_pawn
      expect(res).to eql(expected)
    end
  end
end
