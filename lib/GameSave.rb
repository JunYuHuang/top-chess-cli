require 'yaml'

class GameSave
  DEFAULTS = {
    path: "./saves",
    file_extension: ".yaml",
    name_prefix: "save_",
    game: nil
  }

  attr_accessor(:path, :file_extension, :name_prefix, :game)

  def initialize(options = DEFAULTS)
    @path = options.fetch(:path, DEFAULTS[:path])
    @file_extension = options.fetch(
      :file_extension, DEFAULTS[:file_extension]
    )
    @name_prefix = options.fetch(
      :name_prefix, DEFAULTS[:name_prefix]
    )
    @game = options.fetch(:game, DEFAULTS[:game])
  end

  def save_exists?(save_name)
    return false unless saves_folder_exists?
    File.exist?("#{@path}/#{save_name}#{@file_extension}")
  end

  def count_saves(prefix = @name_prefix)
    return 0 unless saves_folder_exists?
    Dir.glob("#{@path}/#{prefix}*#{@file_extension}").length
  end

  def saves_list(limit = 0, prefix = @name_prefix)
    return [] unless saves_folder_exists?
    res = Dir.glob("#{@path}/#{prefix}*#{@file_extension}")
    res = res.map do |save_path|
      save_path
        .delete_prefix("#{@path}/")
        .delete_suffix("#{@file_extension}")
    end
    limit > 0 ? res.take(limit) : res
  end

  def create_save(game = @game, prefix = @name_prefix)
    return "" unless game

    create_saves_folder unless saves_folder_exists?
    save_name = "#{prefix}#{unique_save_id(prefix)}"
    save = File.new(
      "#{@path}/#{save_name}#{@file_extension}", "w+"
    )
    save.puts(encode(game))
    save.close
    save_name
  end

  def open_save(save_name)
    return unless save_exists?(save_name)

    file = File.open(
      "#{@path}/#{save_name}#{@file_extension}", "r"
    )
    res = decode(file)
    file.close
    res
  end

  protected

  def saves_folder_exists?
    Dir.exist?(@path)
  end

  def create_saves_folder
    Dir.mkdir(@path)
  end

  def unique_save_id(prefix = @name_prefix)
    id = 0
    loop do
      break unless save_exists?("#{prefix}#{id}")
      id += 1
    end
    id
  end

  def encode(game = @game)
    return if game.nil?
    YAML.dump(game.simple_state)
  end

  def decode(string)
    YAML.load(string)
  end
end
