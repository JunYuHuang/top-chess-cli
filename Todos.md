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

## Overall Milestone TODOs

Complete the following:

- [ ] Build base game logic
- [ ] Build GUI interfaces for getting player inputs (via console)
- [ ] Build GUI interfaces for displaying the game (via console)
- [ ] Build game saving and loading feature
- [ ] Build simple computer AI opponent player

## Optional and Nice-to-have TODOs

Complete the following:

- [x] Rename `DummyPiece` to `MockPiece`
- [ ] Refactor `Piece` subclasses to store their own position on the grid
- [ ] Refactor `Game` class to store an array or hashmap of `Piece` objects rather than a matrix of them
- [x] Refactor to not use and remove the `EmptyPiece` class
- [ ] Add `move` method to `Piece` subclasses (modifies board in-place or returns a new board)
- [ ] Add `capture` method to `Piece` subclasses (modifies board in-place or returns a new board)
- [ ] Add `queenside_castle` method to `King` class
- [ ] Add `kingside_castle` method to `King` class
- [ ] Add `queenside_castle` method to `Rook` class
- [ ] Add `kingside_castle` method to `Rook` class

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

<!-- ## `ComputerPlayer` class

Complete the following:

- [ ] `.initialize` constructor
- [ ] `#get_turn_input` method
- [ ] `#get_random_move` method (private)
- [ ] `to_s` method -->

## `PieceUtils` module

Complete the following:

- [x] `#is_valid_piece_color?` method
- [x] `#is_valid_piece_type?` method
- [x] `#is_inbound_cell?` method (possibly not needed?)
- [x] `#is_empty_cell?` method
- [x] `#is_ally_piece_cell?` method
- [x] `#is_enemy_piece_cell?` method
- [x] `#at_last_row?` method
- [x] `#is_valid_promotion?` method
- [x] `#deep_copy` method
- [x] `#board_to_s` method
- [x] `#is_piece_type?` method
- [x] `#is_piece_color?` method
- [x] `#pieces` method
- [x] `#remove_pieces` method
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
- [x] `#l_shaped_moves` method
- [x] `#l_shaped_captures` method

Complete the tests for the following (indirectly via `Piece` subclasses that use this module):

- [x] `#is_valid_piece_color?` method
- [x] `#is_valid_piece_type?` method
- [x] `#is_inbound_cell?` method (possibly not needed?)
- [x] `#is_empty_cell?` method
- [ ] `#is_ally_piece_cell?` method
- [x] `#is_enemy_piece_cell?` method
- [x] `#at_last_row?` method
- [x] `#is_valid_promotion?` method
- [x] `#deep_copy` method
- [x] `#board_to_s` method
- [x] `#is_piece_type?` method
- [x] `#is_piece_color?` method
- [x] `#pieces` method
- [x] `#remove_pieces` method
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
- [x] `#l_shaped_moves` method
- [x] `#l_shaped_captures` method

## `Piece` class

Complete the following:

- [x] `.initialize` constructor
- [x] `#color` method
- [x] `#type` method
- [x] `#is_capturable?` method

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
- [x] `#captures` method

## `BishopPiece` class (inherits from `Piece`)

Complete the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method

Complete the tests for the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method

## `QueenPiece` class (inherits from `Piece`)

Complete the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method

Complete the tests for the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method

## `KnightPiece` class (inherits from `Piece`)

Complete the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method

Complete the tests for the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method

## `PawnPiece` class (inherits from `Piece`)

Complete the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#did_move?` method
- [x] `#moved!` method
- [x] `#did_double_step?` method
- [x] `#double_stepped!` method
- [x] `#is_promotable?` method
- [x] `#is_valid_promotion?` method
- [x] `#can_capture_en_passant?` method
- [x] `#capture_en_passant` method
- [x] `#black_moves` method (private)
- [x] `#white_moves` method (private)
- [x] `#black_captures` method (private)
- [x] `#white_captures` method (private)
- [x] `#can_white_capture_en_passant_left?` method (private)
- [x] `#can_white_capture_en_passant_right?` method (private)
- [x] `#can_black_capture_en_passant_left?` method (private)
- [x] `#can_black_capture_en_passant_right?` method (private)
- [x] `#can_white_capture_en_passant?` method (private)
- [x] `#can_black_capture_en_passant?` method (private)
- [x] `#white_capture_en_passant` method (private)
- [x] `#black_capture_en_passant` method (private)

Complete the tests for the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#can_capture_en_passant?` method
- [x] `#capture_en_passant` method
- [x] `#is_promotable?` method
- [x] `#is_valid_promotion?` method

## `KingPiece` class (inherits from `Piece`)

Complete the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#did_move?` method
- [x] `#moved!` method
- [x] `#is_checked?` method
- [x] `#is_checkmated?` method
- [x] `#is_stalemated?` method
- [x] `#can_queenside_castle?` method
- [x] `#can_kingside_castle?` method
- [x] `#moves_queenside_castle` method (private)
- [x] `#moves_kingside_castle` method (private)
- [x] `#are_cells_amid_queenside_castle_empty?` method (private)
- [x] `#are_cells_amid_kingside_castle_empty?` method (private)
- [x] `#can_white_queenside_castle?` method (private)
- [x] `#can_black_queenside_castle?` method (private)
- [x] `#can_white_kingside_castle?` method (private)
- [x] `#can_black_kingside_castle?` method (private)

Complete the tests for the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#is_checked?` method
- [x] `#is_checkmated?` method
- [x] `#is_stalemated?` method
- [x] `#can_queenside_castle?` method
- [x] `#can_kingside_castle?` method

## `PieceFactory` class

Complete the following:

- [ ] `.initialize` constructor
- [ ] `#spawn` method

Complete the tests for the following:

- [ ] `.initialize` constructor
- [ ] `#spawn` method

## `Game` class

Complete the following:

- [ ] `.initialize` constructor
- [ ] `#add_player!` method
- [ ] `#update!` method
- [ ] `#play!` method
- [ ] `#is_valid_piece_color?` method
- [ ] `#get_player` method
- [ ] `#add_captured_piece!` method
- [ ] `#switch_player_turns!` method
- [ ] `#did_player_win?` method
- [ ] `#did_tie?` method
- [ ] `#use_game_saves` method
- [ ] `#use_console_ui` method
- [ ] `#use_chess_move_runner` method
- [ ] `#use_command_runner` method
- [ ] `#is_last_move_enemy_pawn_double_step?` method
- [ ] `#is_valid_move?` method
- [ ] `#move!` method
- [ ] `#is_valid_capture?` method
- [ ] `#capture!` method
- [ ] `#can_promote?` method
- [ ] `#promote!` method
- [ ] `#is_valid_castle?` method
- [ ] `#castle!` method
- [ ] `#is_valid_capture_en_passant?` method
- [ ] `#capture_en_passant!` method
- [ ] `#empty_board` method (private)
- [ ] `#start_board` method (private)

Complete the tests for the following:

- [ ] TODO

## `ChessMoveConverter` class

Complete the following:

- [ ] TODO

Complete the tests for the following:

- [ ] TODO

## `CommandRunner` class

Complete the following:

- [ ] TODO

Complete the tests for the following:

- [ ] TODO

## `ConsoleUI` class

Complete the following:

- [ ] `.initialize` constructor
- [ ] `.clear_UI` method
- [ ] `.print_board` method
- [ ] `.print_captured_pieces` method
- [ ] `.print_turn_prompt` method
- [ ] `.print_game_end` method
- [ ] `.print_saves_tables` method
- [ ] `.print_load_prompt` method
- [ ] `.print_load_screen` method
- [ ] `.print_setup_scren` method
- [ ] `.print_turn_screen` method
- [ ] `.print_end_screen` method

## `GameSave` class

Complete the following:

- [ ] `.initialize` constructor
- [ ] `#path` constructor
- [ ] `#set_path` method
- [ ] `#save_prefix` method
- [ ] `#set_save_prefix` method
- [ ] `#count_saves` method
- [ ] `get_save_names_list` method
- [ ] `#does_save_exist?` method
- [ ] `#create_save` method
- [ ] `#load_save` method

Complete the tests for the following:

- [ ] `.initialize` constructor
- [ ] `#path` constructor
- [ ] `#set_path` method
- [ ] `#save_prefix` method
- [ ] `#set_save_prefix` method
- [ ] `#count_saves` method
- [ ] `get_save_names_list` method
- [ ] `#does_save_exist?` method
- [ ] `#create_save` method
- [ ] `#load_save` method
