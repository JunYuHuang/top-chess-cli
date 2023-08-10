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
- [x] Add `queenside_castle` method to `KingPiece` class
- [x] Add `kingside_castle` method to `KingPiece` class
- [x] Add `queenside_castle` method to `RookPiece` class
- [x] Add `kingside_castle` method to `RookPiece` class
- [ ] Rename `PieceUtils` module to `ChessUtils`
- [x] Remove `PawnPiece`'s `@did_double_step` instance variable, its affected methods, and updated all other classes that reference it to not use it or depend on `@is_capturable_en_passant` instead
- [ ] Update `KingPiece#is_stalemated?` method to return true only if all pieces of the same color as the king piece itself (including the king) have no valid moves, captures, promotions, en-passant captures, queenside castles, or kingside castles
- [ ] Make `!new` and `!load` commands available to the (human) player while they are in-game
- [ ] Update `ChessMoveRunner` class to accept optional check (`+`) and checkmate (`#`) suffixes for moves and captures when parsing Long AN
- [ ] Update `ConsoleUI` class to let player choose their own color and which opponent type (human or computer) to play against

## `Player` class

Complete the following:

- [x] `::initialize` constructor
- [x] `#game` method
- [x] `#type` method
- [x] `#piece_color` method
- [x] `#name` method
- [x] `#to_s` method
- [x] `#to_hash` method

Complete the tests for the following:
- [x] `#to_s` method
- [x] `#to_hash` method

## `HumanPlayer` class

Complete the following:

- [x] `::initialize` constructor
- [x] `#input` method

Complete the tests for the following:

- [x] `::initialize` constructor

## `ComputerPlayer` class

Complete the following:

- [x] `::initialize` constructor
- [x] `#input` method
- [x] `#random_item` method
- [x] `#random_piece` method
- [x] `#random_chess_move` method
- [x] `#random_capture` method
- [x] `#random_move` method
- [x] `#random_capture_en_passant` method
- [x] `#random_promote` method
- [x] `#queenside_castle` method
- [x] `#kingside_castle` method

Complete the tests for the following:

- [x] `::initialize` constructor
- [x] `#random_item` method
- [x] `#random_piece` method
- [ ] `#random_chess_move` method
- [x] `#random_capture` method
- [x] `#random_move` method
- [ ] `#random_capture_en_passant` method
- [ ] `#random_promote` method
- [ ] `#queenside_castle` method
- [ ] `#kingside_castle` method

## `PieceUtils` module

Complete the following:

- [x] `#is_valid_piece_color?` method
- [x] `#is_valid_piece_type?` method
- [x] `#is_inbound_cell?` method
- [x] `#is_empty_cell?` method
- [x] `#is_ally_cell?` method
- [x] `#is_enemy_cell?` method
- [x] `#deep_copy` method
- [x] `#count_col_cells_amid_two_cells` method
- [x] `#enemy_color` method
- [x] `#move` method
- [x] `#capture` method
- [x] `#board_to_s` method
- [x] `#is_piece_type?` method
- [x] `#is_piece_color?` method
- [x] `#is_matching_piece?` method
- [x] `#is_piece_actionable?` method
- [x] `#pieces` method
- [x] `#remove_pieces` method
- [x] `#in_row?` method
- [x] `#is_left_adjacent?` method
- [x] `#is_right_adjacent?` method
- [x] `#up_adjacent_cell` method
- [x] `#down_adjacent_cell` method
- [x] `#adjacent_cells` method
- [x] `#en_passant_captive_cell` method
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
- [x] `#is_inbound_cell?` method
- [x] `#is_empty_cell?` method
- [x] `#is_ally_cell?` method
- [x] `#is_enemy_cell?` method
- [x] `#deep_copy` method
- [x] `#count_col_cells_amid_two_cells` method
- [x] `#enemy_color` method
- [x] `#move` method
- [x] `#capture` method
- [x] `#board_to_s` method
- [x] `#is_piece_type?` method
- [x] `#is_piece_color?` method
- [x] `#is_matching_piece?` method
- [x] `#is_piece_actionable?` method
- [x] `#pieces` method
- [x] `#remove_pieces` method
- [x] `#in_row?` method
- [x] `#is_left_adjacent?` method
- [x] `#is_right_adjacent?` method
- [x] `#up_adjacent_cell` method
- [x] `#down_adjacent_cell` method
- [x] `#adjacent_cells` method
- [x] `#en_passant_captive_cell` method
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

- [x] `::initialize` constructor
- [x] `#color` method
- [x] `#type` method
- [x] `#is_capturable?` method

## `RookPiece` class (inherits from `Piece`)

Complete the following:

- [x] `::initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#did_move?` method
- [x] `#moved!` method
- [x] `#move` method
- [x] `#capture` method
- [x] `#queenside_castle` method
- [x] `#kingside_castle` method

Complete the tests for the following:

- [x] `::initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#move` method
- [x] `#capture` method
- [x] `#queenside_castle` method
- [x] `#kingside_castle` method

## `BishopPiece` class (inherits from `Piece`)

Complete the following:

- [x] `::initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#move` method
- [x] `#capture` method

Complete the tests for the following:

- [x] `::initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#move` method
- [x] `#capture` method

## `QueenPiece` class (inherits from `Piece`)

Complete the following:

- [x] `::initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#move` method
- [x] `#capture` method

Complete the tests for the following:

- [x] `::initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#move` method
- [x] `#capture` method

## `KnightPiece` class (inherits from `Piece`)

Complete the following:

- [x] `::initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#move` method
- [x] `#capture` method

Complete the tests for the following:

- [x] `::initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#move` method
- [x] `#capture` method

## `PawnPiece` class (inherits from `Piece`)

Complete the following:

- [x] `::initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#captures_en_passant` method
- [x] `#is_capturable_en_passant?` method
- [x] `#set_is_capturable_en_passant!` method
- [x] `#can_capture_en_passant?` method
- [x] `#capture_en_passant` method
- [x] `#did_move?` method
- [x] `#moved!` method
- [x] `#is_double_step_forward?` method
- [x] `#can_promote?` method
- [x] `#promotes` method
- [x] `#black_moves` method (private)
- [x] `#white_moves` method (private)
- [x] `#black_captures` method (private)
- [x] `#white_captures` method (private)
- [x] `#black_captures_en_passant` method (private)
- [x] `#white_captures_en_passant` method (private)
- [x] `#move` method
- [x] `#capture` method
- [x] `#captures_en_passant` method

Complete the tests for the following:

- [x] `::initialize` constructor
- [x] `#moves` method
- [x] `#captures` method
- [x] `#captures_en_passant`
- [x] `#can_capture_en_passant?` method
- [x] `#capture_en_passant` method
- [x] `#is_double_step_forward?` method
- [x] `#can_promote?` method
- [x] `#promotes` method
- [x] `#move` method
- [x] `#capture` method
- [x] `#capture_en_passant` method

## `KingPiece` class (inherits from `Piece`)

Complete the following:

- [x] `::initialize` constructor
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

- [x] `::initialize` constructor
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

- [x] `::initialize` constructor
- [x] `#create` method

Complete the tests for the following:

- [x] `::initialize` constructor
- [x] `#create` method

## `Game` class

Complete the following:

- [x] `::initialize` constructor
- [x] `#add_player!` method
- [x] `#remove_players!` method
- [x] `#play!` method
- [x] `#can_input?` method
- [x] `#execute_input!` method
- [x] `#player` method
- [x] `#can_input?` method
- [x] `#execute_input!` method
- [x] `#switch_players!` method
- [x] `#did_player_win?` method
- [x] `#did_tie?` method
- [x] `#are_valid_pieces?` method
- [x] `#empty_board` method
- [x] `#default_piece_obj` method
- [x] `#build_start_board` method
- [x] `#build_board` method
- [x] `#build_pieces` method
- [x] `#simple_state` method
- [x] `#update!` method
- [x] `#add_captured_piece!` method
- [x] `#last_notice!` method
- [x] `#add_notice!` method
- [x] `#is_valid_piece?` method (private)
- [x] `#is_bool_key?` method (private)

Complete the tests for the following:

- [x] `::initialize` constructor
- [x] `#add_player!` method
- [x] `#remove_players!` method
- [ ] `#can_input?` method
- [ ] `#execute_input!` method
- [x] `#player` method
- [x] `#switch_players!` method
- [x] `#did_player_win?` method
- [x] `#did_tie?` method
- [x] `#are_valid_pieces?` method
- [x] `#build_start_board`
- [x] `#build_board` method
- [x] `#build_pieces` method
- [x] `#simple_state` method
- [ ] `#update!` method
- [x] `#add_captured_piece!` method

## `ChessMoveRunner` class

This class takes a chess move in Long Algebraic Notation (Long AN or LAN) and does the following with it:
- Checks if the move is valid LAN syntax or not
- Checks if the move is legal based on:
  - The current board state
  - Whose player's (white or black) turn it currently is
  - The move played in the previous turn(s) e.g. for checking if the player can do an en-passant capture.
- Executes the move and modifies the game state (assuming the move is valid LAN and legal).

Complete the following:

- [x] `::initialize` constructor
- [x] `#can_chess_move?` method
- [x] `#execute_chess_move!` method
- [x] `#is_valid_piece_char_syntax?` method
- [x] `#is_valid_coords_syntax?` method
- [x] `#is_valid_move_syntax?` method
- [x] `#is_valid_capture_syntax?` method
- [x] `#is_valid_capture_en_passant_syntax?` method
- [x] `#is_valid_promote_syntax?` method
- [x] `#is_valid_queenside_castle_syntax?` method
- [x] `#is_valid_kingside_castle_syntax?` method
- [x] `#is_valid_syntax?` method
- [x] `#coords_to_matrix_cell` method
- [x] `#piece_char_to_type` method
- [x] `#matrix_cell_to_coords` method
- [x] `#piece_type_to_char` method
- [x] `#is_matching_piece?` method
- [x] `#turn_color` method
- [x] `#move_syntax_to_hash` method
- [x] `#capture_syntax_to_hash` method
- [x] `#capture_en_passant_syntax_to_hash` method
- [x] `#promote_syntax_to_hash` method
- [x] `#move_hash_to_syntax` method
- [x] `#capture_hash_to_syntax` method
- [x] `#capture_en_passant_hash_to_syntax` method
- [x] `#promote_hash_to_syntax` method
- [x] `#castle_hash_to_syntax` method
- [x] `#can_move?` method
- [x] `#move!` method
- [x] `#can_capture?` method
- [x] `#capture!` method
- [x] `#can_promote?` method
- [x] `#promote!` method
- [x] `#can_queenside_castle?` method
- [x] `#queenside_castle!` method
- [x] `#can_kingside_castle?` method
- [x] `#kingside_castle!` method
- [x] `#can_capture_en_passant?` method
- [x] `#capture_en_passant!` method
- [x] `#set_enemy_pawns_non_capturable_en_passant!` method

Complete the tests for the following:

- [x] `::initialize` constructor
- [x] `#can_chess_move?` method
- [x] `#execute_chess_move!` method
- [x] `#is_valid_piece_char_syntax?` method
- [x] `#is_valid_coords_syntax?` method
- [x] `#is_valid_move_syntax?` method
- [x] `#is_valid_capture_syntax?` method
- [x] `#is_valid_capture_en_passant_syntax?` method
- [x] `#is_valid_promote_syntax?` method
- [x] `#is_valid_queenside_castle_syntax?` method
- [x] `#is_valid_kingside_castle_syntax?` method
- [x] `#is_valid_syntax?` method
- [x] `#coords_to_matrix_cell` method
- [x] `#matrix_cell_to_coords` method
- [x] `#is_matching_piece?` method
- [x] `#move_syntax_to_hash` method
- [x] `#capture_syntax_to_hash` method
- [x] `#capture_en_passant_syntax_to_hash` method
- [x] `#promote_syntax_to_hash` method
- [x] `#move_hash_to_syntax` method
- [x] `#capture_hash_to_syntax` method
- [x] `#capture_en_passant_hash_to_syntax` method
- [x] `#promote_hash_to_syntax` method
- [x] `#castle_hash_to_syntax` method
- [x] `#can_move?` method
- [x] `#move!` method
- [x] `#can_capture?` method
- [x] `#capture!` method
- [x] `#can_promote?` method
- [x] `#promote!` method
- [x] `#can_queenside_castle?` method
- [x] `#queenside_castle!` method
- [x] `#can_kingside_castle?` method
- [x] `#kingside_castle!` method
- [x] `#can_capture_en_passant?` method
- [x] `#capture_en_passant!` method
- [x] `#set_enemy_pawns_non_capturable_en_passant!` method

## `ConsoleUI` class

Complete the following:

- [x] `::initialize` constructor
- [x] `#clear_UI` method
- [x] `#print_board` method
- [x] `#print_captured_pieces` method
- [x] `#print_turn_prompt` method
- [x] `#print_game_end` method
- [x] `#print_saves_table` method
- [x] `#print_load_prompt` method
- [x] `#print_load_screen` method
- [ ] `#print_setup_screen` method
- [x] `#print_turn_screen` method
- [x] `#print_end_screen` method
- [x] `#row_to_rank` method (protected)
- [x] `#is_dark_cell?` method (protected)
- [x] `#empty_cell_str` method (protected)
- [x] `#piece_cell_str` method (protected)
- [x] `#rank_str` method (protected)
- [x] `#captured_piece_str` method (protected)

## `CommandRunner` class

Complete the following:

- [x] `::initialize` constructor
- [x] `#set_load_mode!` method
- [x] `#set_setup_mode!` method
- [x] `#set_in_game_mode!` method
- [x] `#set_post_game_mode!` method
- [x] `#game_meets_prereqs?` method
- [x] `#can_command?` method
- [x] `#execute_command!` method
- [x] `#can_new_game?` method
- [x] `#new_game!` method
- [x] `#can_save_game?` method
- [x] `#save_game!` method
- [x] `#can_load_game?` method
- [x] `#load_game!` method
<!-- - [ ] `#can_pick_enemy_type?` method -->
<!-- - [ ] `#can_pick_color?` method -->
<!-- - [ ] `#setup_game!` method -->

Complete the tests for the following:

- [x] `#game_meets_prereqs?` method
- [ ] `#can_command?` method
- [ ] `#execute_command!` method
- [x] `#can_new_game?` method
- [x] `#new_game!` method
- [x] `#can_save_game?` method
- [x] `#save_game!` method
- [x] `#can_load_game?` method
- [x] `#load_game!` method

## `GameSave` class

Complete the following:

- [x] `::initialize` constructor
- [x] `#save_exists?` method
- [x] `#count_saves` method
- [x] `#saves_list` method
- [x] `#create_save` method
- [x] `#open_save` method
- [x] `#saves_folder_exists?` method (protected)
- [x] `#create_saves_folder` method (protected)
- [x] `#unique_save_id` method (protected)
- [x] `#encode` method (protected)
- [x] `#decode` method (protected)

Complete the tests for the following:

- [x] `::initialize` constructor
- [x] `#save_exists?` method
- [x] `#count_saves` method
- [x] `#saves_list` method
- [x] `#create_save` method
- [x] `#open_save` method
