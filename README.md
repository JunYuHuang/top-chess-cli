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
- Adhering to SOLID Principles (e.g. Dependency Injection, Single Responsiblity, etc.)
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
- Uses the following symbols / characters to specify special moves in player input:
  - `=`: Pawn Promotion
  - `+`: Check (can be omitted)
  - `#`: Checkmate (can be omitted)
  - `x`: Capture
  - `O-O` or `0-0`: Kingside Castle
  - `O-O-O` or `0-0-0`: Queenside Castle
- Game ends on a checkmate or stalemate
- Does **not** support the following rules:
  - Resign and draw proposals
  - Reptition of moves
  - 50 moves rules
  - Chess clocks and time
<!-- - TODO: Allow the human player to play against a simple AI computer player. -->

## Features

- Save as many in-progress games as desired when in-game as `save_<unique_integer_id>.yaml` YAML files in the `/saves` folder.
- Load from any existing game save file.
<!-- - TODO: Allow the human player to play against a simple AI computer player. -->
