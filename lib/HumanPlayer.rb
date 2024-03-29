require './lib/Player'

class HumanPlayer < Player
  DEFAULTS = { name: nil, piece_color: :white }

  def initialize(args)
    passed_args = {
      game: args[:game],
      type: :human,
      name: args.fetch(:name, DEFAULTS[:name]),
      piece_color: args.fetch(:piece_color, DEFAULTS[:piece_color])
    }
    super(passed_args)
  end

  def input
    return unless @game

    is_valid_input = true
    last_input = nil
    loop do
      @game.console_ui.print_turn_screen(is_valid_input, last_input)
      player_input = gets.chomp

      if @game.can_input?(player_input)
        return player_input
      end

      is_valid_input = false
      last_input = player_input
    end
  end
end
