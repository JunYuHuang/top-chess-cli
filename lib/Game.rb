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
    # - `:piece_color` -> `:white` or `:black`
    #   - denotes which player's turn (by their colour) it was that turn
    # - `:move` -> some string
    #   - denotes the chess move that was played that turn
    # - `:pieces` -> list of piece objects serialized as hashmaps
    #   - represents the current state of the chess board
    #   - each piece hashmap has the following key-value pairs:
    # - `:cell`: 2-sized int array that represents the current
    #     position or coordinates of the piece on the 0-indexed
    #     matrix that represents the chess board. Represented in
    #     the format `[row, col]`. E.g., `[0,0]` represents the
    #     top-left corner square of the chess board at `a8`.
    # - `:type`: symbol that represents 1 of the 6 types of
    #     chess pieces (e.g. `:pawn` for Pawn pieces)
    # - `:color`: self explanatory
    # - `:is_capturable`: boolean flag that represents if the
    #     piece can be captured or not. True for all pieces
    #     except for King pieces.
    # - `:did_move` (piece-specific): boolean flag for Pawn,
    #     King, and Rook pieces
    # - `:did_double_step` (piece-specific): boolean flag for
    #     Pawn pieces
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

  # TODO - to test
  def are_valid_pieces?(pieces)
    return false if pieces.class != Array
    return false if pieces.size != @rows * @cols / 2
    return false if piece.any? { |el| el.class != Hash }

    pieces.each do |piece|
      return false unless is_valid_piece?(piece)
      return false if (
        !is_valid_pawn_piece?(piece) &&
        !is_valid_rook_piece?(piece)
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

  # TODO - to test
  def build_board(pieces)
    # TODO
  end

  private

  # TODO - to test
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

  # TODO - to test
  def is_valid_pawn_piece?(piece_hash)
    did_move = piece_hash.fetch(:did_move, nil)
    did_double_step = piece_hash.fetch(:did_double_step, nil)
    values = [nil, true, false]
    return false unless values.include?(did_move)
    return false unless values.include?(did_double_step)
    true
  end

  # TODO - to test
  # same as for checking if `piece_hash` is a valid king piece
  def is_valid_rook_piece?(piece_hash)
    did_move = piece_hash.fetch(:did_move, nil)
    values = [nil, true, false]
    return false unless values.include?(did_move)
    true
  end
end
