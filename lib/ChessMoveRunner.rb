require './lib/PieceUtils'
require 'set'

=begin
This class takes a chess move in Long Algebraic Notation (Long AN or LAN) and does the following with it:
- Checks if the move is valid LAN syntax or not
- Checks if the move is legal based on:
  - The current board state
  - Whose player's (white or black) turn it currently is
  - The move played in the previous turn(s) e.g. for checking if the player can do an en-passant capture.
- Executes the move and modifies the game state (assuming the move is valid LAN syntax and legal to play).

The modified or custom version of LAN uses the following templates:
- move (with dash): `{piece_char}{src_coord}-{dst_coord}`
- move (no dash): `{piece_char}{src_coord}{dst_coord}`
- capture (includes en-passant captures):
  - `{piece_char}{src_coord}x{dst_coord}`
- promotion via move (w/ dash):
  - `{src_coord}-{dst_coord}={promo_char}`
- promotion via move (no dash):
  - `{src_coord}{dst_coord}={promo_char}`
- promotion via capture: `{src_coord}x{dst_coord}={promo_char}`
- queenside castle: `0-0-0` or `O-O-O`
- kingside castle: `0-0` or `O-O`

Legend for the above LAN templates:
- `piece_char`: a char from  `{ '', 'R', 'N', 'B', 'Q', 'K' }`
- `coord`: a 2-char string with the following constraints
  - `coord[0]`: file letter from `{ a, b, c, d, e, f, g, h }`
  - `coord[1]`: rank integer from `{ 1, 2, 3, 4, 5, 6, 7, 8 }`
- `src_coord`: see `coord`
- `dst_coord`: see `coord`
- `promo_char`: a char from `{ R, N, B, Q }`
=end

class ChessMoveRunner
  extend PieceUtils

  ALPHA_FILE_TO_INT_COL = {
    "a" => 0,
    "b" => 1,
    "c" => 2,
    "d" => 3,
    "e" => 4,
    "f" => 5,
    "g" => 6,
    "h" => 7
  }
  PIECE_CHAR_TO_SYMBOL = {
    "" => :pawn,
    "R" => :rook,
    "N" => :knight,
    "B" => :bishop,
    "Q" => :queen,
    "K" => :king
  }
  COORDS_REGEX = /[a-h][1-8]/
  PIECE_CHAR_REGEX = /(R|N|B|Q|K)/

  attr_accessor(:game)

  def initialize(game)
    @game = game
  end

  # TODO - to test
  def is_valid_chess_move?
    # TODO
  end

  # TODO - to test
  def execute_chess_move!
    # TODO
  end

  def is_valid_piece_char_syntax?(syntax)
    return false if syntax.class != String
    syntax == "" || syntax.match?(/^(R|N|B|Q|K)$/)
  end

  def is_valid_coords_syntax?(syntax)
    return false if syntax.class != String
    syntax.match?(/^[a-h][1-8]$/)
  end

  def is_valid_move_syntax?(syntax)
    return false if syntax.class != String
    syntax.match?(/^(R|N|B|Q|K)?[a-h][1-8]-?[a-h][1-8]$/)
  end

  def is_valid_capture_syntax?(syntax)
    return false if syntax.class != String
    syntax.match?(/^(R|N|B|Q|K)?[a-h][1-8]x[a-h][1-8]$/)
  end

  def is_valid_promotion_syntax?(syntax)
    return false if syntax.class != String
    syntax.match?(/^[a-h](7(-|x)?[a-h]8|2(-|x)?[a-h]1)=(R|N|B|Q)$/)
  end

  def is_valid_queenside_castle_syntax?(syntax)
    return false if syntax.class != String
    syntax.match?(/^((0-0-0)|(O-O-O))$/)
  end

  def is_valid_kingside_castle_syntax?(syntax)
    return false if syntax.class != String
    syntax.match?(/^((0-0)|(O-O))$/)
  end

  def is_valid_syntax?(syntax)
    return false if syntax.class != String
    return true if is_valid_move_syntax?(syntax)
    return true if is_valid_capture_syntax?(syntax)
    return true if is_valid_promotion_syntax?(syntax)
    return true if is_valid_queenside_castle_syntax?(syntax)
    return true if is_valid_kingside_castle_syntax?(syntax)
    false
  end

  def coords_to_matrix_cell(coords)
    file, rank = coords.split("")
    [8 - rank.to_i, ALPHA_FILE_TO_INT_COL[file]]
  end

  def piece_char_to_type(char)
    PIECE_CHAR_TO_SYMBOL[char]
  end

  def is_matching_piece?(args)
    return false if args.class != Hash

    board = args.fetch(:board, @game.board)
    piece_type = args.fetch(:piece_type, nil)
    piece_color = args.fetch(:piece_color, nil)
    cell = args.fetch(:cell, nil)
    return false if piece_type.nil? or piece_color.nil? or cell.nil?

    row, col = cell
    real_piece = board[row][col]
    return false if real_piece.nil?
    return false if real_piece.color != piece_color
    return false if real_piece.type != piece_type

    true
  end

  def turn_color
    return @game.current_player_color if @game
    :white
  end

  # assumes syntax is valid
  def move_syntax_to_hash(syntax, src_piece_color = turn_color)
    src_coords = COORDS_REGEX.match(syntax)[0]
    dst_coords = COORDS_REGEX.match(syntax, 2)[0]
    src_piece_char = PIECE_CHAR_REGEX.match(syntax)
    src_piece_char = src_piece_char ? src_piece_char[0] : ''
    res = {
      src_piece_type: piece_char_to_type(src_piece_char),
      src_piece_color: src_piece_color,
      src_cell: coords_to_matrix_cell(src_coords),
      dst_cell: coords_to_matrix_cell(dst_coords),
    }
  end

  # is an alias for `ChessMoveRunner#move_syntax_to_hash`
  def capture_syntax_to_hash(syntax, src_piece_color = turn_color)
    move_syntax_to_hash(syntax, src_piece_color)
  end

  # assumes syntax is valid
  def promotion_syntax_to_hash(syntax, src_piece_color = turn_color)
    src_coords = COORDS_REGEX.match(syntax)[0]
    dst_coords = COORDS_REGEX.match(syntax, 2)[0]
    src_piece_char = PIECE_CHAR_REGEX.match(syntax[0...1])
    src_piece_char = src_piece_char ? src_piece_char[0] : ''
    promo_piece_char = PIECE_CHAR_REGEX.match(syntax, 5)[0]
    res = {
      src_piece_type: piece_char_to_type(src_piece_char),
      src_piece_color: src_piece_color,
      src_cell: coords_to_matrix_cell(src_coords),
      dst_cell: coords_to_matrix_cell(dst_coords),
      promo_piece_type: piece_char_to_type(promo_piece_char)
    }
  end

  def can_move?(syntax, src_piece_color = turn_color)
    return false unless is_valid_move_syntax?(syntax)
    return false unless @game

    data = move_syntax_to_hash(syntax, src_piece_color)
    data => {
      src_piece_type:, src_piece_color:, src_cell:, dst_cell:
    }
    return false unless self.class.is_empty_cell?(dst_cell, @game.board)

    args = {
      piece_type: src_piece_type,
      piece_color: src_piece_color,
      cell: src_cell
    }
    return false unless is_matching_piece?(args)

    src_row, src_col = src_cell
    filters = { row: src_row, col: src_col }
    piece = self.class.pieces(@game.board, filters)[0]
    piece[:piece].moves(src_cell, @game.board).include?(dst_cell)
  end

  def move!(syntax, src_piece_color = turn_color)
    return unless can_move?(syntax, src_piece_color)

    data = move_syntax_to_hash(syntax, src_piece_color)
    data => {
      src_piece_type:, src_piece_color:, src_cell:, dst_cell:
    }
    src_row, src_col = src_cell
    filters = { row: src_row, col: src_col }
    piece = self.class.pieces(@game.board, filters)[0]

    # update boolean flags on the piece as needed

    # Note that for the pawn piece which is the only piece with the
    # `@did_double_step` instance property, this flag must be checked and
    # possibly modified BEFORE checking and possibly modifying the pawn's
    # `@did_move`instance property due to how the
    # `PawnPiece#is_double_step?` method works; If the pawn piece moved
    # already, then it can no longer double step (forward). This means
    # that even if the pawn did not move yet and double stepped in this
    # (chess) move / turn, its `@did_double_step` instance boolean
    # variable will NOT be correctly set to `true` but instead remain as
    # `false`.
    if piece[:piece].respond_to?(:did_double_step?)
      args = [src_cell, dst_cell, @game.board]
      is_double_step = piece[:piece].is_double_step?(*args)
      piece[:piece].double_stepped! if is_double_step
    end

    if piece[:piece].respond_to?(:did_move?)
      piece[:piece].moved!
    end

    # modify the board state
    args = {
      piece_obj: piece[:piece],
      src_cell: src_cell,
      dst_cell: dst_cell,
      board: @game.board
    }
    @game.board = self.class.move(args)
  end

  # TODO - to test
  def can_capture?(syntax, src_piece_color = turn_color)
    return false unless is_valid_capture_syntax?(syntax)
    return false unless @game

    data = capture_syntax_to_hash(syntax, src_piece_color)
    data => {
      src_piece_type:, src_piece_color:, src_cell:, dst_cell:
    }

    if src_piece_type != :pawn
      return false if self.class.is_empty_cell?(dst_cell, @game.board)

      dst_row, dst_col = dst_cell
      filters = { row: dst_row, col: dst_col }
      res = self.class.pieces(@game.board, filter)
      return false if res.size == 0

      capturee_piece = res[0]
      enemy_color = src_piece_color == :white ? :black : :white
      return false if capturee_piece[:piece].color != enemy_color
      return false unless capturee_piece[:piece].is_capturable?
    else
      # TODO - check for possible en-passant capture if the capturer
      # piece is a pawn
    end

    args = {
      piece_type: src_piece_type,
      piece_color: src_piece_color,
      cell: src_cell
    }
    return false unless is_matching_piece?(args)

    src_row, src_col = src_cell
    filters = { row: src_row, col: src_col }
    capturer_piece = self.class.pieces(@game.board, filters)[0]
    capturer_piece[:piece].captures(src_cell, @game.board).include?(dst_cell)
  end

  # TODO - to test
  def capture!(syntax, src_piece_color = turn_color)
    return unless can_capture?(syntax, src_piece_color)

    data = capture_syntax_to_hash(syntax, src_piece_color)
    data => {
      src_piece_type:, src_piece_color:, src_cell:, dst_cell:
    }
    src_row, src_col = src_cell
    filters = { row: src_row, col: src_col }
    capturer_piece = self.class.pieces(@game.board, filters)[0]

    # update boolean flags on the piece as needed
    if capturer_piece[:piece].respond_to?(:did_move?)
      capturer_piece[:piece].moved!
    end

    # TODO - If the capturer piece is a pawn and the capture is an
    # en-passant capture - `dst_cell` is empty but its adjacent top cell
    # (if capturer is a black pawn) or its adjacent bottom cell (if
    # capturer is a white pawn) is the to-be-captured enemy pawn -
    # set the enemy capturee pawn's cell to null in the new board.

    # modify the board state
    args = {
      piece_obj: capturer_piece[:piece],
      src_cell: src_cell,
      dst_cell: dst_cell,
      board: @game.board,
      en_passant_cap_cell: nil # TODO
    }
    @game.board = self.class.capture(args)
  end

  # TODO - to test
  def must_promote?(syntax, src_piece_color = turn_color)
    return false unless is_valid_promotion_syntax?(syntax)
    return false unless @game

    data = promotion_syntax_to_hash(syntax, src_piece_color)
    data => {
      src_piece_type:, src_piece_color:,
      src_cell:, dst_cell:, promo_piece_type:
    }
    # TODO
    # move_regex = /^[a-h][1-8]-?[a-h][1-8].+$/
    # capture_regex = /^[a-h][1-8]x[a-h][1-8].+$/

    # return false unless self.class.is_empty_cell?(dst_cell, @game.board)

    # args = {
    #   piece_type: src_piece_type,
    #   piece_color: src_piece_color,
    #   cell: src_cell
    # }
    # return false unless is_matching_piece?(args)

    # src_row, src_col = src_cell
    # filters = { row: src_row, col: src_col }
    # piece = self.class.pieces(@game.board, filters)[0]
    # piece[:piece].moves(src_cell, @game.board).include?(dst_cell)
  end

  # TODO - to test
  def promote!
    # TODO
  end

  # TODO - to test
  def can_castle?
    # TODO
  end

  # TODO - to test
  def castle!
    # TODO
  end

  # TODO - to test
  def can_queenside_castle?
    # TODO
  end

  # TODO - to test
  def queenside_castle!
    # TODO
  end

  # TODO - to test
  def can_kingside_castle?
    # TODO
  end

  # TODO - to test
  def kingside_castle!
    # TODO
  end

  # TODO - to test
  def can_capture_en_passant?
    # TODO
  end

  # TODO - to test
  def capture_en_passant!
    # TODO
  end
end
