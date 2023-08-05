require './lib/Game'
require './lib/PieceFactory'
require './lib/ChessMoveRunner'
require './lib/HumanPlayer'
require './lib/ConsoleUI'
require './lib/GameSave'
require './lib/CommandRunner'

dependencies = {
  piece_factory_class: PieceFactory,
  chess_move_runner_class: ChessMoveRunner,
  console_ui_class: ConsoleUI,
  player_class: HumanPlayer,
  human_player_class: HumanPlayer,
  game_save_class: GameSave,
  command_runner_class: CommandRunner,
}
game = Game.new(dependencies)
game.load!
game.play!
