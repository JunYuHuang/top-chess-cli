require './lib/Piece'
require './lib/PieceUtils'

=begin
This `Piece` subclass is a wildcard Piece that can be any valid chess piece (e.g. PawnPiece) or a piece that represents an empty cell on the board (i.e. EmptyPiece).

`DummyPiece` is meant to be used as a mock or test double in the testing or spec files only and not in or as part of a real chess game.
=end

class DummyPiece < Piece
  extend PieceUtils

  attr_accessor(:default_options, :did_move, :one_step)

  @@default_options = {
    color: :white,
    type: :dummy,
    is_interactive: true,
    is_capturable: true,
    did_move: false
  }

  @@one_step = { max_steps: 1 }

  def initialize(options = @@default_options)
    passed_options = {
      color: options.fetch(:color, @@default_options[:color]),
      type: options.fetch(:type, @@default_options[:type]),
      is_interactive: options.fetch(:is_interactive, @@default_options[:is_interactive]),
      is_capturable: options.fetch(:is_capturable, @@default_options[:is_capturable])
    }
    super(passed_options)
    @did_move = options.fetch(:did_move, @@default_options[:did_move])
  end

  def did_move?
    @did_move
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

  private

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

  def pawn_captures(src_cell, board)
    return [] unless self.class.is_valid_piece_color?(@color)
    @color == :white ?
      pawn_white_captures(src_cell, board) :
      pawn_black_captures(src_cell, board)
  end

  def pawn_white_captures(src_cell, board)
    res = [
      self.class.up_left_capture(src_cell, board, @@one_step),
      self.class.up_right_capture(src_cell, board, @@one_step),
    ]
    res.filter { |cell| !cell.nil? }
  end

  def pawn_black_captures(src_cell, board)
    res = [
      self.class.down_left_capture(src_cell, board, @@one_step),
      self.class.down_right_capture(src_cell, board, @@one_step),
    ]
    res.filter { |cell| !cell.nil? }
  end

  def king_captures(src_cell, board, options = {})
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
end
