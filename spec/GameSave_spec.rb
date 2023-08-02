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

def create_test_saves(folder_path, count)
  Dir.mkdir(folder_path) unless Dir.exist?(folder_path)
  count.times do |i|
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

  describe "#save_exists?" do
    it "returns false if called and the 'saves' folder does not exist" do
      game_options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(game_options)
      saves_path = "./test_saves"
      game_save_options = {
        path: saves_path,
        file_extension: '.yaml',
        name_prefix: 'test_save_',
        game: game
      }
      game_save = GameSave.new(game_save_options)
      delete_saves_folder(saves_path)
      expect(game_save.save_exists?("test_save_0")).to eql(false)
    end

    it "returns false if called and the 'saves' folder exists but is empty" do
      game_options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(game_options)
      saves_path = "./test_saves"
      game_save_options = {
        path: saves_path,
        file_extension: '.yaml',
        name_prefix: 'test_save_',
        game: game
      }
      game_save = GameSave.new(game_save_options)
      delete_saves_folder(saves_path)
      Dir.mkdir(saves_path)
      expect(game_save.save_exists?("test_save_0")).to eql(false)
    end

    it "returns true if called and the file './test_saves/test_save_0.yaml' exists" do
      game_options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(game_options)
      saves_path = "./test_saves"
      game_save_options = {
        path: saves_path,
        file_extension: '.yaml',
        name_prefix: 'test_save_',
        game: game
      }
      game_save = GameSave.new(game_save_options)
      delete_saves_folder(saves_path)
      Dir.mkdir(saves_path)
      create_test_saves(saves_path, 1)
      expect(game_save.save_exists?("test_save_0")).to eql(true)
    end
  end

  describe "#count_saves" do
    it "returns 0 if called and the 'saves' folder does not exist" do
      game_options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(game_options)
      saves_path = "./test_saves"
      game_save_options = {
        path: saves_path,
        file_extension: '.yaml',
        name_prefix: 'test_save_',
        game: game
      }
      game_save = GameSave.new(game_save_options)
      delete_saves_folder(saves_path)
      expect(game_save.count_saves).to eql(0)
    end

    it "returns 0 if called and the 'saves' folder exists but is empty" do
      game_options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(game_options)
      saves_path = "./test_saves"
      game_save_options = {
        path: saves_path,
        file_extension: '.yaml',
        name_prefix: 'test_save_',
        game: game
      }
      game_save = GameSave.new(game_save_options)
      delete_saves_folder(saves_path)
      Dir.mkdir(saves_path)
      expect(game_save.count_saves).to eql(0)
    end

    it "returns 0 if called and the 'saves' folder exists but is empty" do
      game_options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(game_options)
      saves_path = "./test_saves"
      game_save_options = {
        path: saves_path,
        file_extension: '.yaml',
        name_prefix: 'test_save_',
        game: game
      }
      game_save = GameSave.new(game_save_options)
      delete_saves_folder(saves_path)
      Dir.mkdir(saves_path)
      create_test_saves(saves_path, 3)
      expect(game_save.count_saves).to eql(3)
    end
  end

  describe "#saves_list" do
    it "returns an empty array if called and the 'saves' folder does not exist" do
      game_options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(game_options)
      saves_path = "./test_saves"
      game_save_options = {
        path: saves_path,
        file_extension: '.yaml',
        name_prefix: 'test_save_',
        game: game
      }
      game_save = GameSave.new(game_save_options)
      delete_saves_folder(saves_path)
      expect(game_save.saves_list).to eql([])
    end

    it "returns an empty array if called and the 'saves' folder exists but is empty" do
      game_options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(game_options)
      saves_path = "./test_saves"
      game_save_options = {
        path: saves_path,
        file_extension: '.yaml',
        name_prefix: 'test_save_',
        game: game
      }
      game_save = GameSave.new(game_save_options)
      delete_saves_folder(saves_path)
      Dir.mkdir(saves_path)
      expect(game_save.saves_list).to eql([])
    end

    it "returns the correct string array if called with limit 3 and the 'saves' folder has 5 save files" do
      game_options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(game_options)
      saves_path = "./test_saves"
      game_save_options = {
        path: saves_path,
        file_extension: '.yaml',
        name_prefix: 'test_save_',
        game: game
      }
      game_save = GameSave.new(game_save_options)
      delete_saves_folder(saves_path)
      Dir.mkdir(saves_path)
      create_test_saves(saves_path, 5)
      res = game_save.saves_list(3)
      expected = ["test_save_0", "test_save_1", "test_save_2"]
      expect(res.size).to eql(expected.size)
      expected.each do |save_name|
        expect(res.include?(save_name)).to eql(true)
      end
    end
  end

  describe "#create_save" do
    it "does nothing and returns '' if called with a nil game" do
      game_options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(game_options)
      saves_path = "./test_saves"
      game_save_options = {
        path: saves_path,
        file_extension: '.yaml',
        name_prefix: 'test_save_',
        game: nil
      }
      game_save = GameSave.new(game_save_options)
      delete_saves_folder(saves_path)
      saves_count = Dir.glob(
        "#{saves_path}/test_save_*#{@file_extension}"
      ).length
      expect(game_save.create_save).to eql("")
      expect(saves_count).to eql(0)
    end

    it "creates the 'saves' folder and creates the save file in the 'saves' folder and returns the correct string if called on a valid game and the 'saves' folder does not exist" do
      game_options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(game_options)
      saves_path = "./test_saves"
      game_save_options = {
        path: saves_path,
        file_extension: '.yaml',
        name_prefix: 'test_save_',
        game: game
      }
      game_save = GameSave.new(game_save_options)
      delete_saves_folder(saves_path)
      res_name = game_save.create_save
      saves_count = Dir.glob(
        "#{saves_path}/test_save_*#{@file_extension}"
      ).length
      expect(res_name).to eql('test_save_0')
      expect(saves_count).to eql(1)
    end

    it "creates the save file in the 'saves' folder and returns the correct string if called on a valid game and the 'saves' folder already has some existing save files" do
      game_options = {
        piece_factory_class: PieceFactory,
        player_class: MockPlayer
      }
      game = Game.new(game_options)
      saves_path = "./test_saves"
      game_save_options = {
        path: saves_path,
        file_extension: '.yaml',
        name_prefix: 'test_save_',
        game: game
      }
      game_save = GameSave.new(game_save_options)
      delete_saves_folder(saves_path)
      Dir.mkdir(saves_path)
      create_test_saves(saves_path, 2)
      res_name = game_save.create_save
      saves_count = Dir.glob(
        "#{saves_path}/test_save_*#{@file_extension}"
      ).length
      expect(res_name).to eql('test_save_2')
      expect(saves_count).to eql(3)
    end
  end
end
