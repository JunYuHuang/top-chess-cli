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

  def can_chess_move?(syntax, src_piece_color = turn_color)
    return true if can_move?(syntax, src_piece_color)
    return true if can_capture_en_passant?(syntax, src_piece_color)
    return true if can_capture?(syntax, src_piece_color)
    return true if can_promote?(syntax, src_piece_color)
    return true if can_queenside_castle?(syntax, src_piece_color)
    return true if can_kingside_castle?(syntax, src_piece_color)
    false
  end

  def execute_chess_move!(syntax, src_piece_color = turn_color)
    if can_move?(syntax, src_piece_color)
      move!(syntax, src_piece_color)
    elsif can_capture_en_passant?(syntax, src_piece_color)
      capture_en_passant!(syntax, src_piece_color)
    elsif can_capture?(syntax, src_piece_color)
      capture!(syntax, src_piece_color)
    elsif can_promote?(syntax, src_piece_color)
      promote!(syntax, src_piece_color)
    elsif can_queenside_castle?(syntax, src_piece_color)
      can_queenside_castle!(syntax, src_piece_color)
    elsif can_kingside_castle?(syntax, src_piece_color)
      kingside_castle!(syntax, src_piece_color)
    end
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

  def is_valid_capture_en_passant_syntax?(syntax)
    return false if syntax.class != String
    syntax.match?(/^[a-h](4x[a-h]3|5x[a-h]6)(\se\.p\.)?$/)
  end

  def is_valid_promote_syntax?(syntax)
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
    return true if is_valid_promote_syntax?(syntax)
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
    return @game.turn_color if @game
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

  def capture_syntax_to_hash(syntax, src_piece_color = turn_color)
    move_syntax_to_hash(syntax, src_piece_color)
  end

  def capture_en_passant_syntax_to_hash(syntax, src_piece_color = turn_color)
    move_syntax_to_hash(syntax, src_piece_color)
  end

  # assumes syntax is valid
  def promote_syntax_to_hash(syntax, src_piece_color = turn_color)
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
    return false if should_promote?(src_cell)

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
    # `@is_capturable_en_passant` instance property, this flag must be
    # checked and possibly modified BEFORE checking and possibly
    # modifying the pawn's `@did_move`instance property due to how the
    # `PawnPiece#is_double_step_forward?` method works; If the pawn piece
    # moved already, then it can no longer double step (forward). This
    # means that even if the pawn did not move yet and double stepped in
    # this (chess) move / turn, its `@is_capturable_en_passant` instance
    # boolean variable will NOT be correctly set to `true` but instead
    # remain as `false`.
    if piece[:piece].respond_to?(:is_capturable_en_passant?)
      args = [src_cell, dst_cell, @game.board]
      is_double_step = piece[:piece].is_double_step_forward?(*args)
      piece[:piece].set_is_capturable_en_passant!(true) if is_double_step
    end

    if piece[:piece].respond_to?(:did_move?)
      piece[:piece].moved!
    end

    # modify the board state
    @game.board = piece[:piece].move(src_cell, dst_cell, @game.board)
  end

  # Note that this only handles normal, non-en-passant captures.
  # En-passant captures are checked in a separate method.
  def can_capture?(syntax, src_piece_color = turn_color)
    return false unless is_valid_capture_syntax?(syntax)
    return false unless @game

    data = capture_syntax_to_hash(syntax, src_piece_color)
    data => {
      src_piece_type:, src_piece_color:, src_cell:, dst_cell:
    }

    return false if self.class.is_empty_cell?(dst_cell, @game.board)

    dst_row, dst_col = dst_cell
    capturee_filters = { row: dst_row, col: dst_col }
    res = self.class.pieces(@game.board, capturee_filters)
    return false if res.size != 1

    args = {
      piece_type: src_piece_type,
      piece_color: src_piece_color,
      cell: src_cell
    }
    return false unless is_matching_piece?(args)
    return false if should_promote?(src_cell)

    capturee_piece = res[0]
    return false if self.class.is_ally_piece_cell?(src_cell, dst_cell, @game.board)
    return false unless capturee_piece[:piece].is_capturable?

    src_row, src_col = src_cell
    capturer_filters = { row: src_row, col: src_col }
    capturer_piece = self.class.pieces(@game.board, capturer_filters)[0]

    capturer_piece[:piece].captures(src_cell, @game.board).include?(dst_cell)
  end

  # Note that this only handles normal, non-en-passant captures.
  # En-passant captures are execute in a separate method.
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

    # modify the board state
    @game.board = capturer_piece[:piece].capture(
      src_cell, dst_cell, @game.board
    )
  end

  def should_promote?(src_cell)
    return false unless @game
    return false unless self.class.is_inbound_cell?(src_cell)

    src_row, src_col = src_cell
    filter = { row: src_row, col: src_col }
    pieces = self.class.pieces(@game.board, filter)
    return false if pieces.size != 1

    pawn = pieces[0]
    return false if pawn[:piece].type != :pawn
    pawn[:piece].is_promotable?(src_cell, @game.board)
  end

  def can_promote?(syntax, src_piece_color = turn_color)
    return false unless is_valid_promote_syntax?(syntax)
    return false unless @game

    data = promote_syntax_to_hash(syntax, src_piece_color)
    data => {
      src_piece_type:, src_piece_color:,
      src_cell:, dst_cell:, promo_piece_type:
    }
    args = {
      piece_type: src_piece_type,
      piece_color: src_piece_color,
      cell: src_cell
    }
    return false unless is_matching_piece?(args)
    return false unless should_promote?(src_cell)

    src_row, src_col = src_cell
    filters = { row: src_row, col: src_col }
    pawn = self.class.pieces(@game.board, filters)[0]
    pawn_moves = pawn[:piece].moves(src_cell, @game.board)
    pawn_captures= pawn[:piece].captures(src_cell, @game.board)
    is_capture_promotion = syntax.include?('x')
    is_capture_promotion ?
      pawn_captures.include?(dst_cell) :
      pawn_moves.include?(dst_cell)
  end

  def promote!(syntax, src_piece_color = turn_color)
    return unless can_promote?(syntax, src_piece_color)

    data = promote_syntax_to_hash(syntax, src_piece_color)
    data => {
      src_piece_type:, src_piece_color:,
      src_cell:, dst_cell:, promo_piece_type:
    }
    src_row, src_col = src_cell
    new_board = self.class.deep_copy(@game.board)
    new_board[src_row][src_col] = nil

    factory = @game.piece_factory
    options = { color: src_piece_color }
    dst_row, dst_col = dst_cell
    new_board[dst_row][dst_col] = factory.create(
      promo_piece_type, options
    )

    @game.board = new_board
  end

  def can_queenside_castle?(syntax, src_piece_color = turn_color)
    return false unless is_valid_queenside_castle_syntax?(syntax)
    return false unless @game

    king_filter = { color: src_piece_color, type: :king }
    res = self.class.pieces(@game.board, king_filter)
    return false if res.size != 1

    king = res[0]
    king[:piece].can_queenside_castle?(king[:cell], @game.board)
  end

  def queenside_castle!(syntax, src_piece_color = turn_color)
    return unless can_queenside_castle?(syntax, src_piece_color)

    # update boolean flags on the king and rook pieces
    king_filter = { color: src_piece_color, type: :king }
    king = self.class.pieces(@game.board, king_filter)[0]
    king[:piece].moved!

    rook_filter = { color: src_piece_color, type: :rook, col: 0 }
    rook = self.class.pieces(@game.board, rook_filter)[0]
    rook[:piece].moved!

    # create the new board state and update it on the game object
    board_with_castled_king = king[:piece].queenside_castle(king[:cell], @game.board)
    castled_board = rook[:piece].queenside_castle(rook[:cell], board_with_castled_king)
    @game.board = castled_board
  end

  def can_kingside_castle?(syntax, src_piece_color = turn_color)
    return false unless is_valid_kingside_castle_syntax?(syntax)
    return false unless @game

    king_filter = { color: src_piece_color, type: :king }
    res = self.class.pieces(@game.board, king_filter)
    return false if res.size != 1

    king = res[0]
    king[:piece].can_kingside_castle?(king[:cell], @game.board)
  end

  def kingside_castle!(syntax, src_piece_color = turn_color)
    return unless can_kingside_castle?(syntax, src_piece_color)

    # update boolean flags on the king and rook pieces
    king_filter = { color: src_piece_color, type: :king }
    king = self.class.pieces(@game.board, king_filter)[0]
    king[:piece].moved!

    rook_filter = { color: src_piece_color, type: :rook, col: 7 }
    rook = self.class.pieces(@game.board, rook_filter)[0]
    rook[:piece].moved!

    # create the new board state and update it on the game object
    board_with_castled_king = king[:piece].kingside_castle(king[:cell], @game.board)
    castled_board = rook[:piece].kingside_castle(rook[:cell], board_with_castled_king)
    @game.board = castled_board
  end

  def can_capture_en_passant?(syntax, src_piece_color = turn_color)
    return false unless is_valid_capture_en_passant_syntax?(syntax)
    return false unless @game

    data = capture_en_passant_syntax_to_hash(syntax, src_piece_color)
    data => { src_piece_color:, src_cell:, dst_cell: }

    args = {
      piece_type: :pawn,
      piece_color: src_piece_color,
      cell: src_cell
    }
    return false unless is_matching_piece?(args)

    src_row, src_col = src_cell
    capturer_filters = { row: src_row, col: src_col }
    capturer_pawn = self.class.pieces(@game.board, capturer_filters)[0]
    capturer_pawn[:piece].captures_en_passant(src_cell, @game.board).include?(dst_cell)
  end

  def capture_en_passant!(syntax, src_piece_color = turn_color)
    return unless can_capture_en_passant?(syntax, src_piece_color)

    data = capture_en_passant_syntax_to_hash(syntax, src_piece_color)
    data => {
      src_piece_color:, src_cell:, dst_cell:
    }
    src_row, src_col = src_cell
    filters = { row: src_row, col: src_col }
    capturer_pawn = self.class.pieces(@game.board, filters)[0]

    # update boolean flags on the piece as needed
    if capturer_pawn[:piece].respond_to?(:did_move?)
      capturer_pawn[:piece].moved!
    end

    # modify the board state
    @game.board = capturer_pawn[:piece].capture_en_passant(
      src_cell, dst_cell, @game.board
    )
  end

  def is_move_pawn_double_step?(
    syntax, src_piece_color = turn_color, board = nil
  )
    board = @game ? @game.board : nil
    return false unless board
    return false unless is_valid_move_syntax?(syntax)

    data = move_syntax_to_hash(syntax, src_piece_color)
    data => {
      src_piece_type:, src_piece_color:, src_cell:, dst_cell:
    }
    args = {
      piece_type: :pawn,
      piece_color: src_piece_color,
      cell: src_cell
    }
    return false unless is_matching_piece?(args)

    src_row, src_col = src_cell
    filters = { row: src_row, col: src_col }
    pawn = self.class.pieces(board, filters)[0]
    return false unless pawn[:piece].moves(src_cell, board).include?(dst_cell)

    pawn[:piece].is_double_step_forward?(src_cell, dst_cell, board)
  end

  # Should be called after any chess move is played to uphold the
  # rules of en-passant eligibility.
  def set_enemy_pawns_non_capturable_en_passant!(enemy_color = nil)
    enemy_color = turn_color == :white ? :black : :white if !enemy_color

    # black pawns that double stepped will be in row index 3 (rank 5)
    # white pawns that double stepped will be in row index 4 (rank 4)
    row = enemy_color == :white ? 4 : 3
    enemy_pawns_filter = { color: enemy_color, type: :pawn, row: row }
    pawns = self.class.pieces(@game.board, enemy_pawns_filter)
    return if pawns.size == 0
    pawns.each do |pawn|
      pawn[:piece].set_is_capturable_en_passant!(false)
    end
  end
end
