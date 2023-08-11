require 'set'

class CommandRunner
  DEFAULTS = { game: nil, app_mode: :load }
  COMMANDS = {
    new_game: "!new", load_game: "!load", save_game: "!save"
  }
  LOAD_REGEX = /^#{Regexp.quote(COMMANDS[:load_game])}\s(\S)+$/

  attr_accessor(:game, :app_mode)

  def initialize(args)
    @game = args.fetch(:game, DEFAULTS[:game])
    @app_mode = args.fetch(:game, DEFAULTS[:app_mode])
  end

  def set_load_mode!
    return if @app_mode == :load
    @app_mode = :load
  end

  def set_setup_mode!
    return if @app_mode == :setup
    @app_mode = :setup
  end

  def set_in_game_mode!
    return if @app_mode == :in_game
    @app_mode = :in_game
  end

  def set_post_game_mode!
    return if @app_mode == :post_game
    @app_mode = :post_game
  end

  def game_meets_prereqs?(game = @game)
    return false unless game
    return false unless game.piece_factory
    return false unless game.game_save
    return false unless game.human_player_class
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
    return false unless [:load].include?(@app_mode)
    syntax == COMMANDS[:new_game]
  end

  def new_game!(syntax)
    return unless can_new_game?(syntax)
    set_in_game_mode!
    @game.setup!
    @game.add_notice!("✅ Started a new game.")
  end

  def can_save_game?(syntax)
    return false unless game_meets_prereqs?
    return false unless @app_mode == :in_game
    syntax == COMMANDS[:save_game]
  end

  def save_game!(syntax)
    return unless can_save_game?(syntax)
    set_in_game_mode!
    name = @game.game_save.create_save
    @game.add_notice!("✅ Saved game as save '#{name}'.")
    name
  end

  def can_load_game?(syntax)
    return false unless game_meets_prereqs?
    return false unless @app_mode == :load
    return false unless LOAD_REGEX.match?(syntax)

    command, save_name = syntax.split(" ")
    @game.game_save.save_exists?(save_name)
  end

  def load_game!(syntax)
    return unless can_load_game?(syntax)

    command, save_name = syntax.split(" ")
    save_state = @game.game_save.open_save(save_name)
    @game.update!(save_state)
    @game.add_notice!("✅ Loaded game from save '#{save_name}'.")
    set_in_game_mode!
  end
end
