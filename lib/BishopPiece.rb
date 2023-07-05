require './lib/Piece'
require './lib/PieceUtils'

class BishopPiece < Piece
  extend PieceUtils

  attr_accessor(:default_options)

  @@default_options = {
    color: :white,
  }

  def initialize(options = @@default_options)
    passed_options = {
      color: options.fetch(:color, @@default_options[:color]),
      type: :bishop,
      is_capturable: true
    }
    super(passed_options)
  end

  def moves(src_cell, board, options = {})
    res = [
      *self.class.down_left_moves(src_cell, board, options),
      *self.class.up_right_moves(src_cell, board, options),
      *self.class.down_right_moves(src_cell, board, options),
      *self.class.up_left_moves(src_cell, board, options)
    ]
  end

  def captures(src_cell, board)
    res = [
      self.class.down_left_capture(src_cell, board),
      self.class.up_right_capture(src_cell, board),
      self.class.down_right_capture(src_cell, board),
      self.class.up_left_capture(src_cell, board)
    ]
    res.filter { |cell| !cell.nil? }
  end
end

