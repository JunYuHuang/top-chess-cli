require 'set'

module PieceUtils
  BOARD_LENGTH = 8
  DEFAULT_MOVE_OPTIONS = {
    max_steps: BOARD_LENGTH - 1
  }
  VALID_PIECE_TYPES = Set.new([:pawn, :rook, :knight, :bishop, :queen, :king])
  VALID_PIECE_COLORS = Set.new([:black, :white])
  L_SHAPED_CELL_OFFSETS = [
    [-1, -2],   # 2 lefts -> 1 up
    [1, -2],    # 2 lefts -> 1 down
    [-1, 2],    # 2 rights -> 1 up
    [1, 2],     # 2 rights -> 1 down
    [-2, -1],   # 2 ups -> 1 left
    [-2, 1],    # 2 ups -> 1 right
    [2, -1],    # 2 downs -> 1 left
    [2, 1]      # 2 downs -> 1 right
  ]
  ENCLOSING_CELL_OFFSETS = [
    [-1, -1],   # top left
    [-1, 0],    # top
    [-1, 1],    # top right
    [0, -1],    # left
    [0, 1],     # right
    [1, -1],    # bot left
    [1, 0],     # bot
    [1, 1],     # bot right
  ]

  def board_length
    BOARD_LENGTH
  end

  def is_valid_piece_color?(color)
    VALID_PIECE_COLORS.include?(color)
  end

  def is_valid_piece_type?(type)
    VALID_PIECE_TYPES.include?(type)
  end

  def is_valid_row?(row)
    return false unless row.class == Integer
    0 <= row && row < BOARD_LENGTH
  end

  def is_valid_col?(col)
    return false unless col.class == Integer
    0 <= col && col < BOARD_LENGTH
  end

  def is_inbound_cell?(cell)
    row, col = cell
    return false if row.class != Integer or col.class != Integer
    return false if row < 0 or row >= BOARD_LENGTH
    return false if col < 0 or col >= BOARD_LENGTH
    true
  end

  def is_empty_cell?(cell, board)
    row, col = cell
    piece = board[row][col]
    piece.nil?
  end

  def is_ally_cell?(src_cell, dst_cell, board)
    return false if is_empty_cell?(src_cell, board)
    return false if is_empty_cell?(dst_cell, board)

    src_row, src_col = src_cell
    dst_row, dst_col = dst_cell
    src_piece = board[src_row][src_col]
    dst_piece = board[dst_row][dst_col]
    return false unless is_valid_piece_color?(src_piece.color)
    return false unless is_valid_piece_type?(src_piece.type)
    return false unless is_valid_piece_color?(dst_piece.color)
    return false unless is_valid_piece_type?(dst_piece.type)
    src_piece.color == dst_piece.color
  end

  def is_enemy_cell?(src_cell, dst_cell, board)
    return false if is_empty_cell?(src_cell, board)
    return false if is_empty_cell?(dst_cell, board)

    src_row, src_col = src_cell
    dst_row, dst_col = dst_cell
    src_piece = board[src_row][src_col]
    dst_piece = board[dst_row][dst_col]
    return false unless is_valid_piece_color?(src_piece.color)
    return false unless is_valid_piece_type?(src_piece.type)
    return false unless is_valid_piece_color?(dst_piece.color)
    return false unless is_valid_piece_type?(dst_piece.type)
    src_piece.color != dst_piece.color
  end

  def deep_copy(obj)
    if obj.is_a?(Array)
      new_array = obj.map { |el| deep_copy(el) }
    elsif obj.is_a?(Hash)
      new_hash = {}
      obj.each do |key, value|
        new_hash[key] = deep_copy(value)
      end
      new_hash
    else
      obj.clone
    end
  end

  def count_col_cells_amid_two_cells(src_cell, dst_cell)
    src_row, src_col = src_cell
    dst_row, dst_col = dst_cell
    (dst_row - src_row).abs - 1
  end

  def enemy_color(color)
    return nil unless is_valid_piece_color?(color)
    color == :white ? :black : :white
  end

  def move(args)
    piece_obj = args.fetch(:piece_obj, nil)
    src_cell = args.fetch(:src_cell, nil)
    dst_cell = args.fetch(:dst_cell, nil)
    board = args.fetch(:board, nil)

    return if (piece_obj.nil? or src_cell.nil? or
              dst_cell.nil? or board.nil?)

    new_board = deep_copy(board)
    src_row, src_col = src_cell
    new_board[src_row][src_col] = nil
    dst_row, dst_col = dst_cell
    new_board[dst_row][dst_col] = piece_obj
    new_board
  end

  def capture(args)
    piece_obj = args.fetch(:piece_obj, nil)
    src_cell = args.fetch(:src_cell, nil)
    dst_cell = args.fetch(:dst_cell, nil)
    board = args.fetch(:board, nil)
    en_passant_cap_cell = args.fetch(:en_passant_cap_cell, nil)

    return if (piece_obj.nil? or src_cell.nil? or
              dst_cell.nil? or board.nil?)

    new_board = deep_copy(board)
    src_row, src_col = src_cell
    new_board[src_row][src_col] = nil
    dst_row, dst_col = dst_cell
    new_board[dst_row][dst_col] = piece_obj
    return new_board if en_passant_cap_cell.nil?

    cap_row, cap_col = en_passant_cap_cell
    new_board[cap_row][cap_col] = nil
    new_board
  end

  def board_to_s(board)
    piece_to_s = {
      nil => "     ",
      [:rook, :black] => "b_rok",
      [:rook, :white] => "w_rok",
      [:knight, :black] => "b_nte",
      [:knight, :white] => "w_nte",
      [:bishop, :black] => "b_bsh",
      [:bishop, :white] => "w_bsh",
      [:queen, :black] => "b_qwn",
      [:queen, :white] => "w_qwn",
      [:king, :black] => "b_kng",
      [:king, :white] => "w_kng",
      [:pawn, :black] => "b_pwn",
      [:pawn, :white] => "w_pwn",
    }
    res = []
    BOARD_LENGTH.times do |r|
      row = ["|"]
      BOARD_LENGTH.times do |c|
        if is_empty_cell?([r, c], board)
          row.push(" #{piece_to_s[nil]} |")
          next
        end
        type = board[r][c].type
        color = board[r][c].color
        row.push(" #{piece_to_s[[type, color]]} |")
      end
      res.push("#{row.join}\n")
    end
    res.join
  end

  def is_piece_type?(src_cell, board, piece_type)
    src_row, src_col = src_cell
    return false unless is_inbound_cell?(src_cell)
    return board[src_row][src_col].type == piece_type
  end

  def is_piece_color?(src_cell, board, piece_color)
    src_row, src_col = src_cell
    return false unless is_inbound_cell?(src_cell)
    return board[src_row][src_col].color == piece_color
  end

  # Is a modified version of `ChessMoveRunner#is_matching_piece?`
  def is_matching_piece?(args)
    return false if args.class != Hash

    board = args.fetch(:board, nil)
    piece_type = args.fetch(:piece_type, nil)
    piece_color = args.fetch(:piece_color, nil)
    cell = args.fetch(:cell, nil)
    return false if board.nil? or piece_type.nil? or piece_color.nil? or cell.nil?

    row, col = cell
    real_piece = board[row][col]
    return false if is_empty_cell?(cell, board)
    return false if real_piece.color != piece_color
    return false if real_piece.type != piece_type

    true
  end

  def is_piece_actionable?(cell, board)
    return false unless is_inbound_cell?(cell)
    return false if is_empty_cell?(cell, board)

    row, col = cell
    piece = board[row][col]
    return true if piece.moves(cell, board).size > 0
    return true if piece.captures(cell, board).size > 0
    if piece.respond_to?(:captures_en_passant)
      return true if piece.captures_en_passant(cell, board).size > 0
    end
    if piece.respond_to?(:promotes)
      return true if piece.promotes(cell, board).size > 0
    end
    if piece.respond_to?(:can_queenside_castle?)
      return true if piece.can_queenside_castle?(cell, board)
    end
    if piece.respond_to?(:can_kingside_castle?)
      return true if piece.can_kingside_castle?(cell, board)
    end
    false
  end

  def pieces(board, filters)
    res = []

    BOARD_LENGTH.times do |r|
      BOARD_LENGTH.times do |c|
        next if is_empty_cell?([r, c], board)
        res.push({
          piece: board[r][c],
          cell: [r, c]
        })
      end
    end

    def passes_filters?(board, filters, piece_hash)
      type = filters.fetch(:type, nil)
      color = filters.fetch(:color, nil)
      row = filters.fetch(:row, nil)
      col = filters.fetch(:col, nil)
      is_actionable = filters.fetch(:is_actionable, nil)

      my_type = piece_hash[:piece].type
      my_color = piece_hash[:piece].color
      my_row = piece_hash[:cell][0]
      my_col = piece_hash[:cell][1]

      return false if is_valid_piece_type?(type) && my_type != type
      return false if is_valid_piece_color?(color) && my_color != color
      return false if is_valid_row?(row) && my_row != row
      return false if is_valid_col?(col) && my_col != col
      return false if (
        is_actionable == true &&
        !is_piece_actionable?(piece_hash[:cell], board)
      )
      true
    end

    res.filter { |hash| passes_filters?(board, filters, hash) }
  end

  def remove_pieces(board, filters)
    board_copy = deep_copy(board)

    def passes_filters?(filters, piece_hash)
      type = filters.fetch(:type, nil)
      color = filters.fetch(:color, nil)
      row = filters.fetch(:row, nil)
      col = filters.fetch(:col, nil)

      my_type = piece_hash[:piece].type
      my_color = piece_hash[:piece].color
      my_row = piece_hash[:cell][0]
      my_col = piece_hash[:cell][1]

      return false if is_valid_piece_type?(type) && my_type != type
      return false if is_valid_piece_color?(color) && my_color != color
      return false if is_valid_row?(row) && my_row != row
      return false if is_valid_col?(col) && my_col != col
      true
    end

    BOARD_LENGTH.times do |r|
      BOARD_LENGTH.times do |c|
        next if is_empty_cell?([r, c], board_copy)
        piece_hash = {
          piece: board_copy[r][c],
          cell: [r, c]
        }
        board_copy[r][c] = nil if passes_filters?(filters, piece_hash)
      end
    end

    board_copy
  end

  def is_absolute_pinned?(src_cell, dst_cell, board)
    return false unless is_inbound_cell?(src_cell)
    return false unless is_inbound_cell?(dst_cell)
    return false if is_empty_cell?(src_cell, board)

    src_row, src_col = src_cell
    src_piece = board[src_row][src_col]
    return false if src_piece.type == :king

    # assumes there is an allied king on the board
    new_board = deep_copy(board)
    new_board[src_row][src_col] = nil
    dst_row, dst_col = dst_cell
    new_board[dst_row][dst_col] = src_piece
    king_filter = { color: src_piece.color, type: :king }
    king = pieces(new_board, king_filter)[0]
    king[:piece].is_checked?(king[:cell], new_board)
  end

  def in_row?(src_cell, row)
    src_row, src_col = src_cell
    src_row == row
  end

  def is_left_adjacent?(origin_cell, target_cell)
    origin_row, origin_col = origin_cell
    target_row, target_col = target_cell
    return false if origin_row != target_row
    target_col == origin_col - 1
  end

  def is_right_adjacent?(origin_cell, target_cell)
    origin_row, origin_col = origin_cell
    target_row, target_col = target_cell
    return false if origin_row != target_row
    target_col == origin_col + 1
  end

  def up_adjacent_cell(src_cell)
    src_row, src_col = src_cell
    [src_row - 1, src_col]
  end

  def down_adjacent_cell(src_cell)
    src_row, src_col = src_cell
    [src_row + 1, src_col]
  end

  def adjacent_cells(src_cell)
    src_row, src_col = src_cell
    res = []
    ENCLOSING_CELL_OFFSETS.each do |offset_cell|
      offset_row, offset_col = offset_cell
      adj_cell = [src_row + offset_row, src_col + offset_col]
      res.push(adj_cell) if is_inbound_cell?(adj_cell)
    end
    res
  end

  def en_passant_captive_cell(dst_cell, capturer_color)
    return unless is_inbound_cell?(dst_cell)
    return unless is_valid_piece_color?(capturer_color)

    captive_cell = capturer_color == :white ?
      down_adjacent_cell(dst_cell) :
      up_adjacent_cell(dst_cell)
    is_inbound_cell?(captive_cell) ? captive_cell : nil
  end

  def up_moves(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    res = []
    src_row, src_col = src_cell
    row = src_row - 1
    steps = 1
    while row >= 0 do
      break unless is_empty_cell?([row, src_col], board)
      break if steps > max_steps
      res.push([row, src_col])
      row -= 1
      steps += 1
    end
    res
  end

  def up_capture(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    src_row, src_col = src_cell
    row = src_row - 1
    steps = 1
    while row >= 0 do
      break if steps > max_steps
      break if is_ally_cell?([src_row, src_col], [row, src_col], board)
      if is_enemy_cell?([src_row, src_col], [row, src_col], board)
        return [row, src_col]
      end
      row -= 1
      steps += 1
    end
    nil
  end

  def down_moves(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    res = []
    src_row, src_col = src_cell
    row = src_row + 1
    steps = 1
    while row < BOARD_LENGTH do
      break unless is_empty_cell?([row, src_col], board)
      break if steps > max_steps
      res.push([row, src_col])
      row += 1
      steps += 1
    end
    res
  end

  def down_capture(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    src_row, src_col = src_cell
    row = src_row + 1
    steps = 1
    while row < BOARD_LENGTH do
      break if steps > max_steps
      break if is_ally_cell?([src_row, src_col], [row, src_col], board)
      if is_enemy_cell?([src_row, src_col], [row, src_col], board)
        return [row, src_col]
      end
      row += 1
      steps += 1
    end
    nil
  end

  def left_moves(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    res = []
    src_row, src_col = src_cell
    col = src_col - 1
    steps = 1
    while col >= 0 do
      break unless is_empty_cell?([src_row, col], board)
      break if steps > max_steps
      res.push([src_row, col])
      col -= 1
      steps += 1
    end
    res
  end

  def left_capture(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    src_row, src_col = src_cell
    col = src_col - 1
    steps = 1
    while col >= 0 do
      break if steps > max_steps
      break if is_ally_cell?([src_row, src_col], [src_row, col], board)
      if is_enemy_cell?([src_row, src_col], [src_row, col], board)
        return [src_row, col]
      end
      col -= 1
      steps += 1
    end
    nil
  end

  def right_moves(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    res = []
    src_row, src_col = src_cell
    col = src_col + 1
    steps = 1
    while col < BOARD_LENGTH do
      break unless is_empty_cell?([src_row, col], board)
      break if steps > max_steps
      res.push([src_row, col])
      col += 1
      steps += 1
    end
    res
  end

  def right_capture(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    src_row, src_col = src_cell
    col = src_col + 1
    steps = 1
    while col < BOARD_LENGTH do
      break if steps > max_steps
      break if is_ally_cell?([src_row, src_col], [src_row, col], board)
      if is_enemy_cell?([src_row, src_col], [src_row, col], board)
        return [src_row, col]
      end
      col += 1
      steps += 1
    end
    nil
  end

  # cells in lower half of positive diagonal line
  def down_left_moves(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    res = []
    src_row, src_col = src_cell
    row = src_row + 1
    col = src_col - 1
    steps = 1
    while row < BOARD_LENGTH && col >= 0 do
      break unless is_empty_cell?([row, col], board)
      break if steps > max_steps
      res.push([row, col])
      row += 1
      col -= 1
      steps += 1
    end
    res
  end

  # cell in lower half of positive diagonal line
  def down_left_capture(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    src_row, src_col = src_cell
    row = src_row + 1
    col = src_col - 1
    steps = 1
    while row < BOARD_LENGTH && col >= 0 do
      break if steps > max_steps
      break if is_ally_cell?([src_row, src_col], [row, col], board)
      if is_enemy_cell?([src_row, src_col], [row, col], board)
        return [row, col]
      end
      row += 1
      col -= 1
      steps += 1
    end
    nil
  end

  # cells in upper half of positive diagonal line
  def up_right_moves(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    res = []
    src_row, src_col = src_cell
    row = src_row - 1
    col = src_col + 1
    steps = 1
    while row >= 0 && col < BOARD_LENGTH do
      break unless is_empty_cell?([row, col], board)
      break if steps > max_steps
      res.push([row, col])
      row -= 1
      col += 1
      steps += 1
    end
    res
  end

  # cell in upper half of positive diagonal line
  def up_right_capture(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    src_row, src_col = src_cell
    row = src_row - 1
    col = src_col + 1
    steps = 1
    while row >= 0 && col < BOARD_LENGTH do
      break if steps > max_steps
      break if is_ally_cell?([src_row, src_col], [row, col], board)
      if is_enemy_cell?([src_row, src_col], [row, col], board)
        return [row, col]
      end
      row -= 1
      col += 1
      steps += 1
    end
    nil
  end

  # cells in lower half of negative diagonal line
  def down_right_moves(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    res = []
    src_row, src_col = src_cell
    row = src_row + 1
    col = src_col + 1
    steps = 1
    while row < BOARD_LENGTH && col < BOARD_LENGTH do
      break unless is_empty_cell?([row, col], board)
      break if steps > max_steps
      res.push([row, col])
      row += 1
      col += 1
      steps += 1
    end
    res
  end

  # cell in lower half of negative diagonal line
  def down_right_capture(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    src_row, src_col = src_cell
    row = src_row + 1
    col = src_col + 1
    steps = 1
    while row < BOARD_LENGTH && col < BOARD_LENGTH do
      break if steps > max_steps
      break if is_ally_cell?([src_row, src_col], [row, col], board)
      if is_enemy_cell?([src_row, src_col], [row, col], board)
        return [row, col]
      end
      row += 1
      col += 1
      steps += 1
    end
    nil
  end

  # cells in upper half of negative diagonal line
  def up_left_moves(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    res = []
    src_row, src_col = src_cell
    row = src_row - 1
    col = src_col - 1
    steps = 1
    while row >= 0 && col >= 0 do
      break unless is_empty_cell?([row, col], board)
      break if steps > max_steps
      res.push([row, col])
      row -= 1
      col -= 1
      steps += 1
    end
    res
  end

  # cell in upper half of negative diagonal line
  def up_left_capture(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    src_row, src_col = src_cell
    row = src_row - 1
    col = src_col - 1
    steps = 1
    while row >= 0 && col >= 0 do
      break if steps > max_steps
      break if is_ally_cell?([src_row, src_col], [row, col], board)
      if is_enemy_cell?([src_row, src_col], [row, col], board)
        return [row, col]
      end
      row -= 1
      col -= 1
      steps += 1
    end
    nil
  end

  def l_shaped_moves(src_cell, board)
    src_row, src_col = src_cell
    res = []
    L_SHAPED_CELL_OFFSETS.each do |offset_cell|
      offset_row, offset_col = offset_cell
      dst_cell = [src_row + offset_row, src_col + offset_col]
      next unless is_inbound_cell?(dst_cell)
      res.push(dst_cell) if is_empty_cell?(dst_cell, board)
    end
    res
  end

  def l_shaped_captures(src_cell, board)
    src_row, src_col = src_cell
    res = []
    L_SHAPED_CELL_OFFSETS.each do |offset_cell|
      offset_row, offset_col = offset_cell
      dst_cell = [src_row + offset_row, src_col + offset_col]
      next unless is_inbound_cell?(dst_cell)
      res.push(dst_cell) if is_enemy_cell?(src_cell, dst_cell, board)
    end
    res
  end
end
