require './lib/Piece'
require './lib/PieceUtils'

class PawnPiece < Piece
  extend PieceUtils

  attr_accessor(:default_options, :did_move, :one_step, :two_steps)

  @@default_options = {
    color: :white,
    did_move: false
  }

  @@one_step = { max_steps: 1 }

  @@two_steps = { max_steps: 2 }

  def initialize(options = @@default_options)
    passed_options = {
      color: options.fetch(:color, @@default_options[:color]),
      type: :pawn,
      is_interactive: true,
      is_capturable: true
    }
    super(passed_options)
    @did_move = options.fetch(:did_move, @@default_options[:did_move])
  end

  def moves(src_cell, board)
    return [] unless self.class.is_valid_piece_color?(@color)
    @color == :white ?
      white_moves(src_cell, board) :
      black_moves(src_cell, board)
  end

  # TODO - to test
  def captures(src_cell, board)
    return [] unless self.class.is_valid_piece_color?(@color)
    @color == :white ?
      white_captures(src_cell, board) :
      black_captures(src_cell, board)
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

  private

  def white_moves(src_cell, board)
    options = did_move? ? @@one_step : @@two_steps
    self.class.up_moves(src_cell, board, options)
  end

  # TODO - to test
  def white_captures(src_cell, board)
    res = [
      self.class.up_left_capture(src_cell, board, @@one_step),
      self.class.up_right_capture(src_cell, board, @@one_step),
    ]
    # if can_white_capture_en_passant?(src_cell, board)
    #   # TODO
    # end
    res.filter { |cell| !cell.nil? }
  end

  # TODO - to test
  def can_white_capture_en_passant?(src_cell, board)
    # TODO
  end

  def black_moves(src_cell, board)
    options = did_move? ? @@one_step : @@two_steps
    self.class.down_moves(src_cell, board, options)
  end

  # TODO - to test
  def black_captures(src_cell, board)
    res = [
      self.class.down_left_capture(src_cell, board, @@one_step),
      self.class.down_right_capture(src_cell, board, @@one_step),
    ]
    # if can_black_capture_en_passant?(src_cell, board)
    #   # TODO
    # end
    res.filter { |cell| !cell.nil? }
  end

  # TODO - to test
  def can_black_capture_en_passant?(src_cell, board)
    # TODO
  end
end

