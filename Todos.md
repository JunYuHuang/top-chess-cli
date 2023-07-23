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
- [x] Add `move` method to `Piece` subclasses (modifies board in-place or returns a new board)
- [x] Add `capture` method to `Piece` subclasses (modifies board in-place or returns a new board)
- [x] Add `queenside_castle` method to `King` class
- [x] Add `kingside_castle` method to `King` class
- [x] Add `queenside_castle` method to `Rook` class
- [x] Add `kingside_castle` method to `Rook` class
- [ ] Rename `PieceUtils` module to `ChessUtils`

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

Complete the tests for the following:

- [x] `.initialize` constructor
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
- [x] `#deep_copy` method
- [x] `#count_col_cells_amid_two_cells`
- [x] `#move` method
- [x] `#capture` method
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

Complete the tests for the following (directly or indirectly via `Piece` subclasses that use this module):

- [x] `#is_valid_piece_color?` method
- [x] `#is_valid_piece_type?` method
- [x] `#is_inbound_cell?` method (possibly not needed?)
- [x] `#is_empty_cell?` method
- [ ] `#is_ally_piece_cell?` method
- [x] `#is_enemy_piece_cell?` method
- [x] `#deep_copy` method
- [x] `#count_col_cells_amid_two_cells`
- [x] `#move` method
- [x] `#capture` method
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
- [x] `#move` method
- [x] `#capture` method
- [x] `#queenside_castle` method
- [x] `#kingside_castle` method

Complete the tests for the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#move` method
- [x] `#capture` method
- [x] `#queenside_castle` method
- [x] `#kingside_castle` method

## `BishopPiece` class (inherits from `Piece`)

Complete the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#move` method
- [x] `#capture` method

Complete the tests for the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#move` method
- [x] `#capture` method

## `QueenPiece` class (inherits from `Piece`)

Complete the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#move` method
- [x] `#capture` method

Complete the tests for the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#move` method
- [x] `#capture` method

## `KnightPiece` class (inherits from `Piece`)

Complete the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#move` method
- [x] `#capture` method

Complete the tests for the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#move` method
- [x] `#capture` method

## `PawnPiece` class (inherits from `Piece`)

Complete the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#did_move?` method
- [x] `#moved!` method
- [x] `#is_double_step?` method
- [x] `#did_double_step?` method
- [x] `#double_stepped!` method
- [x] `#is_promotable?` method
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
- [x] `#move` method
- [x] `#capture` method

Complete the tests for the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#is_double_step?` method
- [x] `#can_capture_en_passant?` method
- [x] `#capture_en_passant` method
- [x] `#is_promotable?` method
- [x] `#move` method
- [x] `#capture` method

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
- [x] `#move` method
- [x] `#capture` method
- [x] `#queenside_castle` method
- [x] `#kingside_castle` method

Complete the tests for the following:

- [x] `.initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#is_checked?` method
- [x] `#is_checkmated?` method
- [x] `#is_stalemated?` method
- [x] `#can_queensidexcastle?` method
- [x] `#can_kingside_castle?` method
- [x] `#move` method
- [x] `#capture` method
- [x] `#queenside_castle` method
- [x] `#kingside_castle` method

## `PieceFactory` class

Complete the following:

- [x] `.initialize` constructor
- [x] `#create` method

Complete the tests for the following:

- [x] `.initialize` constructor
- [x] `#create` method

## `Game` class

Complete the following:

- [x] `.initialize` constructor
- [x] `#add_player!` method
- [ ] `#play!` method
- [x] `#player` method
- [x] `#switch_players!` method
- [x] `#did_player_win?` method
- [x] `#did_tie?` method
- [ ] `#use_chess_move_runner` method
- [x] `#are_valid_pieces?` method
- [x] `#empty_board` method
- [x] `#default_piece_obj` method
- [x] `#build_start_board` method
- [x] `#build_board` method
- [ ] `#is_last_move_enemy_pawn_double_step?` method
- [ ] `#update!` method
- [ ] `#use_console_ui` method
- [ ] `#use_game_saves` method
- [ ] `#add_captured_piece!` method
- [x] `#is_valid_piece?` method (private)
- [x] `#has_valid_did_move?` method (private)
- [x] `#has_valid_did_double_step?` method (private)

Complete the tests for the following:

- [x] `.initialize` constructor
- [x] `#add_player!` method
- [x] `#player` method
- [x] `#switch_players!` method
- [x] `#did_player_win?` method
- [x] `#did_tie?` method
- [x] `#are_valid_pieces?` method
- [x] `#build_start_board`
- [x] `#build_board` method
- [ ] `#update!` method
- [ ] TODO

## `ChessMoveRunner` class

This class takes a chess move in Long Algebraic Notation (Long AN or LAN) and does the following with it:
- Checks if the move is valid LAN syntax or not
- Checks if the move is legal based on:
  - The current board state
  - Whose player's (white or black) turn it currently is
  - The move played in the previous turn(s) e.g. for checking if the player can do an en-passant capture.
- Executes the move and modifies the game state (assuming the move is valid LAN and legal).

Complete the following:

- [x] `#initialize` constructor
- [ ] `#is_valid_chess_move?` method
- [ ] `#execute_chess_move!` method
- [x] `#is_valid_piece_char_syntax?` method
- [x] `#is_valid_coords_syntax?` method
- [x] `#is_valid_move_syntax?` method
- [x] `#is_valid_capture_syntax?` method
- [x] `#is_valid_promote_syntax?` method
- [x] `#is_valid_queenside_castle_syntax?` method
- [x] `#is_valid_kingside_castle_syntax?` method
- [x] `#is_valid_syntax?` method
- [x] `#coords_to_matrix_cell` method
- [x] `#piece_char_to_type` method
- [x] `#is_matching_piece?` method
- [x] `#turn_color` method
- [x] `#move_syntax_to_hash` method
- [x] `#capture_syntax_to_hash` method
- [x] `#promote_syntax_to_hash` method
- [x] `#can_move?` method
- [x] `#move!` method
- [x] `#can_capture?` method
- [x] `#capture!` method
- [x] `#must_promote?` method
- [x] `#can_promote?` method
- [x] `#promote!` method
- [x] `#can_queenside_castle?` method
- [x] `#queenside_castle!` method
- [x] `#can_kingside_castle?` method
- [x] `#kingside_castle!` method
- [ ] `#can_capture_en_passant?` method
- [ ] `#capture_en_passant!` method
- [ ] `#set_pawns_non_capturable_en_passant!` method

Complete the tests for the following:

- [x] `#initialize` constructor
- [ ] `#is_valid_chess_move?` method
- [ ] `#execute_chess_move!` method
- [x] `#is_valid_piece_char_syntax?` method
- [x] `#is_valid_coords_syntax?` method
- [x] `#is_valid_move_syntax?` method
- [x] `#is_valid_capture_syntax?` method
- [x] `#is_valid_promote_syntax?` method
- [x] `#is_valid_queenside_castle_syntax?` method
- [x] `#is_valid_kingside_castle_syntax?` method
- [x] `#is_valid_syntax?` method
- [x] `#coords_to_matrix_cell` method
- [x] `#is_matching_piece?` method
- [x] `#move_syntax_to_hash` method
- [x] `#capture_syntax_to_hash` method
- [x] `#promote_syntax_to_hash` method
- [x] `#can_move?` method
- [x] `#move!` method
- [ ] `#can_capture?` method
- [ ] `#capture!` method
- [x] `#must_promote?` method
- [x] `#can_promote?` method
- [x] `#promote!` method
- [ ] `#can_queenside_castle?` method
- [ ] `#queenside_castle!` method
- [ ] `#can_kingside_castle?` method
- [ ] `#kingside_castle!` method
- TODO

## `CommandRunner` class

Complete the following:

- [ ] `#initialize` constructor
- [ ] `#can_start_new_game?` method
- [ ] `#start_new_game!` method
- [ ] `#can_save_game?` method
- [ ] `#save_game!` method
- [ ] `#can_load_game?` method
- [ ] `#load_game!` method
- [ ] `#can_setup?` method
- [ ] `#setup!` method
- [ ] TODO

Complete the tests for the following:

- [ ] TODO

## `ConsoleUI` class

Complete the following:

- [ ] `.initialize` constructor
- [x] `.clear_UI` method
- [ ] `.print_board` method
- [ ] `.print_captured_pieces` method
- [ ] `.print_turn_prompt` method
- [ ] `.print_game_end` method
- [ ] `.print_saves_table` method
- [ ] `.print_load_prompt` method
- [ ] `.print_load_screen` method
- [ ] `.print_setup_screen` method
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
