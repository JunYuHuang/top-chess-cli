class Player
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
