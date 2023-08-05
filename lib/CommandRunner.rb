require 'set'

class CommandRunner
  APP_MODES = { load: :load, setup: :setup, in_game: :in_game, post_game: :post_game }
  DEFAULTS = { game: nil, app_mode: APP_MODES[:load] }
  COMMANDS = {
    new_game: "!new", load_game: "!load", save_game: "!save"
  }
  LOAD_REGEX = /^#{Regexp.quote(COMMANDS[:load_game])}\s(\S)+$/
  PLAYER_TYPE_REGEX = /^(human)|(computer)$/
  PIECE_COLOR_REGEX = /^(white)|(black)$/

  attr_accessor(:game, :app_mode)

  def initialize(args)
    @game = args.fetch(:game, DEFAULTS[:game])
    @app_mode = args.fetch(:game, DEFAULTS[:app_mode])
  end

  def set_load_mode!
    return if @app_mode == APP_MODES[:load]
    @app_mode = APP_MODES[:load]
  end

  def set_setup_mode!
    return if @app_mode == APP_MODES[:setup]
    @app_mode = APP_MODES[:setup]
  end

  def set_in_game_mode!
    return if @app_mode == APP_MODES[:in_game]
    @app_mode = APP_MODES[:in_game]
  end

  def set_post_game_mode!
    return if @app_mode == APP_MODES[:post_game]
    @app_mode = APP_MODES[:post_game]
  end

  def game_meets_prereqs?(game = @game)
    return false unless game
    return false unless game.piece_factory
    return false unless game.game_save
    return false unless game.human_player_class
    # TODO - to implement `ComputerPlayer` class
    # return false unless game.computer_player_class
    return false unless game.players.class == Array
    return false unless game.players.size == game.players_count
    true
  end

  # TODO - to test
  def can_command?(syntax)
    return false unless game_meets_prereqs?
    return true if can_new_game?(syntax)
    return true if can_save_game?(syntax)
    return true if can_load_game?(syntax)
    false
  end

  # TODO - to test
  def execute_command!(syntax)
    return unless can_command?(syntax)

    if can_new_game?(syntax)
      new_game!(syntax)
    elsif can_save_game?(syntax)
      save_game!(syntax)
    elsif can_load_game?(syntax)
      load_game!(syntax)
    end
  end

  def can_new_game?(syntax)
    return false unless game_meets_prereqs?
    return false unless @app_mode == APP_MODES[:load]
    syntax == COMMANDS[:new_game]
  end

  # TODO - to test
  def new_game!(syntax)
    return unless can_new_game?(syntax)
    set_in_game_mode!
  end

  def can_save_game?(syntax)
    return false unless game_meets_prereqs?
    return false unless @app_mode == APP_MODES[:in_game]
    syntax == COMMANDS[:save_game]
  end

  def save_game!(syntax)
    return unless can_save_game?(syntax)
    set_in_game_mode!
    name = @game.game_save.create_save
  end

  def can_load_game?(syntax)
    return false unless game_meets_prereqs?
    return false unless @app_mode == APP_MODES[:load]
    return false unless LOAD_REGEX.match?(syntax)

    command, save_name = syntax.split(" ")
    @game.game_save.save_exists?(save_name)
  end

  def load_game!(syntax)
    return unless can_load_game?(syntax)

    command, save_name = syntax.split(" ")
    save_state = @game.game_save.open_save(save_name)
    @game.update!(save_state)
    set_in_game_mode!
  end

  # TODO - to test
  def can_pick_enemy_type?(syntax)
    return false unless game_meets_prereqs?
    return false unless @app_mode == APP_MODES[:setup]
    PLAYER_TYPE_REGEX.match?(syntax)
  end

  # TODO - to test
  def can_pick_color?(syntax)
    return false unless game_meets_prereqs?
    return false unless @app_mode == APP_MODES[:setup]
    PIECE_COLOR_REGEX.match?(syntax)
  end

  # TODO - to test
  def setup_game!(options)
    enemy_type = options.fetch(:enemy_type, "human")
    color = options.fetch(:color, "white")
    return if enemy_type.nil? or color.nil?

    # TODO
  end
end
