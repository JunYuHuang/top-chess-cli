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
    options => {
      color:,
      type:,
      is_interactive:,
      is_capturable:
    }
    @color = color ? color : nil
    @type = type ? type : nil
    @is_interactive = is_interactive ? is_interactive : false
    @is_capturable = is_capturable ? is_capturable : false
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
