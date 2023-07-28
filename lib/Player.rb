class Player
  DEFAULTS = { game: nil, type: :none, name: nil, piece_color: nil }

  attr_accessor(:game, :type, :name, :piece_color)

  def initialize(args)
    @game = args.fetch(:game, DEFAULTS[:game])
    @type = args.fetch(:type, DEFAULTS[:type])
    @name = args.fetch(:name, DEFAULTS[:name])
    @piece_color = args.fetch(:piece_color, DEFAULTS[:piece_color])
  end

  def game
    @game
  end

  def type
    @type
  end

  def piece_color
    @piece_color
  end

  def name
    @name
  end
end
