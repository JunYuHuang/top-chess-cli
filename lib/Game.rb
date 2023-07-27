require './lib/PieceUtils'
require 'set'

class Game
  extend PieceUtils

  attr_accessor(
    :players_count, :current_player_color, :rows, :cols,
    :board, :players, :white_captured, :black_captured,
    :piece_factory, :chess_move_runner, :console_ui
  )

  # TODO - to test
  def initialize(options = {})
    @piece_factory = options[:piece_factory_class]
    @chess_move_runner = options[:chess_move_runner_class]
    @console_ui = options.fetch(:console_ui_class, nil)
    pieces = options.fetch(:pieces, nil)
    player_class = options.fetch(:player_class, nil)

    @players_count = 2
    @current_player_color = :white
    @players = []
    @white_captured = {}
    @black_captured = {}

    @rows = self.class.board_length
    @cols = self.class.board_length
    @board = build_start_board

    if !pieces.nil? && are_valid_pieces?(pieces)
      @board = build_board(pieces)
    end

    if player_class
      @players_count.times do |i|
        @players.push(player_class.new(
          self,
          "Player #{@players.size + 1}",
          @players.empty? ? :white : :black
        ))
      end
    end
  end

  def add_player!(player_class)
    return if @players.size >= @players_count
    @players.push(player_class.new(
      self,
      "Player #{@players.size + 1}",
      @players.empty? ? :white : :black
    ))
  end

  # TODO - to test
  def play
    return if @players.size != @players_count
    # TODO
  end

  def player(color)
    return nil if @players.size != @players_count
    res = @players.filter { |player| player.piece_color == color }
    res[0]
  end

  def switch_players!
    return if @players.size != @players_count
    return if @current_player_color.nil?
    @current_player_color = @current_player_color == :white ? :black : :white
    true
  end

  def did_player_win?(player_color)
    return false if @players.size != @players_count
    return false unless self.class.is_valid_piece_color?(player_color)

    enemy_color = player_color == :white ? :black : :white
    filters = { color: enemy_color, type: :king }
    enemy_king = self.class.pieces(@board, filters)[0]
    enemy_king[:piece].is_checkmated?(enemy_king[:cell], @board)
  end

  def did_tie?
    return false if @players.size != @players_count

    # return true if white king is stalemated
    white_king = self.class.pieces(@board, {
      color: :white, type: :king
    })[0]
    return true if white_king[:piece].is_stalemated?(
      white_king[:cell],
      @board
    )

    # return true if black king is stalemated
    black_king = self.class.pieces(@board, {
      color: :black, type: :king
    })[0]
    return true if black_king[:piece].is_stalemated?(
      black_king[:cell],
      @board
    )

    false
  end

  # TODO - to test
  def use_chess_move_runner(chess_move_runner_class)
    return if @chess_move_runner
    @chess_move_runner = chess_move_runner_class.new(self)
  end

  def are_valid_pieces?(pieces)
    return false if pieces.class != Array
    return false if pieces.size > @rows * @cols / 2
    return false if pieces.any? { |el| el.class != Hash }

    # Note that we only need to specifically check if the piece is a
    # Pawn or Rook or King because the 3 other piece types have no
    # additional properties.
    basic_piece_types = [:knight, :bishop, :queen]
    pieces.each do |piece|
      return false unless is_valid_piece?(piece)
      next if basic_piece_types.include?(piece[:type])
      return false if (
        piece[:type] == :rook && !is_bool_key?(piece, :did_move)
      )
      return false if (
        piece[:type] == :king && !is_bool_key?(piece, :did_move)
      )
      return false if piece[:type] == :pawn && (
        !is_bool_key?(piece, :did_move) ||
        !is_bool_key?(piece, :is_capturable_en_passant)
      )
    end

    true
  end

  def empty_board
    Array.new(@rows) { Array.new(@cols, nil) }
  end

  def default_piece_obj(cell)
    row, col = cell
    rook_cols = Set.new([0, 7])
    knight_cols = Set.new([1, 6])
    bishop_cols = Set.new([2, 5])
    queen_col = 3
    king_col = 4
    white_pawn = [:pawn, { color: :white }]
    white_rook = [:rook, { color: :white }]
    white_knight = [:knight, { color: :white }]
    white_bishop = [:bishop, { color: :white }]
    white_queen = [:queen, { color: :white }]
    white_king = [:king, { color: :white }]
    black_pawn = [:pawn, { color: :black }]
    black_rook = [:rook, { color: :black }]
    black_knight = [:knight, { color: :black }]
    black_bishop = [:bishop, { color: :black }]
    black_queen = [:queen, { color: :black }]
    black_king = [:king, { color: :black }]

    return @piece_factory.create(*black_rook) if (
      row == 0 && rook_cols.include?(col))
    return @piece_factory.create(*black_knight) if (
      row == 0 && knight_cols.include?(col))
    return @piece_factory.create(*black_bishop) if (
      row == 0 && bishop_cols.include?(col)
    )
    return @piece_factory.create(*black_queen) if (
      row == 0 && col == queen_col
    )
    return @piece_factory.create(*black_king) if (
      row == 0 && col == king_col
    )
    return @piece_factory.create(*black_pawn) if row == 1
    return @piece_factory.create(*white_rook) if (
      row == 7 && rook_cols.include?(col))
    return @piece_factory.create(*white_knight) if (
      row == 7 && knight_cols.include?(col))
    return @piece_factory.create(*white_bishop) if (
      row == 7 && bishop_cols.include?(col)
    )
    return @piece_factory.create(*white_queen) if (
      row == 7 && col == queen_col
    )
    return @piece_factory.create(*white_king) if (
      row == 7 && col == king_col
    )
    return @piece_factory.create(*white_pawn) if row == 6
  end

  def build_start_board
    board = empty_board
    rows_with_pieces = Set.new([0, 1, 6, 7])

    @rows.times do |r|
      @cols.times do |c|
        next unless rows_with_pieces.include?(r)
        board[r][c] = default_piece_obj([r, c])
      end
    end
    board
  end

  def build_board(pieces)
    board = empty_board
    pieces.each do |piece|
      row, col = piece[:cell]
      board[row][col] = @piece_factory.create(piece[:type], piece)
    end

    board
  end

  # TODO - to test
  def update!(state)
    state => {
      current_player_color:,
      board:,
      players:,
      history:
    }
    @current_player_color = current_player_color
    @board = build_board(board)
    # TODO - figure out how to deserialize players array and update it
    # TODO - figure out how to deserialize history array and update it
  end

  # TODO - to test
  def use_console_ui(console_ui_class)
    return if @console_ui
    @console_ui = console_ui_class.new(self)
  end

  # TODO - to test
  def use_game_saves(args)
    # TODO
  end

  # TODO - to test
  def add_captured_piece!(piece_obj)
    # TODO
  end

  private

  def is_valid_piece?(piece_hash)
    cell = piece_hash.fetch(:cell, nil)
    color = piece_hash.fetch(:color, nil)
    type = piece_hash.fetch(:type, nil)
    is_capturable = piece_hash.fetch(:is_capturable, nil)

    return false if cell.nil? or color.nil? or type.nil? or is_capturable.nil?
    return false if cell.class != Array
    return false if cell.size != 2

    row, col = cell
    return false if row.class != Integer or col.class != Integer
    return false unless self.class.is_inbound_cell?(cell)
    return false unless self.class.is_valid_piece_color?(color)
    return false unless self.class.is_valid_piece_type?(type)
    return false unless [true, false].include?(is_capturable)
    true
  end

  def is_bool_key?(hash, key)
    key = hash.fetch(key, false)
    [true, false].include?(key)
  end
end
