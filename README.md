# Chess Console Game

## Demo

<!-- ![Gameplay demo of one player winning the game Chess](/assets/chess-demo.gif) -->

This is a console implementation of the classic two-player board game Chess.

Note that chess pieces are printed on the chess board as 2-character strings composed of a lowercase and an uppercase alphabetical English characters e.g. `bP` for a Black Pawn.

The first character is either `b` or `w` which denotes the color of the piece as black or white respectively.

The second character denotes the type of chess piece it is. The letter to piece mappings are as follows:
- `P`: Pawn
- `R`: Rook
- `N`: Knight
- `B`: Bishop
- `Q`: Queen
- `K`: King

## Quick Start

This application assumes you have Ruby 3.1.4 installed.

```bash
# install RSpec
bundle install

# running the game
ruby app.rb

# running the tests
rspec
```

## Skills Demonstrated

- Object-Oriented Programming (OOP) Design
- Applied SOLID Principles (e.g. Dependency Injection, Single Responsiblity, etc.)
- Unit and Integration Testing
- Input Validation
- Handling Edge Cases
- File Input and Output
- Persistent Storage with Writing to and Reading from Local Files

## Scope

- Allows 2 human players to play against each other.
- White (i.e. the player with the white pieces) always goes first.
- Player 1 can choose which side to play as (white or black).
- Player 2 is automatically assigned the opposing side to play (black if Player 1 chose white or white if Player 1 chose black).
- Allows players to input moves using Long Algebraic Notation.
  - E.g. `Nf1f3` to move White's Knight to the square `f3` from its starting position.
- Supports all of the following standard and special chess moves:
  - Non-capturing moves
  - Capturing moves
  - En-passant captures
  - Pawn promotions
  - Both queenside and kingside castling
- Uses the following symbols / characters as part of or specifying chess moves in player input:
  - `-`: Non-capturing move (can be omitted)
  - `=`: Pawn Promotion
  - `x`: Capture
  - `O-O` or `0-0`: Kingside Castle
  - `O-O-O` or `0-0-0`: Queenside Castle
- Excludes the following symbols / characters that are part of specifying chess moves in player input:
  - `e.p.`: Pawn captured / taken en-passant (MUST be omitted)
  - `+`: Check (MUST be omitted)
  - `#`: Checkmate (MUST BE omitted)
- Game ends on a checkmate or stalemate
- Does **not** support the following rules:
  - Resign and draw proposals
  - Reptition of moves
  - 50 moves rules
  - Chess clocks and time
<!-- - TODO: Allow the human player to play against a simple AI computer player. -->

## Features

- Supports all standard chess moves including special moves such as the following:
  - En-passant (pawn) captures
  - Pawn promotions
  - Castling
- Save as many in-progress games as desired when in-game as `save_<unique_integer_id>.yaml` YAML files in the `/saves` folder.
- Load from any existing game save file.
<!-- - TODO: Allow the human player to play against a simple AI computer player. -->

## Custom Long Algebraic Notation Notes

Note that this chess game uses a custom or modified version of Long Algebraic Notation for taking chess moves from player input. The following notes specify what templates and formats to use for their respective chess moves and examples to illustrate them.

Legend:
- `piece_char`: A character from the set `{ '', 'R', 'N', 'B', 'Q', 'K' }` that identifies the chess piece to move on the board for non-capturing moves and captures.
- `coord`: A 2-character string that denotes the square on the chess board with the following constraints:
  - `coord[0]`: The column / file letter from the set `{ a, b, c, d, e, f, g, h }`
  - `coord[1]`: The row / rank integer character from the set `{ 1, 2, 3, 4, 5, 6, 7, 8 }`
- `src_coord`: The source or starting square to move the specified piece to. See `coord`.
- `dst_coord`: The destination or target square to move the specified piece to. See `coord`.
- `promo_char`: A character from the set `{ R, N, B, Q }` that denotes the promotion piece for a pawn that reaches the furthest opposing row (relative to where it started).

### (Non-Capturing) Moves

#### Template Syntax

```bash
# With dash separator
{piece_char}{src_coord}-{dst_coord}
```

OR

```bash
# Without dash separtor
{piece_char}{src_coord}{dst_coord}
```

#### Example 1

```
a2-a4
```

Move white pawn from square `a2` two steps forward to square `a4`.

#### Example 2

```
Ra1b1
```

Move white rook from square `a1` 1 step left  to square `b1`.

### Captures (includes en-passant captures)

#### Template Syntax

```
{piece_char}{src_coord}x{dst_coord}
```

#### Example 1

```
Bc1xg5
```

White bishop at square `c1` captures (and moves to) an enemy black piece at square `g5`.

#### Example 2

```bash
# an en-passant capture
f5xe6
```

White pawn at square `f5` moves to square `e6` to capture en-passant the enemy black pawn that double-stepped forward (in the immediate previous turn) to square `e5` from square `e7`.

### Checks and Checkmates

For this game, do not specify if the move or capture result in a check or checkmates; do not append a `+` or `#` suffix to the accompanying move or capture.

### (Pawn) Promotions

#### Template Syntax

```bash
# (Pawn) Promotion via a capture
{src_coord}x{dst_coord}={promo_piece}
```

OR

```bash
# (Pawn) Promotion via a move (with dash)
{src_coord}-{dst_coord}={promo_piece}
```

OR

```bash
# (Pawn) Promotion via a move (no dash)
{src_coord}{dst_coord}={promo_piece}
```

#### Example 1

```
c7-c8=Q
```

White pawn at square `c7` moves to square `c8` and promotes to a white queen.

### Queenside Castles

#### Template Syntax

```bash
# with numerical digit zero '0' characters
0-0-0
```

OR

```bash
# with uppercase letter 'O' characters
O-O-O
```

### Kingside Castles

#### Template Syntax

```bash
# with numerical digit zero '0' characters
0-0
```

OR

```bash
# with uppercase letter 'O' characters
O-O
```
