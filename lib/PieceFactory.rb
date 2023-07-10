require './lib/PieceUtils'
require './lib/BishopPiece'
require './lib/KingPiece'
require './lib/KnightPiece'
require './lib/PawnPiece'
require './lib/QueenPiece'
require './lib/RookPiece'

class PieceFactory
  extend PieceUtils

  def self.create(piece_type, piece_options = {})
    return unless is_valid_piece_type?(piece_type)
    return BishopPiece.new(piece_options) if piece_type == :bishop
    return KingPiece.new(piece_options) if piece_type == :king
    return KnightPiece.new(piece_options) if piece_type == :knight
    return PawnPiece.new(piece_options) if piece_type == :pawn
    return QueenPiece.new(piece_options) if piece_type == :queen
    return RookPiece.new(piece_options) if piece_type == :rook
  end
end
