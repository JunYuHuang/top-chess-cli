require './lib/Piece'
require './lib/PieceUtils'

=begin
This `Piece` subclass is a wildcard Piece that can be any valid chess piece (e.g. PawnPiece) or a piece that represents an empty cell on the board (i.e. EmptyPiece).

`MockPiece` is meant to be used as a mock or test double in the testing or spec files only and not in or as part of a real chess game.
=end

class MockPiece < Piece
  extend PieceUtils

  ONE_STEP_MAX = { max_steps: 1 }
  TWO_STEPS_MAX = { max_steps: 2 }
  THREE_STEPS_MAX = { max_steps: 3 }
  DEFAULTS = {
    color: :white,
    type: :mock,
    is_capturable: true,
    did_move: false,
    is_capturable_en_passant: false,
  }

  attr_accessor(:did_move, :is_capturable_en_passant)

  def initialize(options = DEFAULTS)
    passed_options = {
      color: options.fetch(:color, DEFAULTS[:color]),
      type: options.fetch(:type, DEFAULTS[:type]),
      is_capturable: options.fetch(
        :is_capturable, DEFAULTS[:is_capturable]
      )
    }
    super(passed_options)
    @did_move = options.fetch(:did_move, DEFAULTS[:did_move])
    @is_capturable_en_passant = options.fetch(
      :is_capturable_en_passant, DEFAULTS[:is_capturable_en_passant]
    )
  end

  def did_move?
    @did_move
  end

  def is_capturable_en_passant?
    @is_capturable_en_passant
  end

  def moves(src_cell, board)
    return [] if !self.class.is_inbound_cell?(src_cell)
    return [] if self.class.is_empty_cell?(src_cell, board)

    src_row, src_col = src_cell
    piece = board[src_row][src_col]
    return king_moves(src_cell, board) if piece.type == :king
    return rook_moves(src_cell, board) if piece.type == :rook
    return bishop_moves(src_cell, board) if piece.type == :bishop
    return knight_moves(src_cell, board) if piece.type == :knight
    return queen_moves(src_cell, board) if piece.type == :queen
    return pawn_moves(src_cell, board) if piece.type == :pawn
  end

  def captures(src_cell, board, options = {})
    return [] if !self.class.is_inbound_cell?(src_cell)
    return [] if self.class.is_empty_cell?(src_cell, board)

    src_row, src_col = src_cell
    piece = board[src_row][src_col]

    return king_captures(src_cell, board, options) if piece.type == :king
    return rook_captures(src_cell, board) if piece.type == :rook
    return bishop_captures(src_cell, board) if piece.type == :bishop
    return knight_captures(src_cell, board) if piece.type == :knight
    return queen_captures(src_cell, board) if piece.type == :queen
    return pawn_captures(src_cell, board) if piece.type == :pawn
  end

  def is_checked?(src_cell, board)
    return false unless self.class.is_inbound_cell?(src_cell)
    return false unless @type == :king

    # make copy of `board` and move the king's position in it to `src_cell`
    # in case `src_cell` is not where the king itself actually is
    board_copy = self.class.deep_copy(board)
    filters = { color: @color, type: :king }
    board_copy = self.class.remove_pieces(board_copy, filters)
    src_row, src_col = src_cell
    board_copy[src_row][src_col] = self

    filter = @color == :white ? { color: :black } : { color: :white }
    enemy_pieces = self.class.pieces(board, filter)
    enemy_pieces.each do |enemy|
      enemy_captures = []
      if enemy[:piece].type == :king
        option = { filter_is_checked: false }
        enemy_captures = enemy[:piece].captures(enemy[:cell], board_copy, option)
      else
        enemy_captures = enemy[:piece].captures(enemy[:cell], board_copy)
      end
      checkable = enemy_captures.include?(src_cell)
      return true if checkable
    end
    false
  end

  def is_checkmated?(src_cell, board)
    return false unless @type == :king
    return false unless is_checked?(src_cell, board)
    moves(src_cell, board).size == 0
  end

  def is_stalemated?(src_cell, board)
    return false unless @type == :king
    return false if is_checked?(src_cell, board)

    adj_cells = self.class.adjacent_cells(src_cell)
    return false if adj_cells.all? do |cell|
      !self.class.is_empty_cell?(cell, board)
    end
    moves(src_cell, board).size == 0
  end

  def can_queenside_castle?(src_cell, board)
    return false unless self.class.is_inbound_cell?(src_cell)
    return false if self.class.is_empty_cell?(src_cell, board)
    return false unless @type == :king
    @color == :white ?
      can_white_queenside_castle?(src_cell, board) :
      can_black_queenside_castle?(src_cell, board)
  end

  def can_kingside_castle?(src_cell, board)
    return false unless self.class.is_inbound_cell?(src_cell)
    return false if self.class.is_empty_cell?(src_cell, board)
    return false unless @type == :king
    @color == :white ?
      can_white_kingside_castle?(src_cell, board) :
      can_black_kingside_castle?(src_cell, board)
  end

  def captures_en_passant(src_cell, board)
    return [] unless self.class.is_valid_piece_color?(@color)
    return [] unless @type == :pawn

    @color == :white ?
      white_captures_en_passant(src_cell, board) :
      black_captures_en_passant(src_cell, board)
  end

  def is_promotable?(src_cell, board)
    return false unless self.class.is_inbound_cell?(src_cell)
    return false if self.class.is_empty_cell?(src_cell, board)
    return false unless @type == :pawn

    src_row, src_col = src_cell
    filter = { row: src_row, col: src_col }
    pieces = self.class.pieces(board, filter)
    return false if pieces.size != 1

    itself_on_board = pieces[0]
    return false if itself_on_board[:piece] != self
    return false unless self.class.is_valid_piece_color?(@color)

    @color == :white ?
      src_row == 1 :
      src_row == self.class.board_length - 2
  end

  private

  def rook_moves(src_cell, board, options = {})
    res = [
      *self.class.up_moves(src_cell, board, options),
      *self.class.down_moves(src_cell, board, options),
      *self.class.left_moves(src_cell, board, options),
      *self.class.right_moves(src_cell, board, options)
    ]
  end

  def bishop_moves(src_cell, board, options = {})
    res = [
      *self.class.down_left_moves(src_cell, board, options),
      *self.class.up_right_moves(src_cell, board, options),
      *self.class.down_right_moves(src_cell, board, options),
      *self.class.up_left_moves(src_cell, board, options)
    ]
  end

  def knight_moves(src_cell, board)
    self.class.l_shaped_moves(src_cell, board)
  end

  def queen_moves(src_cell, board, options = {})
    res = [
      *self.class.up_moves(src_cell, board, options),
      *self.class.down_moves(src_cell, board, options),
      *self.class.left_moves(src_cell, board, options),
      *self.class.right_moves(src_cell, board, options),
      *self.class.down_left_moves(src_cell, board, options),
      *self.class.up_right_moves(src_cell, board, options),
      *self.class.down_right_moves(src_cell, board, options),
      *self.class.up_left_moves(src_cell, board, options)
    ]
  end

  def pawn_moves(src_cell, board)
    return [] unless self.class.is_valid_piece_color?(@color)
    @color == :white ?
      pawn_white_moves(src_cell, board) :
      pawn_black_moves(src_cell, board)
  end

  def pawn_white_moves(src_cell, board)
    options = did_move? ? ONE_STEP_MAX : TWO_STEPS_MAX
    self.class.up_moves(src_cell, board, options)
  end

  def pawn_black_moves(src_cell, board)
    options = did_move? ? ONE_STEP_MAX : TWO_STEPS_MAX
    self.class.down_moves(src_cell, board, options)
  end

  def king_moves(src_cell, board)
    res = [
      *self.class.up_moves(src_cell, board, ONE_STEP_MAX),
      *self.class.down_moves(src_cell, board, ONE_STEP_MAX),
      *self.class.left_moves(src_cell, board, ONE_STEP_MAX),
      *self.class.right_moves(src_cell, board, ONE_STEP_MAX),
      *self.class.down_left_moves(src_cell, board, ONE_STEP_MAX),
      *self.class.up_right_moves(src_cell, board, ONE_STEP_MAX),
      *self.class.down_right_moves(src_cell, board, ONE_STEP_MAX),
      *self.class.up_left_moves(src_cell, board, ONE_STEP_MAX)
    ]
    res.filter { |cell| !is_checked?(cell, board) }
  end

  def rook_captures(src_cell, board)
    res = [
      self.class.up_capture(src_cell, board),
      self.class.down_capture(src_cell, board),
      self.class.left_capture(src_cell, board),
      self.class.right_capture(src_cell, board)
    ]
    res.filter { |cell| !cell.nil? }
  end

  def bishop_captures(src_cell, board)
    res = [
      self.class.down_left_capture(src_cell, board),
      self.class.up_right_capture(src_cell, board),
      self.class.down_right_capture(src_cell, board),
      self.class.up_left_capture(src_cell, board)
    ]
    res.filter { |cell| !cell.nil? }
  end

  def knight_captures(src_cell, board)
    self.class.l_shaped_captures(src_cell, board)
  end

  def queen_captures(src_cell, board)
    res = [
      self.class.up_capture(src_cell, board),
      self.class.down_capture(src_cell, board),
      self.class.left_capture(src_cell, board),
      self.class.right_capture(src_cell, board),
      self.class.down_left_capture(src_cell, board),
      self.class.up_right_capture(src_cell, board),
      self.class.down_right_capture(src_cell, board),
      self.class.up_left_capture(src_cell, board)
    ]
    res.filter { |cell| !cell.nil? }
  end

  # Excludes mocked en-passant captures (cells)
  def pawn_captures(src_cell, board)
    return [] unless self.class.is_valid_piece_color?(@color)
    @color == :white ?
      pawn_white_captures(src_cell, board) :
      pawn_black_captures(src_cell, board)
  end

  def pawn_white_captures(src_cell, board)
    res = [
      self.class.up_left_capture(src_cell, board, ONE_STEP_MAX),
      self.class.up_right_capture(src_cell, board, ONE_STEP_MAX),
    ]
    res.filter { |cell| !cell.nil? }
  end

  def pawn_black_captures(src_cell, board)
    res = [
      self.class.down_left_capture(src_cell, board, ONE_STEP_MAX),
      self.class.down_right_capture(src_cell, board, ONE_STEP_MAX),
    ]
    res.filter { |cell| !cell.nil? }
  end

  def can_capture_en_passant?(args)
    src_cell = args.fetch(:src_cell, nil)
    dst_cell = args.fetch(:dst_cell, nil)
    board = args.fetch(:board, nil)
    return false if src_cell.nil? or dst_cell.nil? or board.nil?
    return false unless self.class.is_inbound_cell?(src_cell)
    return false unless self.class.is_inbound_cell?(dst_cell)
    return false unless self.class.is_empty_cell?(dst_cell, board)
    return false unless @type == :pawn

    capturer_args = {
      board: board, piece_type: :pawn, piece_color: @color, cell: src_cell
    }
    return false unless self.class.is_matching_piece?(capturer_args)
    return false if @color == :white && !self.class.in_row?(src_cell, 3)
    return false if @color == :black && !self.class.in_row?(src_cell, 4)

    captive_cell = @color == :white ?
      self.class.down_adjacent_cell(dst_cell) :
      self.class.up_adjacent_cell(dst_cell)
    return false unless self.class.is_inbound_cell?(captive_cell)

    return false unless (
      self.class.is_left_adjacent?(src_cell, captive_cell) or
      self.class.is_right_adjacent?(src_cell, captive_cell)
    )

    captive_args = {
      board: board, piece_type: :pawn, cell: captive_cell,
      piece_color: self.class.enemy_color(@color)
    }
    return false unless self.class.is_matching_piece?(captive_args)

    captive_row, captive_col = captive_cell
    capturee_filter = { row: captive_row, col: captive_col }
    capturee_pawn = self.class.pieces(board, capturee_filter)[0]

    capturee_pawn[:piece].is_capturable_en_passant?
  end

  def king_captures(src_cell, board, options = {})
    filter_is_checked = options.fetch(:filter_is_checked, true)

    res = [
      self.class.up_capture(src_cell, board, ONE_STEP_MAX),
      self.class.down_capture(src_cell, board, ONE_STEP_MAX),
      self.class.left_capture(src_cell, board, ONE_STEP_MAX),
      self.class.right_capture(src_cell, board, ONE_STEP_MAX),
      self.class.down_left_capture(src_cell, board, ONE_STEP_MAX),
      self.class.up_right_capture(src_cell, board, ONE_STEP_MAX),
      self.class.down_right_capture(src_cell, board, ONE_STEP_MAX),
      self.class.up_left_capture(src_cell, board, ONE_STEP_MAX)
    ]
    res.filter! { |cell| !cell.nil? }
    filter_is_checked ? res.filter { |cell| !is_checked?(cell, board)} : res
  end

  def white_captures_en_passant(src_cell, board)
    res = []

    up_left_cell = self.class.up_left_moves(src_cell, board, ONE_STEP_MAX)[0]
    up_left_args = {
      src_cell: src_cell, dst_cell: up_left_cell, board: board
    }
    res.push(up_left_cell) if can_capture_en_passant?(up_left_args)

    up_right_cell = self.class.up_right_moves(src_cell, board, ONE_STEP_MAX)[0]
    up_right_args = {
      src_cell: src_cell, dst_cell: up_right_cell, board: board
    }
    res.push(up_right_cell) if can_capture_en_passant?(up_right_args)

    res
  end

  def black_captures_en_passant(src_cell, board)
    res = []

    down_left_cell = self.class.down_left_moves(src_cell, board, ONE_STEP_MAX)[0]
    down_left_args = {
      src_cell: src_cell, dst_cell: down_left_cell, board: board
    }
    res.push(down_left_cell) if can_capture_en_passant?(down_left_args)

    down_right_cell = self.class.down_right_moves(src_cell, board, ONE_STEP_MAX)[0]
    down_right_args = {
      src_cell: src_cell, dst_cell: down_right_cell, board: board
    }
    res.push(down_right_cell) if can_capture_en_passant?(down_right_args)

    res
  end

  # includes all cells that the king must traverse over to reach its destination castling cell (including the destination cell)
  def moves_queenside_castle(src_cell, board)
    return [] unless self.class.is_inbound_cell?(src_cell)
    return [] if self.class.is_empty_cell?(src_cell, board)
    res = self.class.left_moves(src_cell, board, TWO_STEPS_MAX)
    res.filter { |cell| !is_checked?(cell, board) }
  end

  # includes all cells that the king must traverse over to reach its destination castling cell (including the destination cell)
  def moves_kingside_castle(src_cell, board)
    return [] unless self.class.is_inbound_cell?(src_cell)
    return [] if self.class.is_empty_cell?(src_cell, board)
    res = self.class.right_moves(src_cell, board, TWO_STEPS_MAX)
    res.filter { |cell| !is_checked?(cell, board) }
  end

  def are_cells_amid_queenside_castle_empty?(src_cell, board)
    self.class.left_moves(src_cell, board, THREE_STEPS_MAX).size == 3
  end

  def are_cells_amid_kingside_castle_empty?(src_cell, board)
    self.class.right_moves(src_cell, board, TWO_STEPS_MAX).size == 2
  end

  def can_white_queenside_castle?(src_cell, board)
    return false if did_move?

    # the following query also implicitly checks if the left white rook is in the same rank or row as the white king
    filters = { color: :white, row: 7, col: 0 }
    left_white_rook = self.class.pieces(board, filters)[0]
    return false if left_white_rook.nil?
    return false if left_white_rook[:piece].did_move?

    return false if is_checked?(src_cell, board)

    # return false if any cells (2 cells) between the left white rook and the white king are non-empty
    return false unless are_cells_amid_queenside_castle_empty?(src_cell, board)

    # return false if any cells the white king moves across to its castling (including the destination cell) makes the king in check
    return false if moves_queenside_castle(src_cell, board).size != 2

    true
  end

  def can_black_queenside_castle?(src_cell, board)
    return false if did_move?

    # the following query also implicitly checks if the left black rook is in the same rank or row as the black king
    filters = { color: :black, row: 0, col: 0 }
    left_black_rook = self.class.pieces(board, filters)[0]
    return false if left_black_rook.nil?
    return false if left_black_rook[:piece].did_move?

    return false if is_checked?(src_cell, board)

    # return false if any cells (2 cells) between the left black rook and the black king are non-empty
    return false unless are_cells_amid_queenside_castle_empty?(src_cell, board)

    # return false if any cells the black king moves across to its castling (including the destination cell) makes the king in check
    return false if moves_queenside_castle(src_cell, board).size != 2

    true
  end

  def can_white_kingside_castle?(src_cell, board)
    return false if did_move?

    # the following query also implicitly checks if the right white rook is in the same rank or row as the white king
    filters = { color: :white, row: 7, col: 7 }
    right_white_rook = self.class.pieces(board, filters)[0]
    return false if right_white_rook.nil?
    return false if right_white_rook[:piece].did_move?

    return false if is_checked?(src_cell, board)

    # return false if any cells (2 cells) between the right white rook and the white king are non-empty
    return false unless are_cells_amid_kingside_castle_empty?(src_cell, board)

    # return false if any cells the white king moves across to its castling (including the destination cell) makes the king in check
    return false if moves_kingside_castle(src_cell, board).size != 2

    true
  end

  def can_black_kingside_castle?(src_cell, board)
    return false if did_move?

    # the following query also implicitly checks if the right black rook is in the same rank or row as the black king
    filters = { color: :black, row: 0, col: 7 }
    right_black_rook = self.class.pieces(board, filters)[0]
    return false if right_black_rook.nil?
    return false if right_black_rook[:piece].did_move?

    return false if is_checked?(src_cell, board)

    # return false if any cells (2 cells) between the right black rook and the black king are non-empty
    return false unless are_cells_amid_kingside_castle_empty?(src_cell, board)

    # return false if any cells the black king moves across to its castling (including the destination cell) makes the king in check
    return false if moves_kingside_castle(src_cell, board).size != 2

    true
  end
end
