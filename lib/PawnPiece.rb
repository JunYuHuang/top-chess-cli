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
  def can_capture_en_passant?(args, &is_right_last_move)
    src_cell = args.fetch(:src_cell, nil)
    captive_cell = args.fetch(:captive_cell, nil)
    board = args.fetch(:board, nil)
    return false if src_cell.nil? or captive_cell.nil? or board.nil?
    return false if self.class.is_empty_cell?(src_cell)
    return false if self.class.is_empty_cell?(captive_cell)
    return false unless is_valid_piece_color?(@color)
    return false unless block_given?
    return false unless is_right_last_move.call(args)

    @color == :white ?
      white_captures(src_cell, board) :
      black_captures(src_cell, board)
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

  def double_step!
    return if @did_double_step
    @did_double_step = true
  end

  private

  def white_moves(src_cell, board)
    options = did_move? ? @@one_step : @@two_steps
    self.class.up_moves(src_cell, board, options)
  end

  def white_captures(src_cell, board)
    res = [
      self.class.up_left_capture(src_cell, board, @@one_step),
      self.class.up_right_capture(src_cell, board, @@one_step),
    ]
    res.filter { |cell| !cell.nil? }
  end

  # TODO - to test
  def can_white_capture_en_passant?(src_cell, board)
    # TODO
  end

  # TODO - to test
  def white_capture_en_passant(src_cell, board)
    # TODO
  end

  def black_moves(src_cell, board)
    options = did_move? ? @@one_step : @@two_steps
    self.class.down_moves(src_cell, board, options)
  end

  def black_captures(src_cell, board)
    res = [
      self.class.down_left_capture(src_cell, board, @@one_step),
      self.class.down_right_capture(src_cell, board, @@one_step),
    ]
    res.filter { |cell| !cell.nil? }
  end

  # TODO - to test
  def can_black_capture_en_passant?(src_cell, board)
    # TODO
  end

  # TODO - to test
  def black_capture_en_passant(src_cell, board)
    # TODO
  end
end

