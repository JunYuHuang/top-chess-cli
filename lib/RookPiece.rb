require './lib/Piece'
require './lib/PieceUtils'

class RookPiece < Piece
  extend PieceUtils

  attr_accessor(:default_options, :did_move)

  @@default_options = {
    color: :white,
    did_move: false
  }

  def initialize(options = @@default_options)
    passed_options = {
      color: options.fetch(:color, @@default_options[:color]),
      type: :rook,
      is_interactive: true,
      is_capturable: true
    }
    super(passed_options)
    @did_move = options.fetch(:did_move, @@default_options[:did_move])
  end

  def moves(src_cell, board, options = {})
    res = [
      *self.class.up_moves(src_cell, board, options),
      *self.class.down_moves(src_cell, board, options),
      *self.class.left_moves(src_cell, board, options),
      *self.class.right_moves(src_cell, board, options)
    ]
  end

  def captures(src_cell, board)
    res = [
      self.class.up_capture(src_cell, board),
      self.class.down_capture(src_cell, board),
      self.class.left_capture(src_cell, board),
      self.class.right_capture(src_cell, board)
    ]
    res.filter { |cell| !cell.nil? }
  end

  def did_move?
    @did_move
  end

  def moved!
    return if @did_move
    @did_move = true
  end
end

