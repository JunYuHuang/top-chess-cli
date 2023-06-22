require './lib/Piece'
require './lib/PieceUtils'

class RookPiece < Piece
  extend PieceUtils

  attr_accessor(:default_options, :did_move)

  @@default_options = {
    color: :white,
    did_move: false
  }

  # TODO - to test
  def initialize(options = @@default_options)
    options => {
      color:,
      did_move:
    }
    passed_options = {
      color: color ? color : :white,
      type: :rook,
      is_interactive: true,
      is_capturable: true
    }
    super(passed_options)
    @did_move = did_move ? did_move : false
  end

  # TODO - to test
  def moves(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    res = [
      *up_moves(src_cell, board, options),
      *down_moves(src_cell, board, options),
      *left_moves(src_cell, board, options),
      *right_moves(src_cell, board, options)
    ]
  end

  # TODO - to test
  def captures(src_cell, board)
    res = [
      up_capture(src_cell, board),
      down_capture(src_cell, board),
      left_capture(src_cell, board),
      right_capture(src_cell, board)
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

