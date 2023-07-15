require './lib/Player'

=begin
`MockPiece` is meant to be used as a mock or test double in the testing or spec files only and not in or as part of a real chess game. It is a carbon copy of the `Player` class.
=end

class MockPlayer < Player
  attr_accessor(:game, :name, :piece_color)

  def initialize(game, name, piece_color)
    @game = game
    @name = name
    @piece_color = piece_color
  end

  def game
    @game
  end

  def piece_color
    @piece_color
  end

  def name
    @name
  end
end
