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
  VALID_PROMOTION_PIECE_TYPES = Set.new([:rook, :knight, :bishop, :queen])

  # TODO - to test
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
    return false if row < 0 or row >= BOARD_LENGTH
    return false if col < 0 or col >= BOARD_LENGTH
    true
  end

  def is_empty_cell?(cell, board)
    row, col = cell
    piece = board[row][col]
    return true if piece.nil?
    piece.type == :empty
  end

  # TODO - to test
  def is_ally_piece_cell?(src_cell, dst_cell, board)
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

  def is_enemy_piece_cell?(src_cell, dst_cell, board)
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

  def at_last_row?(src_cell, board)
    return false unless is_inbound_cell?(src_cell)
    return false if is_empty_cell?(src_cell, board)

    src_row, src_col = src_cell
    piece_color = board[src_row][src_col].color
    return false unless is_valid_piece_color?(piece_color)
    piece_color == :white ?
      src_row == 0 :
      src_row == BOARD_LENGTH - 1
  end

  # TODO - to test
  def is_valid_promotion?(piece_type)
    VALID_PROMOTION_PIECE_TYPES.include?(piece_type)
  end

  def deep_copy(board)
    if board.is_a?(Array)
      new_array = board.map { |el| deep_copy(el) }
    elsif board.is_a?(Hash)
      new_hash = {}
      board.each do |key, value|
        new_hash[key] = deep_copy(value)
      end
      new_hash
    else
      board.clone
    end
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
        if board[r][c].nil? or board[r][c].type == :empty
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

    res.filter! { |piece_hash| passes_filters?(filters, piece_hash) }
  end

  # TODO - to test
  def is_clear_between_two_cells_in_row?(src_cell, dst_cell, board)
    src_row, src_col = src_cell
    dst_row, dst_col = dst_cell
    return false if src_row != dst_row or src_col == dst_col

    first_col = 0
    last_col = BOARD_LENGTH - 1
    if src_col < dst_col
      first_col = src_col
      last_col = dst_col
    else
      first_col = dst_col
      last_col = src_col
    end

    (first_col + 1..last_col).to_a.each do |col|
      return false unless is_empty_cell?([src_cell, col], board)
    end
    true
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
      if is_enemy_piece_cell?([src_row, src_col], [row, src_col], board)
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
      if is_enemy_piece_cell?([src_row, src_col], [row, src_col], board)
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
      if is_enemy_piece_cell?([src_row, src_col], [src_row, col], board)
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
      if is_enemy_piece_cell?([src_row, src_col], [src_row, col], board)
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
      if is_enemy_piece_cell?([src_row, src_col], [row, col], board)
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
      if is_enemy_piece_cell?([src_row, src_col], [row, col], board)
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
      if is_enemy_piece_cell?([src_row, src_col], [row, col], board)
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
      if is_enemy_piece_cell?([src_row, src_col], [row, col], board)
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
      res.push(dst_cell) if is_enemy_piece_cell?(src_cell, dst_cell, board)
    end
    res
  end
end
