require './lib/PawnPiece'
require './spec/MockPiece'
require './spec/PieceUtilsClass'

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

  describe "#captures_en_passant" do
    it "returns an empty int matrix if called with a valid cell and an otherwise empty board on a white pawn" do
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][5] = white_pawn

      res = white_pawn.captures_en_passant([3,5], board)
      expect(res.size).to eql(0)
      expect(res).to eql([])
    end

    it "returns an empty int matrix if called with a valid cell and an otherwise empty board on a black pawn" do
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][2] = black_pawn

      res = black_pawn.captures_en_passant([4,2], board)
      expect(res.size).to eql(0)
      expect(res).to eql([])
    end

    it "returns the correct int matrix if called with a valid cell and a certain board with a white pawn and a black pawn on a white pawn" do
      black_pawn = PawnPiece.new({
        color: :black, did_double_step: true,
        is_capturable_en_passant: true
      })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = black_pawn
      board[3][5] = white_pawn

      res = white_pawn.captures_en_passant([3,5], board)
      exp = [[2,4]]
      expect(res.size).to eql(exp.size)
      exp.each do |cell|
        expect(res.include?(cell)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and a certain board with a white pawn and a black pawn on a white pawn" do
      black_pawn = PawnPiece.new({
        color: :black, did_double_step: true,
        is_capturable_en_passant: true
      })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][6] = black_pawn
      board[3][5] = white_pawn

      res = white_pawn.captures_en_passant([3,5], board)
      exp = [[2,6]]
      expect(res.size).to eql(exp.size)
      exp.each do |cell|
        expect(res.include?(cell)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and a certain board with a white pawn and a black pawn on a white pawn" do
      black_pawn = PawnPiece.new({
        color: :black, did_double_step: true,
        is_capturable_en_passant: true
      })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][6] = black_pawn
      board[3][7] = white_pawn

      res = white_pawn.captures_en_passant([3,7], board)
      exp = [[2,6]]
      expect(res.size).to eql(exp.size)
      exp.each do |cell|
        expect(res.include?(cell)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and a certain board with a white pawn and a black pawn on a black pawn" do
      white_pawn = PawnPiece.new({
        color: :white, did_double_step: true,
        is_capturable_en_passant: true
      })
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][1] = white_pawn
      board[4][2] = black_pawn

      res = black_pawn.captures_en_passant([4,2], board)
      exp = [[5,1]]
      expect(res.size).to eql(exp.size)
      exp.each do |cell|
        expect(res.include?(cell)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and a certain board with a white pawn and a black pawn on a black pawn" do
      white_pawn = PawnPiece.new({
        color: :white, did_double_step: true,
        is_capturable_en_passant: true
      })
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][3] = white_pawn
      board[4][2] = black_pawn

      res = black_pawn.captures_en_passant([4,2], board)
      exp = [[5,3]]
      expect(res.size).to eql(exp.size)
      exp.each do |cell|
        expect(res.include?(cell)).to eql(true)
      end
    end

    it "returns the correct int matrix if called with a valid cell and a certain board with a white pawn and a black pawn on a black pawn" do
      white_pawn = PawnPiece.new({
        color: :white, did_double_step: true,
        is_capturable_en_passant: true
      })
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][1] = white_pawn
      board[4][0] = black_pawn

      res = black_pawn.captures_en_passant([4,0], board)
      exp = [[5,1]]
      expect(res.size).to eql(exp.size)
      exp.each do |cell|
        expect(res.include?(cell)).to eql(true)
      end
    end
  end

  describe "#is_double_step?" do
    it "returns false if called with ([6,0], [3,0]) and an otherwise empty board on a white pawn that has not moved yet" do
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][0] = white_pawn

      args = [[6,0], [3,0], board]
      res = white_pawn.is_double_step?(*args)
      expect(res).to eql(false)
    end

    it "returns false if called with ([6,0], [5,0]) and an otherwise empty board on a white pawn that has not moved yet" do
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][0] = white_pawn

      args = [[6,0], [5,0], board]
      res = white_pawn.is_double_step?(*args)
      expect(res).to eql(false)
    end

    it "returns true if called with ([6,0], [4,0]) and an otherwise empty board on a white pawn that has not moved yet" do
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][0] = white_pawn

      args = [[6,0], [4,0], board]
      res = white_pawn.is_double_step?(*args)
      expect(res).to eql(true)
    end

    it "returns true if called with ([1,3], [3,3]) and an otherwise empty board on a black pawn that has not moved yet" do
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[1][3] = black_pawn

      args = [[1,3], [3,3], board]
      res = black_pawn.is_double_step?(*args)
      expect(res).to eql(true)
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

    it "returns false if called with an args hash with a missing board key-value pair on a white pawn" do
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][5] = white_pawn
      args = { src_cell: [6,5], dst_cell: [0,0] }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with an args hash with an out-of-bounds src cell on a white pawn" do
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][5] = white_pawn
      args = {
        src_cell: [0,8],
        dst_cell: [0,0],
        board: board
      }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with an args hash with a non-empty dst cell on a white pawn" do
      white_pawn = PawnPiece.new({ color: :white })
      black_rook = MockPiece.new({ color: :black, type: :rook })
      board = Array.new(8) { Array.new(8, nil) }
      board[2][4] = black_rook
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        dst_cell: [2,4],
        board: board
      }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with an args hash whose src_cell does not match the real cell of the pawn it is called on" do
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][4] = white_pawn
      args = {
        src_cell: [3,5],
        dst_cell: [2,4],
        board: board
      }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with an args hash whose src_cell does not match the real cell of the pawn it is called on" do
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][4] = white_pawn
      args = {
        src_cell: [3,5],
        dst_cell: [2,4],
        board: board
      }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid arg hash whose src_cell is not in row index 3 (rank 5) on a white pawn" do
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][5] = white_pawn
      args = {
        src_cell: [4,5],
        dst_cell: [3,4],
        board: board
      }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid arg hash whose src_cell is not in row index 4 (rank 4) on a black pawn" do
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][2] = black_pawn
      args = {
        src_cell: [3,2],
        dst_cell: [4,3],
        board: board
      }
      res = black_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid arg hash whose dst_cell results in a calculated out-of-bounds captive_cell on a white pawn" do
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        dst_cell: [7,4],
        board: board
      }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid arg hash whose dst_cell results in a calculated out-of-bounds captive_cell on a black pawn" do
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][2] = black_pawn
      args = {
        src_cell: [4,2],
        dst_cell: [0,3],
        board: board
      }
      res = black_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid arg hash whose dst_cell results in a calculated captive_cell that is not directly left or right adjacent to the cell of the white pawn it is called on" do
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        dst_cell: [3,4],
        board: board
      }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid arg hash whose dst_cell results in a calculated captive_cell that is  directly left or right adjacent to the cell of the white pawn it is called on but is not occupied by an enemy pawn" do
      black_rook = MockPiece.new({ color: :black, type: :rook })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = black_rook
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        dst_cell: [2,4],
        board: board
      }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid arg hash whose dst_cell results in a calculated captive_cell that is  directly left or right adjacent to the cell of the black pawn it is called on but is not occupied by an enemy pawn" do
      white_rook = MockPiece.new({ color: :white, type: :rook })
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][3] = white_rook
      board[4][2] = black_pawn
      args = {
        src_cell: [4,2],
        dst_cell: [5,3],
        board: board
      }
      res = black_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid arg hash whose dst_cell results in a calculated captive_cell that is  directly left or right adjacent to the cell of the white pawn it is called on but is occupied by an enemy pawn that did not double step" do
      black_pawn = PawnPiece.new({
        color: :black, did_double_step: false
      })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = black_pawn
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        dst_cell: [2,4],
        board: board
      }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns false if called with a valid arg hash whose dst_cell results in a calculated captive_cell that is  directly left or right adjacent to the cell of the white pawn it is called on but is occupied by an enemy pawn that double stepped but is not marked as capturable en-passant" do
      black_pawn = PawnPiece.new({
        color: :black, did_double_step: true,
        is_capturable_en_passant: false
      })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = black_pawn
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        dst_cell: [2,4],
        board: board
      }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(false)
    end

    it "returns true if called with a valid arg hash whose dst_cell results in a calculated captive_cell that is directly left or right adjacent to the cell of the white pawn it is called on and is occupied by an enemy pawn that double stepped and is marked as capturable en-passant" do
      black_pawn = PawnPiece.new({
        color: :black,
        did_double_step: true,
        is_capturable_en_passant: true
      })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][4] = black_pawn
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        dst_cell: [2,4],
        board: board
      }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(true)
    end

    it "returns true if called with a valid arg hash whose dst_cell results in a calculated captive_cell that is directly left or right adjacent to the cell of the white pawn it is called on and is occupied by an enemy pawn that double stepped and is marked as capturable en-passant" do
      black_pawn = PawnPiece.new({
        color: :black,
        did_double_step: true,
        is_capturable_en_passant: true
      })
      white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[3][6] = black_pawn
      board[3][5] = white_pawn
      args = {
        src_cell: [3,5],
        dst_cell: [2,6],
        board: board
      }
      res = white_pawn.can_capture_en_passant?(args)
      expect(res).to eql(true)
    end

    it "returns true if called with a valid arg hash whose dst_cell results in a calculated captive_cell that is directly left or right adjacent to the cell of the black pawn it is called on and is occupied by an enemy pawn that double stepped and is marked as capturable en-passant" do
      white_pawn = PawnPiece.new({
        color: :white,
        did_double_step: true,
        is_capturable_en_passant: true
      })
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][1] = white_pawn
      board[4][2] = black_pawn
      args = {
        src_cell: [4,2],
        dst_cell: [5,1],
        board: board
      }
      res = black_pawn.can_capture_en_passant?(args)
      expect(res).to eql(true)
    end

    it "returns true if called with a valid arg hash whose dst_cell results in a calculated captive_cell that is directly left or right adjacent to the cell of the black pawn it is called on and is occupied by an enemy pawn that double stepped and is marked as capturable en-passant" do
      white_pawn = PawnPiece.new({
        color: :white,
        did_double_step: true,
        is_capturable_en_passant: true
      })
      black_pawn = PawnPiece.new({ color: :black })
      board = Array.new(8) { Array.new(8, nil) }
      board[4][3] = white_pawn
      board[4][2] = black_pawn
      args = {
        src_cell: [4,2],
        dst_cell: [5,3],
        board: board
      }
      res = black_pawn.can_capture_en_passant?(args)
      expect(res).to eql(true)
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

    it "returns false if called with a cell that does not match where the pawn actually is and a board" do
      white_pawn = PawnPiece.new({ color: :white })
      other_white_pawn = PawnPiece.new({ color: :white })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][3] = white_pawn
      board[6][4] = other_white_pawn
      expect(white_pawn.is_promotable?([6,4], board)).to eql(false)
    end

    it "returns false if called with a cell in the top row and a board on a white pawn" do
      white_pawn = PawnPiece.new({ color: :white, did_move: true })
      board = Array.new(8) { Array.new(8, nil) }
      board[0][3] = white_pawn
      expect(white_pawn.is_promotable?([0,3], board)).to eql(false)
    end

    it "returns false if called with a cell in the bottom row and a board on a black pawn" do
      black_pawn = PawnPiece.new({ color: :black, did_move: true })
      board = Array.new(8) { Array.new(8, nil) }
      board[7][3] = black_pawn
      expect(black_pawn.is_promotable?([7,3], board)).to eql(false)
    end

    it "returns true if called with a cell in the 2nd top-most row and a board on a white pawn" do
      white_pawn = PawnPiece.new({ color: :white, did_move: true })
      board = Array.new(8) { Array.new(8, nil) }
      board[1][5] = white_pawn
      expect(white_pawn.is_promotable?([1,5], board)).to eql(true)
    end

    it "returns true if called with a cell in the 2nd bottom-most row and a board on a black pawn" do
      black_pawn = PawnPiece.new({ color: :black, did_move: true })
      board = Array.new(8) { Array.new(8, nil) }
      board[6][4] = black_pawn
      expect(black_pawn.is_promotable?([6,4], board)).to eql(true)
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
  end

  describe "#capture_en_passant" do
    it "returns the correct board if called with all valid arguments for an en-passant capture on a white pawn " do
      board = Array.new(8) { Array.new(8, nil) }
      black_pawn = PawnPiece.new({
        color: :black, did_double_step: true,
        is_capturable_en_passant: true
      })
      white_pawn = PawnPiece.new({ color: :white })
      board[3][4] = black_pawn
      board[3][5] = white_pawn
      res = white_pawn.capture_en_passant([3,5], [2,4], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[2][4] = white_pawn
      expect(res).to eql(expected)
    end

    it "returns the correct board if called with all valid arguments for an en-passant capture on a white pawn " do
      board = Array.new(8) { Array.new(8, nil) }
      black_pawn = PawnPiece.new({
        color: :black, did_double_step: true,
        is_capturable_en_passant: true
      })
      white_pawn = PawnPiece.new({ color: :white })
      board[3][6] = black_pawn
      board[3][5] = white_pawn
      res = white_pawn.capture_en_passant([3,5], [2,6], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[2][6] = white_pawn
      expect(res).to eql(expected)
    end

    it "returns the correct board if called with all valid arguments for an en-passant capture on a black pawn " do
      board = Array.new(8) { Array.new(8, nil) }
      white_pawn = PawnPiece.new({
        color: :white, did_double_step: true,
        is_capturable_en_passant: true
      })
      black_pawn = PawnPiece.new({ color: :black })
      board[4][1] = white_pawn
      board[4][2] = black_pawn
      res = black_pawn.capture_en_passant([4,2], [5,1], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[5][1] = black_pawn
      expect(res).to eql(expected)
    end

    it "returns the correct board if called with all valid arguments for an en-passant capture on a black pawn " do
      board = Array.new(8) { Array.new(8, nil) }
      white_pawn = PawnPiece.new({
        color: :white, did_double_step: true,
        is_capturable_en_passant: true
      })
      black_pawn = PawnPiece.new({ color: :black })
      board[4][3] = white_pawn
      board[4][2] = black_pawn
      res = black_pawn.capture_en_passant([4,2], [5,3], board)
      expected = Array.new(8) { Array.new(8, nil) }
      expected[5][3] = black_pawn
      expect(res).to eql(expected)
    end
  end
end
