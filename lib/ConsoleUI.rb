require 'set'

class ConsoleUI
  COLOR_TO_STR = { white: "w", black: "b" }
  PIECE_TO_STR = {
    pawn: "P", rook: "R", knight: "K", bishop: "B", queen: "Q", king: "K"
  }
  LIGHT_SQUARE = "    "
  DARK_SQUARE = "░░░░"
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

  # TODO - to test
  def print_turn_prompt
    return unless @game
  end

  # TODO - to test
  def print_game_end
    return unless @game
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

  # TODO - to test
  def print_turn_screen
    return unless @game
  end

  # TODO - to test
  def print_end_screen
    return unless @game
  end

  protected

  def row_to_rank(row)
    return -1 if @game.nil? or !@game.class.is_valid_row?(row)
    @game.rows - row
  end

  def empty_cell_str(row, col)
    return unless @game

    is_even = ->(n) { n % 2 == 0 }
    is_odd = ->(n) { n % 2 != 0 }
    return LIGHT_SQUARE if is_even.call(row) && is_even.call(col)
    return DARK_SQUARE if is_even.call(row) && is_odd.call(col)
    return DARK_SQUARE if is_odd.call(row) && is_even.call(col)
    return LIGHT_SQUARE if is_odd.call(row) && is_odd.call(col)
  end

  def piece_cell_str(row, col)
    return unless @game

    piece_obj = @game.board[row][col]
    res = [
      " ",
      COLOR_TO_STR[piece_obj.color],
      PIECE_TO_STR[piece_obj.type],
      " "
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
