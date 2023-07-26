require './lib/Piece'
require './lib/PieceUtils'

class PawnPiece < Piece
  extend PieceUtils

  DEFAULT_OPTIONS = {
    color: :white,
    did_move: false,
    did_double_step: false
  }

  attr_accessor(
    :did_move, :did_double_step,
    :is_capturable_en_passant, :one_step, :two_steps
  )

  @@one_step = { max_steps: 1 }

  @@two_steps = { max_steps: 2 }

  def initialize(options = DEFAULT_OPTIONS)
    passed_options = {
      color: options.fetch(:color, DEFAULT_OPTIONS[:color]),
      type: :pawn,
      is_capturable: true,
      is_capturable_en_passant: false
    }

    super(passed_options)
    @did_move = options.fetch(:did_move, DEFAULT_OPTIONS[:did_move])
    @did_double_step = options.fetch(:did_double_step, DEFAULT_OPTIONS[:did_double_step])
    @is_capturable_en_passant = options.fetch(
      :is_capturable_en_passant,
      DEFAULT_OPTIONS[:is_capturable_en_passant]
    )
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

  def is_capturable_en_passant?
    @is_capturable_en_passant
  end

  def set_is_capturable_en_passant!(bool = false)
    return if bool == @is_capturable_en_passant
    @is_capturable_en_passant = bool
  end

  def can_capture_en_passant?(args)
    src_cell = args.fetch(:src_cell, nil)
    dst_cell = args.fetch(:dst_cell, nil)
    board = args.fetch(:board, nil)
    return false if src_cell.nil? or dst_cell.nil? or board.nil?
    return false unless self.class.is_inbound_cell?(src_cell)
    return false unless self.class.is_inbound_cell?(dst_cell)
    return false unless self.class.is_empty_cell?(dst_cell, board)

    capturer_args = {
      board: board, piece_type: :pawn, piece_color: @color, cell: src_cell
    }
    return false unless self.class.is_matching_piece?(capturer_args)
    return false if @color == :white && !self.class.in_row?(src_cell, 3)
    return false if @color == :black && !self.class.in_row?(src_cell, 4)

    captive_cell = @color == :white ?
      self.class.down_adjacent_cell(dst_cell) :
      self.class.up_adjacent_cell(dst_cell)
    return false unless self.class.is_inbound_cell?(captive_cell)

    return false unless (
      self.class.is_left_adjacent?(src_cell, captive_cell) or
      self.class.is_right_adjacent?(src_cell, captive_cell)
    )

    captive_args = {
      board: board, piece_type: :pawn, cell: captive_cell,
      piece_color: @color == :white ? :black : :white
    }
    return false unless self.class.is_matching_piece?(captive_args)

    captive_row, captive_col = captive_cell
    capturee_filter = { row: captive_row, col: captive_col }
    capturee_pawn = self.class.pieces(board, capturee_filter)[0]
    return false unless capturee_pawn[:piece].did_double_step?

    capturee_pawn[:piece].is_capturable_en_passant?
  end

  # TODO - to rework and retest
  def capture_en_passant(args)
    src_cell = args.fetch(:src_cell, nil)
    dst_cell = args.fetch(:dst_cell, nil)
    board = args.fetch(:board, nil)
    return unless can_capture_en_passant?(args)

    capture(src_cell, dst_cell, board)
  end

  def did_move?
    @did_move
  end

  def moved!
    return if @did_move
    @did_move = true
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

  def move(src_cell, dst_cell, board)
    args = {
      src_cell: src_cell, dst_cell: dst_cell,
      board: board, piece_obj: self
    }
    self.class.move(args)
  end

  # assumes capture is valid
  def capture(src_cell, dst_cell, board)
    args = {
      src_cell: src_cell, dst_cell: dst_cell,
      board: board, piece_obj: self,
    }
    self.class.capture(args)
  end

  def capture_en_passant(src_cell, dst_cell, board)
    return unless can_capture_en_passant?({
      src_cell: src_cell, dst_cell: dst_cell, board: board
    })

    en_passant_capture_cell = @color == :white ?
      self.class.down_adjacent_cell(dst_cell) :
      self.class.up_adjacent_cell(dst_cell)
    args = {
      src_cell: src_cell, dst_cell: dst_cell,
      board: board, piece_obj: self,
      en_passant_cap_cell: en_passant_capture_cell
    }
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

  # TODO - to rework (include en-passant captures) and retest
  def white_captures(src_cell, board)
    res = [
      self.class.up_left_capture(src_cell, board, @@one_step),
      self.class.up_right_capture(src_cell, board, @@one_step),
    ]
    # up_left_cell = self.class.up_left_moves(src_cell, @@one_step)[0]
    # res.push(up_left_cell) if can_capture_en_passant?({
    #   src_cell: src_cell, dst_cell: up_left_cell, board: board
    # })
    # up_right_cell = self.class.up_right_moves(src_cell, @@one_step)[0]
    # res.push(up_right_cell) if can_capture_en_passant?({
    #   src_cell: src_cell, dst_cell: up_right_cell, board: board
    # })
    res.filter { |cell| !cell.nil? }
  end

  # TODO - to rework (include en-passant captures) and retest
  def black_captures(src_cell, board)
    res = [
      self.class.down_left_capture(src_cell, board, @@one_step),
      self.class.down_right_capture(src_cell, board, @@one_step),
    ]
    # down_left_cell = self.class.down_left_moves(src_cell, @@one_step)[0]
    # res.push(down_left_cell) if can_capture_en_passant?({
    #   src_cell: src_cell, dst_cell: down_left_cell, board: board
    # })
    # down_right_cell = self.class.down_right_moves(src_cell, @@one_step)[0]
    # res.push(down_right_cell) if can_capture_en_passant?({
    #   src_cell: src_cell, dst_cell: down_right_cell, board: board
    # })
    res.filter { |cell| !cell.nil? }
  end
end

