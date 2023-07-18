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

  attr_accessor(:board)

  # TODO - to test
  def initialize(game)
    @board = game.board
  end

  # TODO - to test
  def is_valid_chess_move?
    # TODO
  end

  # TODO - to test
  def execute_chess_move!
    # TODO
  end

  # TODO - to test
  def is_valid_piece_char_syntax?
    # TODO
  end

  # TODO - to test
  def is_valid_coords_syntax?
    # TODO
  end

  # TODO - to test
  def is_valid_move_syntax?
    # TODO
  end

  # TODO - to test
  def is_valid_capture_syntax?
    # TODO
  end

  # TODO - to test
  def is_valid_promotion_syntax?
    # TODO
  end

  # TODO - to test
  def is_valid_queenside_castle_syntax?
    # TODO
  end

  # TODO - to test
  def is_valid_kingside_castle_syntax?
    # TODO
  end

  # TODO - to test
  def is_valid_syntax?
    # TODO
  end

  # TODO - to test
  def coords_to_matrix_cell
    # TODO
  end

  # TODO - to test
  def is_matching_src_piece?
    # TODO
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
