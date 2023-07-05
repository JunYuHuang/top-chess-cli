require './lib/Piece'
require './lib/PieceUtils'

class KingPiece < Piece
  extend PieceUtils

  attr_accessor(
    :default_options, :did_move, :one_step, :two_steps, :three_steps
  )

  @@default_options = {
    color: :white,
    did_move: false,
  }

  @@one_step = { max_steps: 1 }

  @@two_steps = { max_steps: 2 }

  @@three_steps = { max_steps: 3 }

  def initialize(options = @@default_options)
    passed_options = {
      color: options.fetch(:color, @@default_options[:color]),
      type: :king,
      is_capturable: false
    }
    super(passed_options)
    @did_move = options.fetch(:did_move, @@default_options[:did_move])
  end

  def moves(src_cell, board)
    res = [
      *self.class.up_moves(src_cell, board, @@one_step),
      *self.class.down_moves(src_cell, board, @@one_step),
      *self.class.left_moves(src_cell, board, @@one_step),
      *self.class.right_moves(src_cell, board, @@one_step),
      *self.class.down_left_moves(src_cell, board, @@one_step),
      *self.class.up_right_moves(src_cell, board, @@one_step),
      *self.class.down_right_moves(src_cell, board, @@one_step),
      *self.class.up_left_moves(src_cell, board, @@one_step)
    ]
    res.filter { |cell| !is_checked?(cell, board) }
  end

  def captures(src_cell, board, options = {})
    filter_is_checked = options.fetch(:filter_is_checked, true)

    res = [
      self.class.up_capture(src_cell, board, @@one_step),
      self.class.down_capture(src_cell, board, @@one_step),
      self.class.left_capture(src_cell, board, @@one_step),
      self.class.right_capture(src_cell, board, @@one_step),
      self.class.down_left_capture(src_cell, board, @@one_step),
      self.class.up_right_capture(src_cell, board, @@one_step),
      self.class.down_right_capture(src_cell, board, @@one_step),
      self.class.up_left_capture(src_cell, board, @@one_step)
    ]
    res.filter! { |cell| !cell.nil? }
    filter_is_checked ? res.filter { |cell| !is_checked?(cell, board)} : res
  end

  def did_move?
    @did_move
  end

  def moved!
    return if @did_move
    @did_move = true
  end

  def is_checked?(src_cell, board)
    return false unless self.class.is_inbound_cell?(src_cell)

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
    return false unless is_checked?(src_cell, board)
    moves(src_cell, board).size == 0
  end

  def is_stalemated?(src_cell, board)
    return false if is_checked?(src_cell, board)
    moves(src_cell, board).size == 0
  end

  def can_queenside_castle?(src_cell, board)
    return false unless self.class.is_inbound_cell?(src_cell)
    return false if self.class.is_empty_cell?(src_cell, board)
    @color == :white ?
      can_white_queenside_castle?(src_cell, board) :
      can_black_queenside_castle?(src_cell, board)
  end

  def can_kingside_castle?(src_cell, board)
    return false unless self.class.is_inbound_cell?(src_cell)
    return false if self.class.is_empty_cell?(src_cell, board)
    @color == :white ?
      can_white_kingside_castle?(src_cell, board) :
      can_black_kingside_castle?(src_cell, board)
  end

  private

  # includes all cells that the king must traverse over to reach its destination castling cell (including the destination cell)
  def moves_queenside_castle(src_cell, board)
    return false unless self.class.is_inbound_cell?(src_cell)
    return false if self.class.is_empty_cell?(src_cell, board)
    res = self.class.left_moves(src_cell, board, @@two_steps)
    res.filter { |cell| !is_checked?(cell, board) }
  end

  # includes all cells that the king must traverse over to reach its destination castling cell (including the destination cell)
  def moves_kingside_castle(src_cell, board)
    return false unless self.class.is_inbound_cell?(src_cell)
    return false if self.class.is_empty_cell?(src_cell, board)
    res = self.class.right_moves(src_cell, board, @@two_steps)
    res.filter { |cell| !is_checked?(cell, board) }
  end

  def are_cells_amid_queenside_castle_empty?(src_cell, board)
    self.class.left_moves(src_cell, board, @@three_steps).size == 3
  end

  def are_cells_amid_kingside_castle_empty?(src_cell, board)
    self.class.right_moves(src_cell, board, @@two_steps).size == 2
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

