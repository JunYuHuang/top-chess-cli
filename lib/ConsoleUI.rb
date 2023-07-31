require 'set'

class ConsoleUI
  COLOR_TO_STR = { white: "w", black: "b" }
  PIECE_TO_STR = {
    pawn: "P", rook: "R", knight: "N", bishop: "B", queen: "Q", king: "K"
  }
  LIGHT_SQUARE = "    "
  DARK_SQUARE = "░░░░"
  DARK_SQUARE_CHAR = "░"
  FILE_LABELS = "    a    b    c    d    e    f    g    h"
  BORDER_VERTICAL_SIDE = "║"
  FILE_DIVIDER = "│"
  BORDER_TOP = "  ╔════╤════╤════╤════╤════╤════╤════╤════╗"
  RANK_DIVIDER = "  ╟────┼────┼────┼────┼────┼────┼────┼────╢"
  BORDER_BOTTOM = "  ╚════╧════╧════╧════╧════╧════╧════╧════╝"

  attr_accessor(:game)

  def initialize(game)
    @game = game
  end

  def clear_UI
    is_windows_os = RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
    is_windows_os ? system('cls') : system('clear')
  end

  def print_board
    return unless @game

    res = [FILE_LABELS, "\n", BORDER_TOP, "\n"]

    is_last_row =->(row) { row == @game.rows - 1}

    @game.rows.times do |row|
      res.push(rank_str(row), "\n")
      res.push(RANK_DIVIDER, "\n") unless is_last_row.call(row)
    end

    res.push(BORDER_BOTTOM, "\n", FILE_LABELS, "\n", "\n")
    puts(res.join(''))
  end

  def print_captured_pieces
    return unless @game

    black_captures = ["BLACK's captures: "]
    white_pieces = []
    w_pawns = captured_piece_str(:black, :pawn)
    white_pieces.push(w_pawns) if w_pawns.size > 0
    w_bishops = captured_piece_str(:black, :bishop)
    white_pieces.push(w_bishops) if w_bishops.size > 0
    w_knights = captured_piece_str(:black, :knight)
    white_pieces.push(w_knights) if w_knights.size > 0
    w_rooks = captured_piece_str(:black, :rook)
    white_pieces.push(w_rooks) if w_rooks.size > 0
    w_queens = captured_piece_str(:black, :queen)
    white_pieces.push(w_queens) if w_queens.size > 0
    black_captures.push(white_pieces.join(', '))

    white_captures = ["WHITE's captures: "]
    black_pieces = []
    b_pawns = captured_piece_str(:white, :pawn)
    black_pieces.push(b_pawns) if b_pawns.size > 0
    b_bishops = captured_piece_str(:white, :bishop)
    black_pieces.push(b_bishops) if b_bishops.size > 0
    b_knights = captured_piece_str(:white, :knight)
    black_pieces.push(b_knights) if b_knights.size > 0
    b_rooks = captured_piece_str(:white, :rook)
    black_pieces.push(b_rooks) if b_rooks.size > 0
    b_queens = captured_piece_str(:white, :queen)
    black_pieces.push(b_queens) if b_queens.size > 0
    white_captures.push(black_pieces.join(', '))

    res = [
      black_captures.join(''), "\n",
      white_captures.join(''), "\n", "\n"
    ]
    puts(res.join(''))
  end

  def print_turn_prompt(is_valid_input, last_input = "")
    return unless @game
    return if @game.players.size != @game.players_count

    player = @game.player(@game.turn_color)
    king = @game.class.pieces(@game.board, {
      color: @game.turn_color, type: :king
    })[0]
    is_king_checked = king[:piece].is_checked?(king[:cell], @game.board)
    king_checked_msg = "❕Move your king out of check to another square."
    invalid_input_msg = "❌ '#{last_input}' is an illegal move or invalid command. Try again."

    res = [
      # TODO: game save load / start message at start of game
      "It is #{player.to_s}'s turn.\n",
      "#{ is_king_checked ? king_checked_msg : "" }\n",
      "Enter your move in Long Algebraic Notation (e.g. 'e2e3'\n",
      "to move your pawn from 'e2' to 'e3' as WHITE):\n",
      # "or 'save!' to save the game:\n",
      "#{ is_valid_input ? "" : invalid_input_msg }\n",
    ]
    puts(res.join(''))
  end

  def print_game_end(winner_color = nil)
    return unless @game

    # handle stalemates and ties
    unless winner_color
      white_king = @game.class.pieces(@game.board, {
        color: :white, type: :king
      })[0]
      is_white_stalemated = white_king[:piece].is_stalemated?(
        white_king[:cell], @game.board
      )
      black_king = @game.class.pieces(@game.board, {
        color: :black, type: :king
      })[0]
      is_black_stalemated = black_king[:piece].is_stalemated?(
        black_king[:cell], @game.board
      )
      is_stalemate = is_white_stalemated || is_black_stalemated
      stalemated_player = is_white_stalemated ?
        @game.player(:white) : @game.player(:black)
      stalemate_msg = "#{stalemated_player.to_s} is stalemated.\n"

      res = [
        "#{ is_stalemate ? stalemate_msg : "" }",
        "Game ended: ½-½ The game is a draw!\n"
      ]
      puts(res.join(''))
      return
    end

    # handle wins
    winner_player = @game.player(winner_color)
    loser_color = winner_color == :white ? :black : :white
    loser_player = @game.player(loser_color)
    game_res = winner_color == :white ? "1-0" : "0-1"
    res = [
      "#{winner_player.to_s} has checkmated #{loser_player.to_s}.\n",
      "Game ended: #{game_res} #{winner_player.to_s} won!"
    ]
    puts(res.join(''))
  end

  # TODO - to test
  def print_saves_table
    return unless @game
  end

  # TODO - to test
  def print_load_prompt
    return unless @game
  end

  # TODO - to test
  def print_load_screen
    return unless @game
  end

  # TODO - to test
  def print_setup_screen
    return unless @game
  end

  def print_turn_screen(is_valid_input, last_input = "")
    return unless @game

    clear_UI
    print_board
    print_captured_pieces
    print_turn_prompt(is_valid_input, last_input)
  end

  def print_end_screen(winner_color = nil)
    return unless @game

    clear_UI
    print_board
    print_captured_pieces
    print_game_end(winner_color)
  end

  protected

  def row_to_rank(row)
    return -1 if @game.nil? or !@game.class.is_valid_row?(row)
    @game.rows - row
  end

  def is_dark_cell?(row, col)
    is_even = ->(n) { n % 2 == 0 }
    is_odd = ->(n) { n % 2 != 0 }
    return true if is_even.call(row) && is_odd.call(col)
    return true if is_odd.call(row) && is_even.call(col)
    false
  end

  def empty_cell_str(row, col)
    return unless @game
    is_dark_cell?(row, col) ? DARK_SQUARE : LIGHT_SQUARE
  end

  def piece_cell_str(row, col)
    return unless @game

    piece_obj = @game.board[row][col]
    res = [
      "#{ is_dark_cell?(row, col) ? DARK_SQUARE_CHAR : " "}",
      COLOR_TO_STR[piece_obj.color],
      PIECE_TO_STR[piece_obj.type],
      "#{ is_dark_cell?(row, col) ? DARK_SQUARE_CHAR : " "}",
    ]
    res.join('')
  end

  # Includes the rank labels and left and right enclosing borders
  # of the chess board. Excludes the file labels, the top or bottom
  # enclosing borders of the chess board, and the in-between rank
  # divider.
  def rank_str(row)
    return unless @game

    rank = row_to_rank(row).to_s
    res = [rank, " ", BORDER_VERTICAL_SIDE]

    is_empty_cell = ->(row, col) { @game.board[row][col].nil? }
    is_last_col = ->(col) { col == @game.cols - 1 }

    @game.cols.times do |col|
      cell_obj = @game.board[row][col]
      cell = is_empty_cell.call(row, col) ?
        empty_cell_str(row, col) :
        piece_cell_str(row, col)
      res.push(cell)
      res.push(FILE_DIVIDER) unless is_last_col.call(col)
    end

    res.push(BORDER_VERTICAL_SIDE, " ", rank)
    res.join('')
  end

  def captured_piece_str(capturer_color, captive_type)
    count = capturer_color == :white ?
      @game.white_captured.fetch(captive_type, 0) :
      @game.black_captured.fetch(captive_type, 0)
    return "" if count < 1
    res = [
      COLOR_TO_STR[capturer_color],
      PIECE_TO_STR[captive_type],
      " x ",
      count.to_s
    ]
    res.join('')
  end
end
