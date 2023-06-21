class Piece
  attr_accessor(:default_options, :color, :type, :is_interactive)

  @@default_options = {
    color: nil,
    type: nil,
    is_interactive: false
  }

  # TODO - to test
  def initialize(options = @@default_options)
    options => {
      color:,
      type:,
      is_interactive:
    }
    @color = color ? color : nil
    @type = type ? type : nil
    @is_interactive = is_interactive ? is_interactive : false
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
end
