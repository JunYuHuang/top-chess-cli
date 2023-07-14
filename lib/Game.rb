require './lib/PieceUtils'
require 'set'

class Game
  extend PieceUtils

  attr_accessor(
    :players_count, :current_player_color, :rows, :cols,
    :board, :players, :history, :piece_factory_class
  )

  # TODO - to test
  def initialize(options = {})
    @piece_factory_class = options[:piece_factory_class]
    pieces = options.fetch(:pieces, nil)
    player_class = options.fetch(:player_class, nil)

    @players_count = 2
    @current_player_color = :white
    @players = []

    @rows = self.class.board_length
    @cols = self.class.board_length
    @board = build_start_board

    # `@history` stores an ordered list of game state
    # snapshots represented by hashmaps.
    # Each hashmap has the following key-value pairs:
    # - `:turn_by_color` -> `:white` or `:black`
    #   - denotes which player's turn (by their colour) it was that turn
    # - `:move` -> some string
    #   - denotes the chess move that was played that turn
    # - `:pieces` -> list of piece objects serialized as hashmaps
    #   - represents the current state of the chess board
    #   - each piece hashmap has the following key-value pairs:
    #     - `:cell`: 2-sized int array
    #     - symbols: `:color`, `:type`
    #     - bools: `:is_capturable`, `:did_move`, `:did_double_step`
    # - `:white_captured` -> stores the white player's captured
    #   pieces as a hashmap that maps each piece type symbol to an
    #   non-negative int
    # - `:black_captured` -> stores the black player's captured
    #   pieces as a hashmap that maps each piece type symbol to an
    #   non-negative int

    @history = []

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
    return if @current_player_color.nil?
    # @current_player_color = @current_player_color == :white ? :black : :white
    # nil
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
      return false if piece[:type] == :rook && !has_valid_did_move?(piece)
      return false if piece[:type] == :king && !has_valid_did_move?(piece)
      return false if piece[:type] == :pawn && (
        !has_valid_did_move?(piece) || !has_valid_did_double_step?(piece)
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

    factory = @piece_factory_class
    return factory.create(*black_rook) if (
      row == 0 && rook_cols.include?(col))
    return factory.create(*black_knight) if (
      row == 0 && knight_cols.include?(col))
    return factory.create(*black_bishop) if (
      row == 0 && bishop_cols.include?(col)
    )
    return factory.create(*black_queen) if (
      row == 0 && col == queen_col
    )
    return factory.create(*black_king) if (
      row == 0 && col == king_col
    )
    return factory.create(*black_pawn) if row == 1
    return factory.create(*white_rook) if (
      row == 7 && rook_cols.include?(col))
    return factory.create(*white_knight) if (
      row == 7 && knight_cols.include?(col))
    return factory.create(*white_bishop) if (
      row == 7 && bishop_cols.include?(col)
    )
    return factory.create(*white_queen) if (
      row == 7 && col == queen_col
    )
    return factory.create(*white_king) if (
      row == 7 && col == king_col
    )
    return factory.create(*white_pawn) if row == 6
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
    factory = @piece_factory_class
    pieces.each do |piece|
      row, col = piece[:cell]
      board[row][col] = factory.create(piece[:type], piece)
    end

    board
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

  def has_valid_did_move?(piece_hash)
    did_move = piece_hash.fetch(:did_move, false)
    [true, false].include?(did_move)
  end

  def has_valid_did_double_step?(piece_hash)
    did_double_step = piece_hash.fetch(:did_double_step, false)
    [true, false].include?(did_double_step)
  end
end
