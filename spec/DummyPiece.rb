require './lib/Piece'

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
