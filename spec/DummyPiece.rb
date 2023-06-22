require './lib/Piece'

=begin
This `Piece` subclass is a wildcard Piece that can be any valid chess piece (e.g. PawnPiece) or a piece that represents an empty cell on the board (i.e. EmptyPiece).

`DummyPiece` is meant to be used as a mock or test double in the testing or spec files only and not in or as part of a real chess game.
=end

class DummyPiece < Piece
  attr_accessor(:default_options, :did_move)

  @@default_options = {
    color: :white,
    type: :dummy,
    is_interactive: true,
    is_capturable: true,
    did_move: false
  }

  def initialize(options = @@default_options)
    passed_options = {
      color: options.fetch(:color, @@default_options[:color]),
      type: options.fetch(:type, @@default_options[:type]),
      is_interactive: options.fetch(:is_interactive, @@default_options[:is_interactive]),
      is_capturable: options.fetch(:is_capturable, @@default_options[:is_capturable])
    }
    super(passed_options)
    @did_move = options.fetch(:did_move, @@default_options[:did_move])
  end

  def did_move?
    @did_move
  end
end
