require './lib/Piece'
require './lib/PieceUtils'

class KnightPiece < Piece
  extend PieceUtils

  attr_accessor(:default_options)

  @@default_options = {
    color: :white,
  }

  def initialize(options = @@default_options)
    passed_options = {
      color: options.fetch(:color, @@default_options[:color]),
      type: :knight,
      is_capturable: true
    }
    super(passed_options)
  end

  def moves(src_cell, board)
    self.class.l_shaped_moves(src_cell, board)
  end

  def captures(src_cell, board)
    self.class.l_shaped_captures(src_cell, board)
  end

  def move(src_cell, dst_cell, board)
    args = {
      src_cell: src_cell, dst_cell: dst_cell,
      board: board, piece_obj: self
    }
    self.class.move(args)
  end

  def capture(src_cell, dst_cell, board)
    args = {
      src_cell: src_cell, dst_cell: dst_cell,
      board: board, piece_obj: self
    }
    self.class.capture(args)
  end
end

