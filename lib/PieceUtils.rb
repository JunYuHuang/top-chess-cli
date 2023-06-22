module PieceUtils
  BOARD_LENGTH = 8
  DEFAULT_MOVE_OPTIONS = {
    max_steps: BOARD_LENGTH - 1
  }

  # TODO
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

  # TODO
  def is_ally_piece_cell?(src_cell, dst_cell, board)
    src_row, src_col = src_cell
    dst_row, dst_col = dst_cell
    src_piece = board[src_row][src_col]
    dst_piece = board[dst_row][dst_col]
    return false if src_piece.nil? or src_piece.type == :empty
    src_piece.type == dst_piece.type
  end

  # TODO
  def is_enemy_piece_cell?(src_cell, dst_cell, board)
    src_row, src_col = src_cell
    dst_row, dst_col = dst_cell
    src_piece = board[src_row][src_col]
    dst_piece = board[dst_row][dst_col]
    return false if src_piece.nil? or src_piece.type == :empty
    src_piece.type != dst_piece.type
  end

  def up_moves(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    res = []
    src_row, src_col = src_cell
    row = src_row - 1
    steps = 0
    while row >= 0 do
      break unless is_empty_cell?([row, src_col], board)
      break if steps > max_steps
      res.push([row, src_col])
      row -= 1
      steps += 1
    end
    res
  end

  # TODO
  def up_capture(src_cell, board)
    src_row, src_col = src_cell
    row = src_row - 1
    while row >= 0 do
      if is_enemy_piece_cell?([src_row, src_col], [row, src_col], board)
        return [row, src_col]
      end
      row -= 1
    end
    nil
  end

  def down_moves(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    res = []
    src_row, src_col = src_cell
    row = src_row + 1
    steps = 0
    while row < BOARD_LENGTH do
      break unless is_empty_cell?([row, src_col], board)
      break if steps > max_steps
      res.push([row, src_col])
      row += 1
      steps += 1
    end
    res
  end

  # TODO
  def down_capture(src_cell, board)
    src_row, src_col = src_cell
    row = src_row + 1
    while row < BOARD_LENGTH do
      if is_enemy_piece_cell?([src_row, src_col], [row, src_col], board)
        return [row, src_col]
      end
      row += 1
    end
    nil
  end

  def left_moves(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    res = []
    src_row, src_col = src_cell
    col = src_col - 1
    steps = 0
    while col >= 0 do
      break unless is_empty_cell?([src_row, col], board)
      break if steps > max_steps
      res.push([src_row, col])
      col -= 1
      steps += 1
    end
    res
  end

  # TODO
  def left_capture(src_cell, board)
    src_row, src_col = src_cell
    col = src_col - 1
    while col >= 0 do
      if is_enemy_piece_cell?([src_row, src_col], [src_row, col], board)
        return [src_row, col]
      end
      col -= 1
    end
    nil
  end

  def right_moves(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    res = []
    src_row, src_col = src_cell
    col = src_col + 1
    steps = 0
    while col < BOARD_LENGTH do
      break unless is_empty_cell?([src_row, col], board)
      break if steps > max_steps
      res.push([src_row, col])
      col += 1
      steps += 1
    end
    res
  end

  # TODO
  def right_capture(src_cell, board)
    src_row, src_col = src_cell
    col = src_col + 1
    while col < BOARD_LENGTH do
      if is_enemy_piece_cell?([src_row, src_col], [src_row, col], board)
        return [src_row, col]
      end
      col += 1
    end
    nil
  end

  # TODO (cells in lower half of positive diagonal line)
  def down_left_moves(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    res = []
    src_row, src_col = src_cell
    row = src_row + 1
    col = src_col - 1
    steps = 0
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

  # TODO (cell in lower half of positive diagonal line)
  def down_left_capture(src_cell, board)
    src_row, src_col = src_cell
    row = src_row + 1
    col = src_col - 1
    while row < BOARD_LENGTH && col >= 0 do
      if is_enemy_piece_cell?([src_row, src_col], [row, col], board)
        return [row, col]
      end
      row += 1
      col -= 1
    end
    nil
  end

  # TODO (get cells in upper half of positive diagonal line)
  def up_right_moves(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    res = []
    src_row, src_col = src_cell
    row = src_row - 1
    col = src_col + 1
    steps = 0
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

  # TODO (get cell in upper half of positive diagonal line)
  def up_right_capture(src_cell, board)
    src_row, src_col = src_cell
    row = src_row - 1
    col = src_col + 1
    while row >= 0 && col < BOARD_LENGTH do
      if is_enemy_piece_cell?([src_row, src_col], [row, col], board)
        return [row, col]
      end
      row -= 1
      col += 1
    end
    nil
  end

  # TODO (get cells in lower half of negative diagonal line)
  def down_right_moves(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    res = []
    src_row, src_col = src_cell
    row = src_row + 1
    col = src_col + 1
    steps = 0
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

  # TODO (get cell in lower half of negative diagonal line)
  def down_right_capture(src_cell, board)
    src_row, src_col = src_cell
    row = src_row + 1
    col = src_col + 1
    while row < BOARD_LENGTH && col < BOARD_LENGTH do
      if is_enemy_piece_cell?([src_row, src_col], [row, col], board)
        return [row, col]
      end
      row += 1
      col += 1
    end
    nil
  end

  # TODO (get cells in upper half of negative diagonal line)
  def up_left_moves(src_cell, board, options = DEFAULT_MOVE_OPTIONS)
    max_steps = options.fetch(:max_steps, BOARD_LENGTH - 1)

    res = []
    src_row, src_col = src_cell
    row = src_row - 1
    col = src_col - 1
    steps = 0
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

  # TODO (get cell in upper half of negative diagonal line)
  def up_left_capture(src_cell, board)
    src_row, src_col = src_cell
    row = src_row - 1
    col = src_col - 1
    while row >= 0 && col >= 0 do
      if is_enemy_piece_cell?([src_row, src_col], [row, col], board)
        return [row, col]
      end
      row -= 1
      col -= 1
    end
    nil
  end
end
