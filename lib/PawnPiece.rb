require './lib/Piece'
require './lib/PieceUtils'

class PawnPiece < Piece
  extend PieceUtils

  attr_accessor(
    :default_options, :did_move, :did_double_step, :one_step, :two_steps
  )

  @@one_step = { max_steps: 1 }

  @@two_steps = { max_steps: 2 }

  def initialize(options = {})
    default_options = {
      color: :white,
      did_move: false,
      did_double_step: false
    }

    options = default_options.merge(options)
    passed_options = {
      color: options.fetch(:color, @@default_options[:color]),
      type: :pawn,
      is_capturable: true
    }

    super(passed_options)
    @did_move = options[:did_move]
    @did_double_step = options[:did_double_step]
  end

  def moves(src_cell, board)
    return [] unless self.class.is_valid_piece_color?(@color)
    @color == :white ?
      white_moves(src_cell, board) :
      black_moves(src_cell, board)
  end

  def captures(src_cell, board)
    return [] unless self.class.is_valid_piece_color?(@color)
    @color == :white ?
      white_captures(src_cell, board) :
      black_captures(src_cell, board)
  end

  def can_capture_en_passant?(args, &is_proper_last_move)
    src_cell = args.fetch(:src_cell, nil)
    captive_cell = args.fetch(:captive_cell, nil)
    board = args.fetch(:board, nil)
    return false if src_cell.nil? or captive_cell.nil? or board.nil?
    return false unless self.class.is_inbound_cell?(src_cell)
    return false if self.class.is_empty_cell?(src_cell, board)
    return false unless self.class.is_inbound_cell?(captive_cell)
    return false if self.class.is_empty_cell?(captive_cell, board)
    return false unless self.class.is_valid_piece_color?(@color)
    return false unless self.class.is_enemy_piece_cell?(src_cell, captive_cell, board)
    return false unless self.class.is_piece_type?(src_cell, board, :pawn)
    return false unless self.class.is_piece_color?(src_cell, board, @color)
    return false unless self.class.is_piece_type?(captive_cell, board, :pawn)

    cap_row, cap_col = captive_cell
    return false unless self.class.in_row?(src_cell, cap_row)
    return false unless block_given?

    @color == :white ?
      can_white_capture_en_passant?(args, &is_proper_last_move) :
      can_black_capture_en_passant?(args, &is_proper_last_move)
  end

  # returns dest. cell (not captive pawn cell) of pawn capturer
  def capture_en_passant(args, &is_proper_last_move)
    src_cell = args.fetch(:src_cell, nil)
    captive_cell = args.fetch(:captive_cell, nil)
    board = args.fetch(:board, nil)
    return if src_cell.nil? or captive_cell.nil? or board.nil?
    return unless self.class.is_valid_piece_color?(@color)
    return unless can_capture_en_passant?(args, &is_proper_last_move)

    @color == :white ?
      white_capture_en_passant(args, &is_proper_last_move) :
      black_capture_en_passant(args, &is_proper_last_move)
  end

  def did_move?
    @did_move
  end

  def moved!
    return if @did_move
    @did_move = true
  end

  def is_promotable?(src_cell, board)
    return false unless self.class.is_inbound_cell?(src_cell)
    return false if self.class.is_empty_cell?(src_cell, board)

    src_row, src_col = src_cell
    filter = { row: src_row, col: src_col }
    pieces = self.class.pieces(board, filter)
    return false if pieces.size != 1

    itself_on_board = pieces[0]
    return false if itself_on_board[:piece] != self
    return false unless self.class.is_valid_piece_color?(@color)

    @color == :white ?
      src_row == 1 :
      src_row == self.class.board_length - 2
  end

  def is_valid_promotion?(piece_type)
    self.class.is_valid_promotion?(piece_type)
  end

  def is_double_step?(src_cell, dst_cell, board)
    return false unless moves(src_cell, board).include?(dst_cell)
    cells = [src_cell, dst_cell]
    self.class.count_col_cells_amid_two_cells(*cells) == 1
  end

  def did_double_step?
    @did_double_step
  end

  def double_stepped!
    return if @did_double_step
    @did_double_step = true
  end

  def move(src_cell, dst_cell, board)
    args = {
      src_cell: src_cell, dst_cell: dst_cell,
      board: board, piece_obj: self
    }
    self.class.move(args)
  end

  def capture(src_cell, dst_cell, board)
    args = {
      src_cell: src_cell, dst_cell: dst_cell,
      board: board, piece_obj: self,
      en_passant_cap_cell: nil
    }

    # indicates that it is an en-passant capture
    # assumes last move was the correct enemy pawn double step for en-passant captures
    if self.class.is_empty_cell?(dst_cell, board)
      args[:en_passant_cap_cell] = @color == :white ?
        self.class.down_adjacent_cell(dst_cell) :
        self.class.up_adjacent_cell(dst_cell)
    end

    self.class.capture(args)
  end

  private

  def white_moves(src_cell, board)
    options = did_move? ? @@one_step : @@two_steps
    self.class.up_moves(src_cell, board, options)
  end

  def black_moves(src_cell, board)
    options = did_move? ? @@one_step : @@two_steps
    self.class.down_moves(src_cell, board, options)
  end

  def white_captures(src_cell, board)
    res = [
      self.class.up_left_capture(src_cell, board, @@one_step),
      self.class.up_right_capture(src_cell, board, @@one_step),
    ]
    res.filter { |cell| !cell.nil? }
  end

  def black_captures(src_cell, board)
    res = [
      self.class.down_left_capture(src_cell, board, @@one_step),
      self.class.down_right_capture(src_cell, board, @@one_step),
    ]
    res.filter { |cell| !cell.nil? }
  end

  def can_white_capture_en_passant_left?(args, &is_proper_last_move)
    args => { src_cell:, captive_cell:, board: }

    return false unless self.class.in_row?(src_cell, 3)
    return false unless self.class.in_row?(captive_cell, 3)
    return false unless self.class.is_left_adjacent?(src_cell, captive_cell)

    cap_row, cap_col = captive_cell
    top_adjacent = [cap_row - 1, cap_col]
    return false unless self.class.is_empty_cell?(top_adjacent, board)

    enemy_pawn = self.class.pieces(board, { row: cap_row, col: cap_col })[0]
    return false unless enemy_pawn[:piece].did_double_step?

    return false unless is_proper_last_move.call(args)

    true
  end

  def can_black_capture_en_passant_left?(args, &is_proper_last_move)
    args => { src_cell:, captive_cell:, board: }

    return false unless self.class.in_row?(src_cell, 4)
    return false unless self.class.in_row?(captive_cell, 4)
    return false unless self.class.is_left_adjacent?(src_cell, captive_cell)

    cap_row, cap_col = captive_cell
    bot_adjacent = [cap_row + 1, cap_col]
    return false unless self.class.is_empty_cell?(bot_adjacent, board)

    enemy_pawn = self.class.pieces(board, { row: cap_row, col: cap_col })[0]
    return false unless enemy_pawn[:piece].did_double_step?

    return false unless is_proper_last_move.call(args)

    true
  end

  def can_white_capture_en_passant_right?(args, &is_proper_last_move)
    args => { src_cell:, captive_cell:, board: }

    return false unless self.class.in_row?(src_cell, 3)
    return false unless self.class.in_row?(captive_cell, 3)
    return false unless self.class.is_right_adjacent?(src_cell, captive_cell)

    cap_row, cap_col = captive_cell
    top_adjacent = [cap_row - 1, cap_col]
    return false unless self.class.is_empty_cell?(top_adjacent, board)

    enemy_pawn = self.class.pieces(board, { row: cap_row, col: cap_col })[0]
    return false unless enemy_pawn[:piece].did_double_step?

    return false unless is_proper_last_move.call(args)

    true
  end

  def can_black_capture_en_passant_right?(args, &is_proper_last_move)
    args => { src_cell:, captive_cell:, board: }

    return false unless self.class.in_row?(src_cell, 4)
    return false unless self.class.in_row?(captive_cell, 4)
    return false unless self.class.is_right_adjacent?(src_cell, captive_cell)

    cap_row, cap_col = captive_cell
    bot_adjacent = [cap_row + 1, cap_col]
    return false unless self.class.is_empty_cell?(bot_adjacent, board)

    enemy_pawn = self.class.pieces(board, { row: cap_row, col: cap_col })[0]
    return false unless enemy_pawn[:piece].did_double_step?

    return false unless is_proper_last_move.call(args)

    true
  end

  def can_white_capture_en_passant?(args, &is_proper_last_move)
    return true if can_white_capture_en_passant_left?(args, &is_proper_last_move)
    return true if can_white_capture_en_passant_right?(args, &is_proper_last_move)
    false
  end

  def can_black_capture_en_passant?(args, &is_proper_last_move)
    return true if can_black_capture_en_passant_left?(args, &is_proper_last_move)
    return true if can_black_capture_en_passant_right?(args, &is_proper_last_move)
    false
  end

  def white_capture_en_passant(args, &is_proper_last_move)
    can_capture = can_white_capture_en_passant?(args, &is_proper_last_move)
    captive_cell = args.fetch(:captive_cell, nil)
    can_capture ? self.class.up_adjacent_cell(captive_cell) : nil
  end

  def black_capture_en_passant(args, &is_proper_last_move)
    can_capture = can_black_capture_en_passant?(args, &is_proper_last_move)
    captive_cell = args.fetch(:captive_cell, nil)
    can_capture ? self.class.down_adjacent_cell(captive_cell) : nil
  end
end

