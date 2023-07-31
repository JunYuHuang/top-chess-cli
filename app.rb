require './lib/Game'
require './lib/PieceFactory'
require './lib/ChessMoveRunner'
require './lib/HumanPlayer'
require './lib/ConsoleUI'

options = {
  piece_factory_class: PieceFactory,
  chess_move_runner_class: ChessMoveRunner,
  console_ui_class: ConsoleUI,
  player_class: HumanPlayer,
}
game = Game.new(options)
game.play!
