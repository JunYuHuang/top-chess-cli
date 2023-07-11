require './lib/PieceUtils'

class Game
  include PieceUtils

  attr_accessor(
    :players_count, :current_player_piece, :board, :players
  )

  # TODO - to test
  def initialize(board = nil, player_class = nil)
    @players_count = 2
    @current_player_piece = nil
    @board = self.class.is_valid_board?(board) ? board : self.class.start_board
    @players = []

    return unless player_class

    @players_count.times do |i|
      @players.push(player_class.new(
        self,
        "Player #{@players.size + 1}",
        @players.empty? ? :white : :black
      ))
    end
  end

  # TODO - to test
  def add_player(player_class)
    return if @players.size >= @players_count
    @players.push(player_class.new(
      self,
      "Player #{@players.size + 1}",
      @players.empty? ? :white : :black
    ))
  end

  # TODO - to test
  def update!(options)
    # TODO
  end

  # TODO - to test
  def play
    return if @players.size != @players_count
    # TODO
  end

  # TODO - to test
  def player(filters)
    return nil if @players.size != @players_count
    # TODO
  end

  # TODO - to test
  def switch_players!
    return if @players.size != @players_count
    return if @current_player_piece.nil?
    @current_player_piece = @current_player_piece == :white ? :black : :white
    nil
  end

  # TODO - to test
  def is_valid_move?(options)
    # TODO
  end

  # TODO - to test
  def move!(options)
    # TODO
  end

  # TODO - to test
  def is_valid_capture?(options)
    # TODO
  end

  # TODO - to test
  def capture!(options)
    # TODO
  end

  # TODO - to test
  def can_promote?(args)
    # TODO
  end

  # TODO - to test
  def promote!(args)
    # TODO
  end

  # TODO - to test
  def is_valid_castle?(args)
    # TODO
  end

  # TODO - to test
  def castle!(args)
    # TODO
  end

  # TODO - to test
  def is_valid_capture_en_passant?(args)
    # TODO
  end

  # TODO - to test
  def capture_en_passant!(args)
    # TODO
  end

  # TODO - to test
  def did_player_win?(player)
    return false if @players.size != @players_count

    # TODO
    false
  end

  # TODO - to test
  def use_game_saves(args)
    # TODO
  end

  # TODO - to test
  def use_console_ui(args)
    # TODO
  end

  # TODO - to test
  def use_chess_move_runner(args)
    # TODO
  end

  # TODO - to test
  def use_command_runner(args)
    # TODO
  end

  # TODO - to test
  def is_last_move_enemy_pawn_2_step(args)
    # TODO
  end

  private

  def self.is_valid_board?(board, rows = 8, cols = 8)
    return false if board.class != Array
    return false if board.size != rows
    return false if board.any? { |el| el.class != Array }
    return false if board.any? { |el| el.size != cols }

    # board.each do |col|
    #   return false if col.any? { |cell| !@@valid_pieces.include?(cell) }
    # end

    # TODO - return false if any cell is not `nil` or a `Piece` subclass object / instance

    true
  end

  # TODO - to test
  def self.empty_board(rows = 8, cols = 8)
    Array.new(rows) { Array.new(cols, nil) }
  end

  # TODO - to test
  def self.start_board(rows = 8, cols = 8)
    Array.new(rows) { Array.new(cols, nil) }
  end
end
