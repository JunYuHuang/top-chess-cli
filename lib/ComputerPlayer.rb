require './lib/Player'

class ComputerPlayer < Player
  DEFAULTS = { name: nil, piece_color: :black }

  def initialize(args)
    passed_args = {
      game: args[:game],
      type: :computer,
      name: args.fetch(:name, DEFAULTS[:name]),
      piece_color: args.fetch(:piece_color, DEFAULTS[:piece_color])
    }
    super(passed_args)
  end

  # TODO - to test
  def input
    return if @game.nil? or @game.chess_move_runner.nil?

    random_chess_move
  end

  def random_item(array)
    return if array.class != Array or array.size < 1
    array[rand(0...array.size)]
  end

  # TODO - to test
  def random_piece
    filter = { is_actionable: true, color: @piece_color }
    ally_pieces = self.class.pieces(filter, @game.board)
    piece = random_item(ally_pieces)
  end

  # TODO - to test
  def random_chess_move
    piece = random_piece
    chess_moves = [
      queenside_castle(piece),
      kingside_castle(piece),
      captures_en_passant(piece),
      random_promote(piece),
      random_capture(piece),
      random_move(piece)
    ].filter { |move| !move.nil? }
    random_item(chess_moves)
  end

  # TODO - to test
  def random_capture(piece)
    piece_obj = piece[:piece]
    cell = piece[:cell]
    piece_captures = piece_obj.captures(cell, @game.board)
    return if piece_captures.size < 1

    dst_cell = random_item(piece_captures)
    @game.chess_move_runner.capture_hash_to_syntax({
      src_piece_type: piece_obj.type,
      src_cell: cell,
      dst_cell: dst_cell
    })
  end

  # TODO - to test
  def random_move(piece)
    piece_obj = piece[:piece]
    cell = piece[:cell]
    piece_moves = piece_obj.moves(cell, @game.board)
    return if piece_moves.size < 1

    dst_cell = random_item(piece_moves)
    @game.chess_move_runner.move_hash_to_syntax({
      src_piece_type: piece_obj.type,
      src_cell: cell,
      dst_cell: dst_cell
    })
  end

  # TODO - to test
  def random_capture_en_passant(piece)
    piece_obj = piece[:piece]
    cell = piece[:cell]
    return unless piece_obj.respond_to?(:captures_en_passant)

    captures = piece_obj.captures_en_passant(cell, @game.board)
    return if captures.size < 1

    dst_cell = random_item(captures)
    @game.chess_move_runner.capture_hash_to_syntax({
      src_piece_type: piece_obj.type,
      src_cell: cell,
      dst_cell: dst_cell
    })
  end

  # TODO - to test
  def random_promote(piece)
    piece_obj = piece[:piece]
    cell = piece[:cell]
    return unless piece_obj.respond_to?(:promotes)

    promotes = piece_obj.promotes(cell, @game.board)
    return if promotes.size < 1

    dst_cell = random_item(promotes)
    is_capture = !@game.class.is_empty_cell?(dst_cell, @game.board)
    promo_piece_types = [:rook, :knight, :bishop, :queen]
    random_promo_piece = random_item(promo_piece_types)
    @game.chess_move_runner.promote_hash_to_syntax({
      src_cell: cell,
      dst_cell: dst_cell,
      promo_piece_type: random_promo_piece,
      is_capture: is_capture
    })
  end

  # TODO - to test
  def queenside_castle(piece)
    piece_obj = piece[:piece]
    cell = piece[:cell]
    return unless piece_obj.respond_to?(:can_queenside_castle?)
    return unless piece_obj.can_queenside_castle?(cell, @game.board)

    option = { is_kingside: false }
    @game.chess_move_runner.castle_hash_to_syntax(option)
  end

  # TODO - to test
  def kingside_castle(piece)
    piece_obj = piece[:piece]
    cell = piece[:cell]
    return unless piece_obj.respond_to?(:can_kingside_castle?)
    return unless piece_obj.can_kingside_castle?(cell, @game.board)

    option = { is_kingside: true }
    @game.chess_move_runner.castle_hash_to_syntax(option)
  end
end
