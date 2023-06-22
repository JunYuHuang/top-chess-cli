class Piece
  attr_accessor(:default_options, :color, :type, :is_interactive, :is_capturable)

  @@default_options = {
    color: nil,
    type: nil,
    is_interactive: false,
    is_capturable: false
  }

  # TODO - to test
  def initialize(options = @@default_options)
    @color = options.fetch(:color, @@default_options[:color])
    @type = options.fetch(:type, @@default_options[:type])
    @is_interactive = options.fetch(:is_interactive, @@default_options[:is_interactive])
    @is_capturable = options.fetch(:is_capturable, @@default_options[:is_capturable])
  end

  # TODO - to test
  def color
    @color
  end

  # TODO - to test
  def type
    @type
  end

  # TODO - to test
  def is_interactive?
    @is_interactive
  end

  # TODO - to test
  def is_capturable?
    @is_capturable
  end
end
