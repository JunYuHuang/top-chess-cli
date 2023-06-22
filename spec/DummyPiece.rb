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

  # TODO
  def initialize(options = @@default_options)
    options => {
      color:,
      type:,
      is_interactive:,
      is_capturable:,
      did_move:
    }
    passed_options = {
      color: color ? color : @@default_options[:color],
      type: type ? type : @@default_options[:type],
      is_interactive: is_interactive ? is_interactive : @@default_options[:is_interactive],
      is_capturable: is_capturable ? is_capturable : @@default_options[:is_capturable]
    }
    super(passed_options)
    @did_move = did_move ? did_move : @@default_options[:did_move]
  end

  # TODO - to test
  def did_move?
    @did_move
  end
end
