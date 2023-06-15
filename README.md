# Chess Console Game

<!-- ![Gameplay demo of one player winning the game Chess](/assets/chess-demo.gif) -->

This is a console implementation of the classic two-player board game Chess.

Game Parameters and Constraints:

- Allows 2 human players to play against each other.
- Player 1 is always assigned the white pieces.
- Player 2 is always assigned the black pieces.
- The player with the white pieces ('White') always goes first.
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
<!-- - TODO: Allow the human player to play against a computer player. -->

Game Features:

- Save as many in-progress games as desired when in-game.
  - Games are saved as `save_<unique_integer_id>.yaml` YAML files in the /saves folder.
- Load from any existing game save file.

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
- Unit and Integration Testing
- Input Validation
- Handling Edge Cases
- File Input and Output
- Persistent Storage with Writing to and Reading from Local Files
