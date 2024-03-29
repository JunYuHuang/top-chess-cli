require './lib/PieceUtils'
require 'set'

class Game
  START_STATE = {
    turn_color: :white,
    players: [
      {
        piece_color: :white, type: :human,
        name: "WHITE (Human Player 1)"
      },
      {
        piece_color: :black, type: :human,
        name: "BLACK (Human Player 2)"
      }
    ],
    pieces: [
      {
        cell: [0,0], color: :black, type: :rook,
        is_capturable: true,
      },
      {
        cell: [0,7], color: :black, type: :rook,
        is_capturable: true,
      },
      {
        cell: [0,1], color: :black, type: :knight,
        is_capturable: true,
      },
      {
        cell: [0,6], color: :black, type: :knight,
        is_capturable: true,
      },
      {
        cell: [0,2], color: :black, type: :bishop,
        is_capturable: true,
      },
      {
        cell: [0,5], color: :black, type: :bishop,
        is_capturable: true,
      },
      {
        cell: [0,3], color: :black, type: :queen,
        is_capturable: true,
      },
      {
        cell: [0,4], color: :black, type: :king,
        is_capturable: false,
      },
      {
        cell: [1,0], color: :black, type: :pawn,
        is_capturable: true,
      },
      {
        cell: [1,1], color: :black, type: :pawn,
        is_capturable: true,
      },
      {
        cell: [1,2], color: :black, type: :pawn,
        is_capturable: true,
      },
      {
        cell: [1,3], color: :black, type: :pawn,
        is_capturable: true,
      },
      {
        cell: [1,4], color: :black, type: :pawn,
        is_capturable: true,
      },
      {
        cell: [1,5], color: :black, type: :pawn,
        is_capturable: true,
      },
      {
        cell: [1,6], color: :black, type: :pawn,
        is_capturable: true,
      },
      {
        cell: [1,7], color: :black, type: :pawn,
        is_capturable: true,
      },
      # white pieces
      {
        cell: [7,0], color: :white, type: :rook,
        is_capturable: true,
      },
      {
        cell: [7,7], color: :white, type: :rook,
        is_capturable: true,
      },
      {
        cell: [7,1], color: :white, type: :knight,
        is_capturable: true,
      },
      {
        cell: [7,6], color: :white, type: :knight,
        is_capturable: true,
      },
      {
        cell: [7,2], color: :white, type: :bishop,
        is_capturable: true,
      },
      {
        cell: [7,5], color: :white, type: :bishop,
        is_capturable: true,
      },
      {
        cell: [7,3], color: :white, type: :queen,
        is_capturable: true,
      },
      {
        cell: [7,4], color: :white, type: :king,
        is_capturable: false,
      },
      {
        cell: [6,0], color: :white, type: :pawn,
        is_capturable: true,
      },
      {
        cell: [6,1], color: :white, type: :pawn,
        is_capturable: true,
      },
      {
        cell: [6,2], color: :white, type: :pawn,
        is_capturable: true,
      },
      {
        cell: [6,3], color: :white, type: :pawn,
        is_capturable: true,
      },
      {
        cell: [6,4], color: :white, type: :pawn,
        is_capturable: true,
      },
      {
        cell: [6,5], color: :white, type: :pawn,
        is_capturable: true,
      },
      {
        cell: [6,6], color: :white, type: :pawn,
        is_capturable: true,
      },
      {
        cell: [6,7], color: :white, type: :pawn,
        is_capturable: true,
      },
    ],
    white_captured: {},
    black_captured: {}
  }

  extend PieceUtils

  attr_accessor(
    :players_count, :turn_color, :rows, :cols,
    :board, :players, :white_captured, :black_captured,
    :piece_factory, :chess_move_runner, :console_ui,
    :human_player_class, :computer_player_class, :game_save,
    :command_runner, :notices
  )

  def initialize(options = {})
    @piece_factory = options[:piece_factory_class]
    console_ui_class = options.fetch(:console_ui_class, nil)
    chess_move_runner_class = options.fetch(
      :chess_move_runner_class, nil
    )
    pieces = options.fetch(:pieces, nil)
    player_class = options.fetch(:player_class, nil)
    @human_player_class = options.fetch(:human_player_class, nil)
    @computer_player_class = options.fetch(:computer_player_class, nil)
    game_save_class = options.fetch(:game_save_class, nil)
    command_runner_class = options.fetch(:command_runner_class, nil)

    @players_count = 2
    @turn_color = options.fetch(:turn_color, :white)
    @players = []
    @white_captured = options.fetch(:white_captured, {})
    @black_captured = options.fetch(:black_captured, {})

    @rows = self.class.board_length
    @cols = self.class.board_length
    @board = build_start_board
    @notices = []

    if !pieces.nil? && are_valid_pieces?(pieces)
      @board = build_board(pieces)
    end

    if player_class
      @players_count.times do |i|
        new_player = player_class.new({
          game: self,
          type: :human,
          piece_color: @players.empty? ? :white : :black
        })
        new_name = [
          "#{new_player.piece_color.to_s.upcase} (",
          "#{new_player.type.to_s.capitalize} Player ",
          "#{@players.size + 1})"
        ]
        new_player.name = new_name.join('')
        @players.push(new_player)
      end
    end

    if chess_move_runner_class
      @chess_move_runner = chess_move_runner_class.new(self)
    end

    if console_ui_class
      @console_ui = console_ui_class.new(self)
    end

    if game_save_class
      @game_save = game_save_class.new({ game: self })
    end

    if command_runner_class
      @command_runner = command_runner_class.new({ game: self })
    end
  end

  def add_player!(player_class, options = {})
    return if @players.size >= @players_count

    type = options.fetch(:type, nil)
    piece_color = options.fetch(:piece_color, nil)
    name = options.fetch(:name, nil)
    default_color = @players.empty? ? :white : :black

    new_player = player_class.new({
      game: self,
      type: type ? type : :human,
      piece_color: piece_color ? piece_color : default_color
    })
    if name
      new_player.name = name
    else
      new_name = [
        "#{new_player.piece_color.to_s.upcase} (",
        "#{new_player.type.to_s.capitalize} Player ",
        "#{@players.size + 1})"
      ]
      new_player.name = new_name.join('')
    end
    @players.push(new_player)
    new_player
  end

  def remove_players!(filters)
    return if @players.empty? or filters.class != Hash

    def passes_filters(filters, player_obj)
      type = filters.fetch(:type, nil)
      piece_color = filters.fetch(:piece_color, nil)
      name = filters.fetch(:name, nil)

      return false if type && type != player_obj.type
      return false if piece_color && piece_color != player_obj.piece_color
      return false if name && name != player_obj.name
      true
    end

    @players.filter! {
      |player_obj| !passes_filters(filters, player_obj)
    }
  end

  def is_enemy_type?(type)
    ["computer", "human"].include?(type)
  end

  def is_color?(color)
    ["white", "black"].include?(color)
  end

  def setup!
    return if @game_save.nil? or @command_runner.nil?
    return if @human_player_class.nil?
    return if @computer_player_class.nil?

    args = { color: "", is_color: true, enemy: "", is_enemy: true }

    loop do
      @console_ui.print_setup_screen(args)
      args[:color] = gets.chomp
      if is_color?(args[:color])
        args[:is_color] = true
        break
      end
      args[:is_color] = false
    end

    loop do
      @console_ui.print_setup_screen(args)
      args[:enemy] = gets.chomp
      if is_enemy_type?(args[:enemy])
        args[:is_enemy] = true
        break
      end
      args[:is_enemy] = false
    end

    player_1_hash = {
      piece_color: args[:color].to_sym,
      type: :human,
      name: "#{args[:color].upcase} (Human Player 1)"
    }
    enemy_color = args[:color] == "white" ? "black" : "white"
    player_2_hash = {
      piece_color: enemy_color.to_sym,
      type: args[:enemy].to_sym,
      name: "#{enemy_color.upcase} (#{args[:enemy].capitalize} Player 2)"
    }
    new_state = self.class.deep_copy(START_STATE)
    new_state[:players] = [player_1_hash, player_2_hash]
    update!(new_state)
  end

  def load!
    return if @game_save.nil? or @command_runner.nil?
    @command_runner.set_in_game_mode!
    return if @human_player_class.nil?

    if @game_save.count_saves < 1
      setup!
      return
    end

    @command_runner.set_load_mode!
    last_input = ""
    is_valid_input = true
    loop do
      @console_ui.print_load_screen(is_valid_input, last_input)
      last_input = gets.chomp
      if @command_runner.can_command?(last_input)
        @command_runner.execute_command!(last_input)
        break
      end
      is_valid_input = false
    end
  end

  def play!
    return if @players.size != @players_count

    @command_runner.set_in_game_mode!
    add_notice!("✅ Started a new game.") if @notices.empty?

    loop do
      if did_tie?
        @console_ui.print_end_screen
        return
      elsif did_player_win?(:white)
        @console_ui.print_end_screen(:white)
        return
      elsif did_player_win?(:black)
        @console_ui.print_end_screen(:black)
        return
      end

      current_player = player(@turn_color)
      execute_input!(current_player.input)
    end
  end

  def can_input?(input)
    return false if @players.size != @players_count
    return false if @chess_move_runner.nil? or @console_ui.nil?
    return true if @chess_move_runner.can_chess_move?(input)
    return false if @command_runner.nil?
    return true if @command_runner.can_command?(input)
    false
  end

  def execute_input!(input)
    return if @players.size != @players_count
    return if @chess_move_runner.nil? or @console_ui.nil?

    # Update the white or black captured pieces state
    # if the chess move will remove a piece from the board.
    if @chess_move_runner.can_capture?(input)
      res = @chess_move_runner.capture_syntax_to_hash(input)
      add_captured_piece!(res[:dst_cell])
    elsif @chess_move_runner.can_capture_en_passant?(input)
      res = @chess_move_runner.capture_en_passant_syntax_to_hash(input)
      captive_cell = self.class.en_passant_captive_cell(
        res[:dst_cell], @turn_color
      )
      add_captured_piece!(captive_cell)
    elsif @chess_move_runner.can_promote?(input)
      res = @chess_move_runner.promote_syntax_to_hash(input)
      is_empty = self.class.is_empty_cell?(res[:dst_cell], @board)
      add_captured_piece!(res[:dst_cell]) unless is_empty
    end

    if @chess_move_runner.can_chess_move?(input)
      @chess_move_runner.execute_chess_move!(input)
      @chess_move_runner.set_enemy_pawns_non_capturable_en_passant!(self.class.enemy_color(@turn_color))
      add_notice!(
        "👉 #{player(@turn_color).name} played the move '#{input}'."
      )
      switch_players!
    elsif @command_runner.can_command?(input)
      @command_runner.execute_command!(input)
    end
  end

  def player(color)
    return nil if @players.size != @players_count
    res = @players.filter { |player| player.piece_color == color }
    res[0]
  end

  def switch_players!
    return if @players.size != @players_count
    return if @turn_color.nil?
    @turn_color = self.class.enemy_color(@turn_color)
    true
  end

  def did_player_win?(player_color = @turn_color)
    return false if @players.size != @players_count
    return false unless self.class.is_valid_piece_color?(player_color)

    filters = {
      color: self.class.enemy_color(player_color), type: :king
    }
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

  def are_valid_pieces?(pieces)
    return false if pieces.class != Array
    return false if pieces.size > @rows * @cols / 2
    return false if pieces.any? { |el| el.class != Hash }

    # Note that we only need to specifically check if the piece
    # is a Pawn or Rook or King because the 3 other piece types
    # have no additional properties.
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

  # assumes board is valid
  def build_pieces(board = @board)
    return unless board

    def to_piece_hash(cell, board)
      return if cell.nil? or board.nil?

      row, col = cell
      piece_obj = board[row][col]
      piece_hash = {
        cell: [row, col],
        color: piece_obj.color,
        type: piece_obj.type,
        is_capturable: piece_obj.is_capturable?
      }
      if piece_obj.respond_to?(:did_move?)
        piece_hash[:did_move] = piece_obj.did_move?
      end
      if piece_obj.respond_to?(:is_capturable_en_passant?)
        piece_hash[:is_capturable_en_passant] = piece_obj.is_capturable_en_passant?
      end
      piece_hash
    end

    pieces = []
    @rows.times do |r|
      @cols.times do |c|
        next if self.class.is_empty_cell?([r,c], board)
        pieces.push(to_piece_hash([r,c], board))
      end
    end
    pieces
  end

  def simple_state
    return if @players.size != @players_count

    {
      turn_color: @turn_color,
      players: [
        player(:white).to_hash,
        player(:black).to_hash,
      ],
      pieces: build_pieces(@board),
      white_captured: {
        pawn: @white_captured.fetch(:pawn, 0),
        rook: @white_captured.fetch(:rook, 0),
        knight: @white_captured.fetch(:knight, 0),
        bishop: @white_captured.fetch(:bishop, 0),
        queen: @white_captured.fetch(:queen, 0),
      },
      black_captured: {
        pawn: @black_captured.fetch(:pawn, 0),
        rook: @black_captured.fetch(:rook, 0),
        knight: @black_captured.fetch(:knight, 0),
        bishop: @black_captured.fetch(:bishop, 0),
        queen: @black_captured.fetch(:queen, 0),
      }
    }
  end

  def update!(state)
    state => {
      turn_color:,
      players:,
      pieces:,
      white_captured:,
      black_captured:,
    }
    @turn_color = turn_color
    @players = []
    players.each do |player_hash|
      right_player_class = player_hash[:type] == :human ?
        @human_player_class :
        @computer_player_class
      player_obj = right_player_class.new({
        game: self,
        piece_color: player_hash[:piece_color],
        type: player_hash[:type],
        name: player_hash[:name]
      })
      @players.push(player_obj)
    end
    @board = build_board(pieces)
    @white_captured = white_captured
    @black_captured = black_captured
  end

  def add_captured_piece!(captive_cell)
    return unless self.class.is_inbound_cell?(captive_cell)
    return if self.class.is_empty_cell?(captive_cell, @board)

    row, col = captive_cell
    piece = @board[row][col]
    if piece.color == :white
      count = @black_captured.fetch(piece.type, 0)
      @black_captured[piece.type] = count + 1
    else
      count = @white_captured.fetch(piece.type, 0)
      @white_captured[piece.type] = count + 1
    end
  end

  def last_notice!
    @notices.pop
  end

  def add_notice!(notice_msg)
    @notices.push(notice_msg)
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
