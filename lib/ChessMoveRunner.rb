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
    syntax.match?(/^[a-h][1-8](-|x)?[a-h](8|1)=(R|N|B|Q)$/)
  end

  def is_valid_queenside_castle_syntax?(syntax)
    return false if syntax.class != String
    syntax.match?(/^(0-0-0)|(O-O-O)$/)
  end

  def is_valid_kingside_castle_syntax?(syntax)
    return false if syntax.class != String
    syntax.match?(/^(0-0)|(O-O)$/)
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

  # TODO - to test
  def is_matching_src_piece?(args)
    board = args.fetch(:board, @game.board)
    src_piece = args.fetch(:src_piece, nil)
    src_cell = args.fetch(:src_cell, nil)

    return false if src_piece.nil? or src_cell.nil?

    src_row, src_col = src_cell
    real_piece = board[src_row][src_col]
    return false if real_piece.nil?
    return false if real_piece.color != src_piece.color
    return false if real_piece.type != src_piece.type
    return false if real_piece.is_capturable? != src_piece.is_capturable?
    if real_piece.respond_to?(:did_move?)
      return false unless src_piece.respond_to?(:did_move?)
      return false if real_piece.did_move? != src_piece.did_move?
    end
    if real_piece.respond_to?(:did_double_step?)
      return false unless src_piece.respond_to?(:did_double_step?)
      return false if real_piece.did_double_step? != src_piece.did_double_step?
    end
    true
  end

  # TODO - to test
  def can_move?
    # TODO
  end

  # TODO - to test
  def move!
    # TODO
  end

  # TODO - to test
  def can_capture?
    # TODO
  end

  # TODO - to test
  def capture!
    # TODO
  end

  # TODO - to test
  def must_promote?
    # TODO
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
