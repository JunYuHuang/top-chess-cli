require './lib/PieceUtils'

class ConsoleUI
  attr_accessor(:game)

  # TODO - to test
  def initialize(game)
    @game = game
  end

  def clear_UI
    is_windows_os = RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
    is_windows_os ? system('cls') : system('clear')
  end

  # TODO - to test
  def print_board
    # TODO
  end

  # TODO - to test
  def print_captured_pieces
    # TODO
  end

  # TODO - to test
  def print_turn_prompt
    # TODO
  end

  # TODO - to test
  def print_game_end
    # TODO
  end

  # TODO - to test
  def print_saves_table
    # TODO
  end

  # TODO - to test
  def print_load_prompt
    # TODO
  end

  # TODO - to test
  def print_load_screen
    # TODO
  end

  # TODO - to test
  def print_setup_screen
    # TODO
  end

  # TODO - to test
  def print_turn_screen
    # TODO
  end

  # TODO - to test
  def print_end_screen
    # TODO
  end
end
