require './lib/Piece'
require './lib/PieceUtils'

class PawnPiece < Piece
  extend PieceUtils

  attr_accessor(
    :default_options, :did_move, :one_step, :two_steps, :did_double_step
  )

  @@default_options = {
    color: :white,
    did_move: false,
    did_double_step: false
  }

  @@one_step = { max_steps: 1 }

  @@two_steps = { max_steps: 2 }

  def initialize(options = @@default_options)
    passed_options = {
      color: options.fetch(:color, @@default_options[:color]),
      type: :pawn,
      is_capturable: true
    }
    super(passed_options)
    @did_move = options.fetch(:did_move, @@default_options[:did_move])
    @did_double_step = options.fetch(:did_double_step, @@default_options[:did_double_step])
  end

  def moves(src_cell, board)
    return [] unless self.class.is_valid_piece_color?(@color)
    @color == :white ?
      white_moves(src_cell, board) :
      black_moves(src_cell, board)
  end

  def captures(src_cell, board)
    return [] unless self.class.is_valid_piece_color?(@color)
    @color == :white ?
      white_captures(src_cell, board) :
      black_captures(src_cell, board)
  end

  # TODO - to test
  def can_capture_en_passant?(args, &is_proper_last_move)
    src_cell = args.fetch(:src_cell, nil)
    captive_cell = args.fetch(:captive_cell, nil)
    board = args.fetch(:board, nil)
    return false if src_cell.nil? or captive_cell.nil? or board.nil?
    return false unless self.class.is_inbound_cell?(src_cell)
    return false if self.class.is_empty_cell?(src_cell, board)
    return false unless self.class.is_inbound_cell?(captive_cell)
    return false if self.class.is_empty_cell?(captive_cell, board)
    return false unless self.class.is_valid_piece_color?(@color)
    return false unless self.class.is_enemy_piece_cell?(src_cell, captive_cell, board)
    return false unless self.class.is_piece_type?(src_cell, board, :pawn)
    return false unless self.class.is_piece_color?(src_cell, board, @color)
    return false unless self.class.is_piece_type?(captive_cell, board, :pawn)

    cap_row, cap_col = captive_cell
    return false unless self.class.in_row?(src_cell, cap_row)
    return false unless block_given?

    @color == :white ?
      can_white_capture_en_passant?(args, &is_proper_last_move) :
      can_black_capture_en_passant?(args, &is_proper_last_move)
  end

  # TODO - to test
  def capture_en_passant(src_cell, board)
    @color == :white ?
      white_capture_en_passant(src_cell, board) :
      black_capture_en_passant(src_cell, board)
  end

  def did_move?
    @did_move
  end

  def moved!
    return if @did_move
    @did_move = true
  end

  def is_promotable?(src_cell, board)
    self.class.at_last_row?(src_cell, board)
  end

  def is_valid_promotion?(piece_type)
    self.class.is_valid_promotion?(piece_type)
  end

  def did_double_step?
    @did_double_step
  end

  def double_stepped!
    return if @did_double_step
    @did_double_step = true
  end

  private

  def white_moves(src_cell, board)
    options = did_move? ? @@one_step : @@two_steps
    self.class.up_moves(src_cell, board, options)
  end

  def black_moves(src_cell, board)
    options = did_move? ? @@one_step : @@two_steps
    self.class.down_moves(src_cell, board, options)
  end

  def white_captures(src_cell, board)
    res = [
      self.class.up_left_capture(src_cell, board, @@one_step),
      self.class.up_right_capture(src_cell, board, @@one_step),
    ]
    res.filter { |cell| !cell.nil? }
  end

  def black_captures(src_cell, board)
    res = [
      self.class.down_left_capture(src_cell, board, @@one_step),
      self.class.down_right_capture(src_cell, board, @@one_step),
    ]
    res.filter { |cell| !cell.nil? }
  end

  def can_white_capture_en_passant_left?(args, &is_proper_last_move)
    args => { src_cell:, captive_cell:, board: }

    return false unless self.class.in_row?(src_cell, 3)
    return false unless self.class.in_row?(captive_cell, 3)
    return false unless self.class.is_left_adjacent?(src_cell, captive_cell)

    cap_row, cap_col = captive_cell
    top_adjacent = [cap_row - 1, cap_col]
    return false unless self.class.is_empty_cell?(top_adjacent, board)

    enemy_pawn = self.class.pieces(board, { row: cap_row, col: cap_col })[0]
    return false unless enemy_pawn[:piece].did_double_step?

    return false unless is_proper_last_move.call(args)

    true
  end

  # TODO - to test
  def can_black_capture_en_passant_left?(args, &is_proper_last_move)
    args => { src_cell:, captive_cell:, board: }

    return false unless self.class.in_row?(src_cell, 4)
    return false unless self.class.in_row?(captive_cell, 4)
    return false unless self.class.is_left_adjacent?(src_cell, captive_cell)

    cap_row, cap_col = captive_cell
    top_adjacent = [cap_row - 1, cap_col]
    return false unless self.class.is_empty_cell?(top_adjacent, board)

    enemy_pawn = self.class.pieces(board, { row: cap_row, col: cap_col })[0]
    return false unless enemy_pawn[:piece].did_double_step?

    return false unless is_proper_last_move.call(args)

    true
  end

  # TODO - to test
  def can_white_capture_en_passant_right?(args, &is_proper_last_move)
    args => { src_cell:, captive_cell:, board: }

    return false unless self.class.in_row?(src_cell, 3)
    return false unless self.class.in_row?(captive_cell, 3)
    return false unless self.class.is_right_adjacent?(src_cell, captive_cell)

    cap_row, cap_col = captive_cell
    top_adjacent = [cap_row - 1, cap_col]
    return false unless self.class.is_empty_cell?(top_adjacent, board)

    enemy_pawn = self.class.pieces(board, { row: cap_row, col: cap_col })[0]
    return false unless enemy_pawn[:piece].did_double_step?

    return false unless is_proper_last_move.call(args)

    true
  end

  # TODO - to test
  def can_black_capture_en_passant_right?(args, &is_proper_last_move)
    args => { src_cell:, captive_cell:, board: }

    return false unless self.class.in_row?(src_cell, 4)
    return false unless self.class.in_row?(captive_cell, 4)
    return false unless self.class.is_left_adjacent?(src_cell, captive_cell)

    cap_row, cap_col = captive_cell
    top_adjacent = [cap_row - 1, cap_col]
    return false unless self.class.is_empty_cell?(top_adjacent, board)

    enemy_pawn = self.class.pieces(board, { row: cap_row, col: cap_col })[0]
    return false unless enemy_pawn[:piece].did_double_step?

    return false unless is_proper_last_move.call(args)

    true
  end

  # TODO - to test
  def can_white_capture_en_passant?(args, &is_proper_last_move)
    return true if can_white_capture_en_passant_left?(args, &is_proper_last_move)
    return true if can_white_capture_en_passant_right?(args, &is_proper_last_move)
    false
  end

  # TODO - to test
  def can_black_capture_en_passant?(args, &is_proper_last_move)
    return true if can_black_capture_en_passant_left?(args, &is_proper_last_move)
    return true if can_black_capture_en_passant_right?(args, &is_proper_last_move)
    false
  end

  # TODO - to test
  def white_capture_en_passant(src_cell, board)
    # TODO
  end

  # TODO - to test
  def black_capture_en_passant(src_cell, board)
    # TODO
  end
end

