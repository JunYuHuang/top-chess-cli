# Chess Console Game

<!-- ![Gameplay demo of one player winning the game Chess](/assets/chess-demo.gif) -->

This is a console or command-line implementation of the classic two-player board game Chess that lets players input their moves using a custom form of Long Algebraic Notation. Players can choose to either play against another human player or a simple computer player / bot. Games can be saved and loaded from save files.

For the details on the game and its custom Long Algebraic Notation, see the [Specifications document](/docs/Specs.md).

For additional demonstration video recordings, see the [Demonstrations document](/docs/Demos.md).

Chess pieces are printed on the chess board as 2-character strings composed of a lowercase and an uppercase alphabetical English characters e.g. `bP` for a Black Pawn. The first character is either `b` or `w` which denotes the color of the piece as black or white respectively. The second character denotes the type of chess piece it is.

The letter to piece mappings are as follows:
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

- Unit and Integration Testing with over 500 tests
- Object-Oriented Programming (OOP) Design
- Applied SOLID Principles (e.g. Dependency Injection, Single Responsiblity, etc.)
- Input Validation
- Handling Edge Cases
- File Input and Output
- Persistent Storage with Writing to and Reading from Local Files
