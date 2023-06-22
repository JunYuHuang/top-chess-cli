require './lib/Piece'
require './lib/PieceActionUtils'

class RookPiece < Piece
  extend PieceActionUtils

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
  def moves(start_cell, board)
    #
  end

  # TODO - to test
  def captures(start_cell, board)
    #
  end

  # TODO - to test
  def moved!
    return if @did_move
    @did_move = true
  end

  # TODO - to test
  def did_move?
    @did_move
  end
end

