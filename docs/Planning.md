# Planning Notes

## Basic Game Rules and Mechanics

- 2 player PVP game played on a 8 x 8 game board
- 1 player uses white pieces, the other uses black pieces
- Player with white pieces goes first
- objective of game is for a player to checkmate or capture the other player's king piece
- Game progresses by alternating turns between each player
- On each player's turn, they can move only 1 of their pieces
  - exception: castling with King and a Bishop piece if neither has moved in the game yet
- Game ends in 3 possible ways:
  - white wins + black loses; white checkmates black
  - white loses + black wins; black checkmates white
  - stalemate / tie; one of the players cannot make a legal move with their king b/c it will be checkmated if done so
- 8 x 8 game board
  - rows / ranks: labelled from 8 to 1 from top to bottom
  - cols / files: labelled from a to h from left to right
  - cell coordinates are given as `file/rank` e.g. `e4`
  - initial board state
    - black's pieces fill ranks 8 and 7 (top 2 rows)
    - white's pieces fill ranks 2 and 1 (bottom 2 rows)
- each player has 16 pieces composed of 6 unique types:
  - 8 x Pawns
  - 2 x Rooks
  - 2 x Knights
  - 2 x Bishops
  - 1 x Queen
  - 1 x King
- shared common actions for each piece:
  - move to an empty, in-bound cell
  - capture a piece owned by the opposing player
    - typically by moving to that piece's cell position
    - captures by pawns are different
  - check the opposing player's king
  - checkmate the opposing player's king
- unique actions for certain pieces:
  - move next to each other and swap sides (castling with king and bishop pieces)
  - change to a non-King and non-Pawn piece (promotion)
- each game piece type has their own set of valid movements and may have special moves
  - Pawn:
    - can move 1 cell / step forward; can NOT move backwards
    - can move 2 cells / steps forward on its first move
    - can only move diagonally forward left/right if capturing an enemy piece
    - `taking en-passant`:
      - can capture an opposing pawn piece that is in the same row / rank in a certain scenario
      - must be done immediately after opposing pawn has made its double-step move
        - cannot capture such a pawn if the pawn makes any other moves after that
      - capture is done by moving forward diagonally to the cell "behind" the to-be-captured pawn
      - for black pawns, can only take en-passant white pawns that have double-stepped into row / rank 4
        - black pawn captures the white pawn and moves to rank 3
      - for white pawns, can only take en-passant black pawns that have double-stepped into row / rank 5
        - white pawn captures the black pawn and moves to rank 6
    - cannot jump over other (ally or enemy) pieces
    - cannot move to a cell that has an allied piece (no friendly fire / team kill)
    - `promotion`: piece must be replaced by another piece when it reaches the furthest row from its starting row
      - valid replacement allied pieces: rook, knight, bishop, or queen
      - must reach row 8 if pawn is white or row 1 if pawn is black
  - Rook: moves in any straight line horizontally or horizontally up to the boundaries of the board
    - cannot jump over other (ally or enemy) pieces
    - cannot move to a cell that has an allied piece (no friendly fire / team kill)
    - moving to a cell that has an enemy piece captures that piece
  - Knight: moves to any cell following a 3-step L-path (up to 8 possible moves)
    - moves left/right once then top/down twice OR
    - moves left/right twice then top/down once OR
    - moves top/down once then left/right twice OR
    - moves top/down twice then left/right once
    - CAN jump over other (ally or enemy) pieces
    - cannot move to a cell that has an allied piece (no friendly fire / team kill)
    - moving to a cell that has an enemy piece captures that piece
  - Bishop: moves in any straight diagonal line up to the boundaries of the board
    - cannot jump over other (ally or enemy) pieces
    - cannot move to a cell that has an allied piece (no friendly fire / team kill)
    - moving to a cell that has an enemy piece captures that piece
  - Queen: moves in any straight line horizontal / vertical / diagonal up to the boundaries of the board
    - cannot jump over other (ally or enemy) pieces
    - cannot move to a cell that has an allied piece (no friendly fire / team kill)
    - moving to a cell that has an enemy piece captures that piece
  - King: moves to any adjacent single cell horizontally / vertically / diagonally
    - most important piece of game
    - cannot move to a cell that places itself in check
    - cannot jump over other (ally or enemy) pieces
    - cannot move to a cell that has an allied piece (no friendly fire / team kill)
    - moving to a cell that has an enemy piece captures that piece
    - `castling`: moves simultaneously with and side-by-side to an allied bishop piece
      - can be done by each player at most once per game
      - must meet several (7) requirements to be able to perform the move
      - `long castling`: castling with furthest (i.e. left-most) allied bishop
      - `short castling`: castling with closest (i.e. right-most) allied bishop
- terminology
  - `check`: when a player's king can be taken by a piece of the opposing player
    - player with piece that gives check (can take the king) should declare check
  - `checkmate`/ `mate`: when a player is in check and they cannot make a move to escape the check
    - ends game; checkmated player loses, player that mated the other player wins
  - `stalemate`: player cannot make a legal move and player is not in check
    - ends game in a tie / draw
  - `en-passant`: see above notes
  - `castling`: see above notes
  - `promotion`: see above notes
- algebraic / standard notation cheatsheet notes
  - see [this page](https://cheatography.com/davechild/cheat-sheets/chess-algebraic-notation/) for full details
  - standard move format:
    - `{piece}[start_file][start_rank][capture]{target_cell}[promotion|check|checkmate|en-passant]`
      - specify a different `target_cell` if executing a `taking en-passant` move
  - special move formats:
    - `O-O`: kingside / short castling
    - `O-O-O`: queenside / long castling
  - only `piece` and `target_cell` are required if
    - declared piece is unambiguous
    - the move is not a capture / check / checkmate / promotion
  - if declared piece is ambiguous (there are multiple valid pieces that the declared piece can refer to)
    - use `start_file` to make it clear
    - use `start_rank` to make it clear if `start_file` is still unclear
    - use both `start_file` and `start_rank` to make it totally clear
  - `piece` is always a single uppercase alphabet char or an empty string that
    - `K`: king
    - `Q`: queen
    - `R`: rook
    - `B`: bishop
    - `N`: knight
    - `_` (empty string): pawn
  - `capture` is denoted by the `x` char
  - `promotion` is denoted by the `=` char appended with a piece char that represents a queen, rook, bishop, or knight
    - e.g. `e8=Q`
  - `check` is denoted by the `+` char
  - `checkmate` is denoted by the `#` char
  - `en-passant` is optionally denoted by a ` e.p.` suffix string
- consider allowing only `long algebraic notation` or `reversible algebraic notation` for player inputs
  - `long alge. notation`: alge. not. + must specify starting file and rank of piece
  - `rev. alge. notation`: `long alge. notation` + must specify captured piece if move captures a piece
- need to specify `check` or `checkmate` in alge. not.?
  - no; is optional according to ChatGPT

## MVP Requirements

- 2 human players
- console GUI / interface
- accepts LAN (Long Algebraic Notation) from human players for chess move inputs
- console UI 'screens'
  - game turn screen that displays
    - game board
    - whose turn it currently is
    - message indicating that the player's king has been checked if so
    - prompt for how to enter a valid chess move in Long AN
    - message indicating that the input was invalid if an invalid input was entered previously
  - game end screen
    - display game board
    - display game result (checkmate or stalemate)
  - game load screen
    - display first 3 save file names in ASCII "table"
    - allow user to either:
      - start a new game
      - load from a previously saved game
  - game config / setup screen (implement only if completed AI computer bot player)
    - choose which coloured piece or side to play as
      - TODO
    - choose to play against another human or computer player
      - TODO
- bonus
  - allow human player to play against a simple AI computer player that makes random legal moves
  - update chess notation parser to accept short algebraic notation with abbreviations
  - allow players to propose (agree or reject) a draw
  - allow a player to resign or forfeit the game (to let the opposing player to win by choice)
  - represent the game pieces by 2-letter alphabet chars e.g. `bP` for a Black Pawn
  - game turn screen displays
    - pieces captured by white
    - pieces captured by black

## Long Algebraic Notation & Misc Edge Case Chess Notes

- en-passant captures are specified exactly like a normal capture
  - i.e. no need to append the optional `e.p.` suffix to it
- **must promote** a pawn if it reaches the end of the board from opposite from where it started
- need to join the start and end squares / cells with a `-` hyphen char for non-capturing moves?
  - optional
- need to append the `+` check or `#` checkmate suffixes for captures?
  - optional for non-competitive or casual games
- need to append the `+` check or `#` checkmate suffixes for non-capturing moves?
  - optional for non-competitive or casual games
- my custom / modified Long Algebraic Notation (first iteration)
  - **does not specify check or checkmate** in its moves or captures
  - examples
    - `a2-a4`: white pawn double steps forward to square `a4`
    - `Ra1b1`: white rook moves right to square `b1`
    - `Bc1xg5`: white bishop captures an enemy piece at square `g5`
    - `c7-c8=Q`: white pawn promotes to a queen after moving to square `c8`
    - `0-0-0`: white or black queenside castle
    - `O-O`: white or black kingside castle
  - legend
    - `piece_char`: a char from the set `{ '', 'R', 'N', 'B', 'Q', 'K' }`
    - `coord`: a 2-char string with the following constraints
      - `coord[0]`: column / file letter from the set `{ a, b, c, d, e, f, g, h }`
      - `coord[1]`: row / rank integer from the set `{ 1, 2, 3, 4, 5, 6, 7, 8 }`
    - `src_coord`: see `coord`
    - `dst_coord`: see `coord`
    - `promo_char`: a char from the set `{ R, N, B, Q }`
  - templates
    - move (with dash):
      - `{piece_char}{src_coord}-{dst_coord}`
    - move (no dash):
      - `{piece_char}{src_coord}{dst_coord}`
    - capture (includes en-passant captures):
      - `{piece_char}{src_coord}x{dst_coord}`
    - (pawn) promotion via a move (with dash):
      - `{src_coord}-{dst_coord}={promo_char}`
    - (pawn) promotion via a move (no dash):
      - `{src_coord}{dst_coord}={promo_char}`
    - (pawn) promotion via a capture:
      - `{src_coord}x{dst_coord}={promo_char}`
    - queenside castle: `0-0-0` or `O-O-O`
    - kingside castle: `0-0` or `O-O`

## Game Logic and Basic Pseudocode v1 (base game with saves and loads)

- if there are any existing local game save files
  - prompt human player to either
    - start a new game OR
    - load from an existing game file
  - if human player requested to load a game file
    - display a "table" of existing save files
    - prompt player for which game file to load
    - while entered game file id is invalid,
      - prompt for a valid game to load
    - load the game file
  - else start a new game
- if new game started
  - prompt the first (human) player for which side (by piece colour) they want to play as
  - while input side is invalid,
    - prompt for a valid input side
- while game is not over
  - return if there are not 2 players in the game
  - print game end screen and return if:
    - the white player won (checkmated the black king) OR
    - the black player won (checkmated the white king) OR
    - there is a stalemate (neither player can win)
  - get input from human player
    - print turn screen
    - do something based on what the input is
    - if the input is a valid chess move
      - valid chess moves:
        - non-capturing move
        - capturing move (includes en-passant)
        - pawn promotion
        - kingside or queenside castling
      - update game state
    - else if the input is a valid command to save the current game i.e. `!save`
      - save the current game's state as a new save file under `/saves/save_{save_count}.yaml`
      - display something in the next turn screen that indicates that the game was saved successfully as `save_{save_count}`
  - switch the turn to the other player

## Game Logic and Basic Pseudocode v2 (with AI computer player)

- TODO

## Expanded Pseudocode / Partial Code

See [Todos.md](./Todos.md) for the most up-to-date details.

- `ConsoleUI` class?
  - constructor()
    - TODO
  - clear_UI()
    - TODO
  - print_board()
    - TODO
  - print_captured_pieces(capturer_color)
    - TODO
  - print_turn_prompt(is_valid, last_input)
    - TODO
  - print_game_end()
    - TODO
  - print_saves_table()
    - TODO
  - print_load_prompt(is_valid, last_input)
    - TODO
  - print_color_prompt(is_valid, last_input)
    - TODO
  - print_opponent_prompt(is_valid, last_input)
    - TODO
  - print_load_screen()
    - TODO
  - print_setup_screen()
    - TODO
  - print_turn_screen()
    - TODO
  - print_end_screen()
    - TODO
- `HumanPlayer` class
  - constructor()
    - TODO
  - get_turn_input()
    - TODO
  - get_start_option()
    - TODO
  - get_opponent_type()
    - TODO
- `ComputerPlayer` class
  - constructor()
    - TODO
  - get_turn_input()
    - TODO
  - get_random_move()
    - TODO
- `GameSave` class
  - constructor()
    - TODO
  - path()
    - TODO
  - set_path()
    - TODO
  - save_prefix()
    - TODO
  - set_save_prefix(prefix)
    - TODO
  - count_saves()
    - TODO
  - get_save_names_list(save_name_prefix, limit)
    - TODO
  - does_save_exist?(save_name)
    - TODO
  - create_save(game_obj)
    - TODO
  - load_save(game_obj, save_name)
    - TODO

## Save File Anatomy

Each save file is saved as a YAML file with the following metadata:

```yaml
# Symbol that represents the current player's turn by their game
# piece color. Either `:white` or `:black`.
:turn_color: :white


# Array of hashes that represents each player of the game.
:players:

  # Hash that represents the first player.
  -

    # Symbol that represents what side (by color) the player is playing
    # as. Either `:white` or `:black`.
    :piece_color: :white

    # Symbol that represents the type of player. Either `human` or
    # `computer` (for when the `ComputerPlayer` class is done).
    :type: :human

    # String that represents the in-game name of the player set by the
    # `Game` class. Adheres to the following naming format / scheme:
    # `{COLOR} ({Player_type} Player {player_type_count})`.
    :name: WHITE (Human Player 1)

  # Same data structure as the first player but for the second player.
  -
    # ...


# Array of hashes that represents each piece (with their
# current state) on the chess board.
:pieces:

  # A single chess piece represented as a hash (map).
  -
    # 0-indexed [row, col] position of the piece on the chess board
    # as an integer array of size 2. Both `row` and `col` are integers
    # in the range [0, 7] inclusive. E.g., [0, 0] is the square 'a8'.
    :cell:
      - 1
      - 3

    # Color of the chess piece as a symbol.
    # Is either `:white` or `:black`.
    :color: :black

    # Type of chess piece as a symbol. Is one of the following:
    # `:pawn`, `:rook`, `:knight`, `:bishop`, `:queen` or `:king`.
    :type: :pawn

    # Boolean flag that indicates if the chess piece can be captured
    # by an enemy piece or not. True for all chess piece types except
    # for Kings. Is either `true` or `false`.
    :is_capturable: true

    # Boolean flag that indicates if the chess piece has moved from its
    # initially starting position or not. Only present on Rook, King,
    # and Pawn pieces that dictate their available moves or captures
    # (i.e., castling and whether pawns can move 2 squares forward or do
    # an en-passant capture). Is either `true` or `false`.
    :did_move: false

    # Boolean flag that indicates if the chess piece can be captured
    # en-passant by an enemy pawn. Only present on Pawn pieces. Is
    # either `true` or `false`.
    :is_capturable_en_passant: false

  # More pieces from the chess board omitted...
  -
    # ...


# Hashmap or dictionary of the enemy (black) chess pieces by type
# that White has captured. Holds 5 key-value pairs that represent pairs
# of capturable piece types and how many of each has been captured by
# White. Each key is a symbol that is either `:pawn`, `:rook`, `:knight`,
# `:bishop` or `:queen`. The value of each key is an integer that ranges
# from 0 to however many of that chess piece type was captured. Excluding
# pawn promotions, the normal ranges for each piece are as follows:
# - pawn:   [0, 8] inclusive
# - rook:   [0, 2] inclusive
# - knight: [0, 2] inclusive
# - bishop: [0, 2] inclusive
# - queen:  [0, 1] inclusive
:white_captured:
  :pawn: 3
  :rook: 0
  :knight: 1
  :bishop: 0
  :queen: 0


# Same data structure as `white_captured` but for enemy (white) chess
# pieces by type that Black has captured.
:black_captured:
  # ...
```

Save files are saved in the `./saves` directory as YAML files with the `save_{unique_id}.yaml` naming scheme format.

## UI Design

### Turn Screen - Start Of Game

```
    a    b    c    d    e    f    g    h
  ╔════╤════╤════╤════╤════╤════╤════╤════╗
8 ║ bR │░bN░│ bB │░bQ░│ bK │░bB░│ bN │░bB░║ 8
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
7 ║░bP░│ bP │░bP░│ bP │░bP░│ bP │░bP░│ bP ║ 7
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
6 ║    │░░░░│    │░░░░│    │░░░░│    │░░░░║ 6
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
5 ║░░░░│    │░░░░│    │░░░░│    │░░░░│    ║ 5
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
4 ║    │░░░░│    │░░░░│    │░░░░│    │░░░░║ 4
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
3 ║░░░░│    │░░░░│    │░░░░│    │░░░░│    ║ 3
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
2 ║ wP │░wP░│ wP │░wP░│ wP │░wP░│ wP │░wP░║ 2
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
1 ║░wR░│ wN │░wB░│ wQ │░wK░│ wB │░wN░│ wB ║ 1
  ╚════╧════╧════╧════╧════╧════╧════╧════╝
    a    b    c    d    e    f    g    h

BLACK's captures:
WHITE's captures:

✅ Started a new game.
It is WHITE (Human Player 1)'s turn.

Enter your move in Long Algebraic Notation (e.g. 'e2e3'
to move your pawn from 'e2' to 'e3' as WHITE)
or '!save' to save the game:
❌ 'asdf' is an illegal move or invalid command. Try again.
```

### Turn Screen - Black Is Checked

```
    a    b    c    d    e    f    g    h
  ╔════╤════╤════╤════╤════╤════╤════╤════╗
8 ║    │░░░░│    │░░░░│ bK │░░░░│    │░░░░║ 8
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
7 ║░░░░│    │░░░░│    │░░░░│    │░░░░│    ║ 7
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
6 ║    │░░░░│    │░░░░│    │░░░░│    │░░░░║ 6
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
5 ║░░░░│    │░░░░│    │░wR░│    │░░░░│    ║ 5
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
4 ║    │░░░░│    │░░░░│    │░░░░│    │░░░░║ 4
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
3 ║░░░░│    │░░░░│    │░░░░│    │░░░░│    ║ 3
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
2 ║    │░░░░│    │░░░░│    │░░░░│    │░░░░║ 2
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
1 ║░░░░│    │░░░░│    │░wK░│    │░░░░│    ║ 1
  ╚════╧════╧════╧════╧════╧════╧════╧════╝
    a    b    c    d    e    f    g    h

BLACK's captures: wP x 8, wB x 2, wN x 2, wR x 1, wQ x 1
WHITE's captures: bP x 8, bB x 2, bN x 2, bR x 2, bQ x 1


It is BLACK (Human Player 2)'s turn.
❕ Move your king out of check or block its check.
Enter your move in Long Algebraic Notation
(e.g. 'e2e3' to move the pawn at 'e2' to 'e3' as WHITE)
or '!save' to save the game:

```

### End Screen - White Victory

```
    a    b    c    d    e    f    g    h
  ╔════╤════╤════╤════╤════╤════╤════╤════╗
8 ║    │░░░░│    │░░░░│    │░wQ░│    │░bK░║ 8
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
7 ║░░░░│    │░░░░│    │░░░░│    │░░░░│ bP ║ 7
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
6 ║    │░░░░│    │░░░░│    │░░░░│    │░░░░║ 6
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
5 ║░░░░│    │░░░░│    │░░░░│    │░░░░│    ║ 5
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
4 ║    │░░░░│    │░░░░│    │░░░░│ wK │░░░░║ 4
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
3 ║░░░░│    │░░░░│    │░░░░│    │░░░░│    ║ 3
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
2 ║    │░░░░│    │░░░░│    │░░░░│    │░░░░║ 2
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
1 ║░░░░│    │░░░░│    │░░░░│    │░░░░│    ║ 1
  ╚════╧════╧════╧════╧════╧════╧════╧════╝
    a    b    c    d    e    f    g    h

BLACK's captures: wP x 8, wB x 2, wN x 2, wR x 2
WHITE's captures: bP x 7, bB x 2, bN x 2, bR x 2, bQ x 1

WHITE (Human Player 1) has checkmated BLACK (Human Player 2).
Game ended: 1-0 WHITE (Human Player 1) won!
```

### End Screen - Tie / Draw (Black Is Stalemated)

```
    a    b    c    d    e    f    g    h
  ╔════╤════╤════╤════╤════╤════╤════╤════╗
8 ║    │░░░░│    │░░░░│    │░░░░│    │░bK░║ 8
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
7 ║░░░░│    │░░░░│    │░░░░│    │░░░░│    ║ 7
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
6 ║    │░░░░│    │░░░░│    │░░░░│ wR │░wK░║ 6
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
5 ║░░░░│    │░░░░│    │░░░░│    │░░░░│    ║ 5
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
4 ║    │░░░░│    │░░░░│    │░░░░│    │░░░░║ 4
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
3 ║░░░░│    │░░░░│    │░░░░│    │░░░░│    ║ 3
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
2 ║    │░░░░│    │░░░░│    │░░░░│    │░░░░║ 2
  ╟────┼────┼────┼────┼────┼────┼────┼────╢
1 ║░░░░│    │░░░░│    │░░░░│    │░░░░│    ║ 1
  ╚════╧════╧════╧════╧════╧════╧════╧════╝
    a    b    c    d    e    f    g    h

BLACK's captures: wP x 8, wB x 2, wN x 2, wR x 1, wQ x 1
WHITE's captures: bP x 8, bB x 2, bN x 2, bR x 2, bQ x 1

BLACK (Human Player 2) is stalemated.
Game ended: ½-½ The game is a draw!
```

### Load Screen (appears if have 1+ game saves)

```
 _____________________
| Chess Game Saves    |
|_____________________|
| save_1              |
| save_2              |
| save_3              |
| and 0 more saves    |
|_____________________|

You have 3 Chess game save files.
Load a game from a save file or start a new game.

Enter '!new' to start a new game.
Enter '!load <save file name>' to resume playing from a saved game.
Enter your command (without quotes):
❌ '!loadz' is not a valid command. Try again.
```

### Setup Screen

```
New Chess Game Setup

Choose your colored piece.
Enter 'white' or 'black' (without quotes):
❌ 'yellow' is not a valid choice. Try again.

You chose 'white'.

Choose to play against a human or a computer opponent.
Enter 'human' or 'computer' (without quotes):
❌ 'AI' is not a valid choice. Try again.

You chose 'human'.
```
