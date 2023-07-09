require './lib/PieceUtils'

class PieceFactory
  extend PieceUtils

  attr_accessor(:pieces_dict)

  def initialize(pieces_dict)
    # `@pieces_dict` is a hashmap that maps each symbol to its
    # respective piece class e.g. `:pawn` -> `PawnPiece` class
    @pieces_dict = pieces_dict
  end

  def spawn(piece_type, piece_options = {})
    return unless self.class.is_valid_piece_type?(piece_type)
    return unless @pieces_dict[piece_type].nil?
    res = @pieces_dict[piece_type].new(piece_options)
    res
  end
end
