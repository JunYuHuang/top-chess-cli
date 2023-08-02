require './lib/Game'
require './lib/PieceFactory'
require './spec/MockPlayer'
require './lib/GameSave'

# Helper methods

def delete_saves_folder(folder_path)
  saves = Dir.glob("#{folder_path}/*")
  saves.each { |f| File.delete(f) } if saves.size > 0
  Dir.rmdir(folder_path) if Dir.exist?(folder_path)
end

def create_test_saves(folder_path, saves_count)
  Dir.mkdir(folder_path) unless Dir.exist?(folder_path)
  saves_count.times do |i|
    save = File.new("#{folder_path}/test_save_#{i}.yaml", "w+")
    save.puts("# test save file #{i}")
    save.close
  end
end

# Tests

describe GameSave do
  describe "#initialize" do
    it "returns a non-nil object called with no explicit arguments" do
      game_save = GameSave.new
      expect(game_save).not_to eql(nil)
    end

    it "returns a non-nil object if called with a real game object" do
      options = { piece_factory_class: PieceFactory }
      game = Game.new(options)
      game_save = GameSave.new({ game: game })
      expect(game_save).to_not eql(nil)
    end

    it "returns a non-nil object if called with custom arguments" do
      game_options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(game_options)
      game_save_options = {
        path: "./test_saves",
        file_extension: '.yml',
        name_prefix: 'test_save_',
        game: game
      }
      game_save = GameSave.new(game_save_options)
      expect(game_save).to_not eql(nil)
    end
  end
end
