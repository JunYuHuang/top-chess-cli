require './lib/Player'

class HumanPlayer < Player
  attr_accessor(:game, :name, :piece_color, :player_type)

  @@player_type = "Human"

  def initialize(game, name, piece_color)
    super(game, name, piece_color)
  end

  def to_s
    "#{@piece_color.to_s.upcase} (#{@name})"
  end

  # TODO - to test
  def get_turn_input
    return if @game.nil?
    # TODO
  end

  # TODO - to test
  def get_start_option
    # TODO
  end

  # TODO - to test
  def get_opponent_type
    # TODO
  end
end
