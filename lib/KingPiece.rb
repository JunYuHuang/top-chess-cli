require './lib/Piece'
require './lib/PieceUtils'

class KingPiece < Piece
  extend PieceUtils

  attr_accessor(:default_options, :did_move, :one_step)

  @@default_options = {
    color: :white,
    did_move: false,
  }

  @@one_step = { max_steps: 1 }

  def initialize(options = @@default_options)
    passed_options = {
      color: options.fetch(:color, @@default_options[:color]),
      type: :king,
      is_interactive: true,
      is_capturable: false
    }
    super(passed_options)
    @did_move = options.fetch(:did_move, @@default_options[:did_move])
  end

  # TODO - to test
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

  # TODO - to test
  def captures(src_cell, board)
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
    res.filter { |cell| !cell.nil? && !is_checked?(cell, board) }
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

    board_copy = self.class.deep_copy(board)
    src_row, src_col = src_cell
    board_copy[src_row][src_col] = self
    filter = @color == :white ? { color: :black } : { color: :white }
    enemy_pieces = self.class.pieces(board, filter)
    enemy_pieces.each do |enemy|
      # skip enemy king b/c it is illegal for a king to check an enemy king
      next if enemy[:piece].type == :king
      enemy_captures = enemy[:piece].captures(enemy[:cell], board_copy)
      checkable = enemy_captures.include?(src_cell)
      return true if checkable
    end
    false
  end

  # TODO - to test
  def is_checkmated?(src_cell, board)
    return false unless is_checked?(src_cell, board)
    # TODO
  end

  # TODO - to test
  def is_stalemated?(src_cell, board)
    return false if is_checked?(src_cell, board)
    # TODO
  end

  # TODO - to test
  # includes all cells that the king must traverse over to reach its destination castling cell (including the destination cell)
  def moves_queenside_castle(src_cell, board)
    # TODO
  end

  # TODO - to test
  # includes all cells that the king must traverse over to reach its destination castling cell (including the destination cell)
  def moves_kingside_castle(src_cell, board)
    # TODO
  end

  # TODO - to test
  def can_queenside_castle?(src_cell, board)
    return false unless self.class.is_inbound_cell?(src_cell)
    return false if self.class.is_empty_cell?(src_cell)
    @color == :white ?
      can_white_queenside_castle?(src_cell, board) :
      can_black_queenside_castle?(src_cell, board)
  end

  # TODO - to test
  def can_kingside_castle?(src_cell, board)
    return false unless self.class.is_inbound_cell?(src_cell)
    return false if self.class.is_empty_cell?(src_cell)
    @color == :white ?
      can_white_kingside_castle?(src_cell, board) :
      can_black_kingside_castle?(src_cell, board)
  end

  private

  # TODO - to test
  def can_white_queenside_castle?(src_cell, board)
    return false if did_move?

    filters = { color: :white, row: 7, col: 0 }
    left_white_rook = self.class.pieces(board, filters)[0]
    return false if left_white_rook.nil?
    return false if left_white_rook[:piece].did_move?

    src_row, src_col = src_cell
    rook_row, rook_col = left_white_rook[:cell]
    return false if src_row != rook_row
    return false if is_checked?(src_cell, board)
    # TODO - return false if any cells the white king moves across to its castling makes the king in check
    # TODO - return false the destination cell that the king moves to for castling makes the king in check
    # TODO - return false if any cells between the left white rook and white king are non-empty
    true
  end

  # TODO - to test
  def can_white_kingside_castle?(src_cell, board)
    # TODO
  end

  # TODO - to test
  def can_black_queenside_castle?(src_cell, board)
    # TODO
  end

  # TODO - to test
  def can_black_kingside_castle?(src_cell, board)
    # TODO
  end
end

