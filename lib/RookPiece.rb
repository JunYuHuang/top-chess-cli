require './lib/Piece'

class RookPiece < Piece
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
      color: color ? color : nil,
      type: :rook
      is_interactive: true
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
  def moved!(is_moved = true)
    return if @did_move == is_moved
    @did_move = is_moved
  end

  # TODO -to test
  def did_move?
    @did_move
  end
end

