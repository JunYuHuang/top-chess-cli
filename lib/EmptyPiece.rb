require './lib/Piece'

class EmptyPiece < Piece
  # TODO - to test
  def self.type
    :empty
  end

  # TODO - to test
  def self.is_interactive?
    false
  end

  # TODO - to test
  def self.is_capturable?
    false
  end
end

