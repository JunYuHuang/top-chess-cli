# TODOs

## Planning TODOs

Complete the expanded pseudocode for following classes:

- [x] `Piece` class
- [x] `PawnPiece` class
- [x] `RookPiece` class
- [x] `KnightPiece` class
- [x] `BishopPiece` class
- [x] `QueenPiece` class
- [x] `KingPiece` class
- [x] `PieceFactory` class

## `Player` class

Complete the following:

- [x] `.initialize` constructor
- [x] `#piece_color` method
- [x] `#name` method

## `HumanPlayer` class

Complete the following:

- [x] `.initialize` constructor
- [ ] `#get_turn_input` method
- [ ] `#get_start_option` method
- [ ] `#get_opponent_type` method
- [x] `to_s` method

## `PieceUtils` module

Complete the following:

- [x] `#is_inbound_cell?` method (possibly not needed?)
- [x] `#is_empty_cell?` method
- [x] `#is_ally_piece_cell?` method
- [x] `#is_enemy_piece_cell?` method
- [x] `#up_moves` method
- [x] `#up_capture` method
- [x] `#down_moves` method
- [x] `#down_capture` method
- [x] `#left_moves` method
- [x] `#left_capture` method
- [x] `#right_moves` method
- [x] `#right_capture` method
- [x] `#down_left_moves` method
- [x] `#down_left_capture` method
- [x] `#up_right_moves` method
- [x] `#up_right_capture` method
- [x] `#down_right_moves` method
- [x] `#down_right_capture` method
- [x] `#up_left_moves` method
- [x] `#up_left_capture` method

## `Piece` class

Complete the following:

- [x] `.initialize` constructor
- [x] `#color` method
- [x] `#type` method
- [x] `#is_interactive?` method
- [x] `#is_capturable?` method

## `EmptyPiece` class (inherits from `Piece`)

Complete the following:

- [x] `.type` method
- [x] `.is_interactive?` method

## `RookPiece` class (inherits from `Piece`)

Complete the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#did_move?` method
- [x] `#moved!` method

Complete the tests for the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [ ] `#captures` method
