require './lib/Game'
require './lib/PieceFactory'
require './lib/GameSave'
require './spec/MockPlayer'
require './lib/CommandRunner'

# Helper methods

def delete_saves_folder(folder_path)
  saves = Dir.glob("#{folder_path}/*")
  saves.each { |f| File.delete(f) } if saves.size > 0
  Dir.rmdir(folder_path) if Dir.exist?(folder_path)
end

# Tests

describe CommandRunner do
  describe "#initialize" do
    it "returns a non-nil object if called with a hash containing a mock game object" do
      mock_game = nil
      command_runner = CommandRunner.new({ game: mock_game })
      expect(command_runner).not_to eql(nil)
    end
  end

  describe "#game_meets_prereqs" do
    it "returns false if called with a valid game object that is missing the correct number of players" do
      options = {
        piece_factory_class: PieceFactory,
        game_save_class: GameSave,
        player_class: nil,
        human_player_class: MockPlayer,
      }
      game = Game.new(options)
      command_runner = CommandRunner.new({ game: game })
      res = command_runner.game_meets_prereqs?
      expect(res).to eql(false)
    end

    it "returns true if called with a valid game object that has all the required dependencies" do
      options = {
        piece_factory_class: PieceFactory,
        game_save_class: GameSave,
        player_class: MockPlayer,
        human_player_class: MockPlayer,
      }
      game = Game.new(options)
      command_runner = CommandRunner.new({ game: game })
      res = command_runner.game_meets_prereqs?
      expect(res).to eql(true)
    end
  end

  describe "#can_new_game?" do
    it "returns false if called with '!new' on a CommandRunner object that is not in the correct app mode that has a valid game object that has all the required dependencies " do
      options = {
        piece_factory_class: PieceFactory,
        game_save_class: GameSave,
        player_class: MockPlayer,
        human_player_class: MockPlayer,
      }
      game = Game.new(options)
      command_runner = CommandRunner.new({ game: game })
      command_runner.set_setup_mode!
      res = command_runner.can_new_game?("!new")
      expect(res).to eql(false)
    end

    it "returns false if called with 'new game' on a CommandRunner object that is in the correct app mode that has a valid game object that has all the required dependencies " do
      options = {
        piece_factory_class: PieceFactory,
        game_save_class: GameSave,
        player_class: MockPlayer,
        human_player_class: MockPlayer,
      }
      game = Game.new(options)
      command_runner = CommandRunner.new({ game: game })
      command_runner.set_load_mode!
      res = command_runner.can_new_game?("new game")
      expect(res).to eql(false)
    end

    it "returns true if called with '!new' on a CommandRunner object that is in the correct app mode that has a valid game object that has all the required dependencies " do
      options = {
        piece_factory_class: PieceFactory,
        game_save_class: GameSave,
        player_class: MockPlayer,
        human_player_class: MockPlayer,
      }
      game = Game.new(options)
      command_runner = CommandRunner.new({ game: game })
      command_runner.set_load_mode!
      res = command_runner.can_new_game?("!new")
      expect(res).to eql(true)
    end
  end

  describe "#new_game!" do
    it "sets its app mode to the in-game mode if called with '!new' on a CommandRunner object that is in the correct app mode that has a valid game object that has all the required dependencies " do
      options = {
        piece_factory_class: PieceFactory,
        game_save_class: GameSave,
        player_class: MockPlayer,
        human_player_class: MockPlayer,
      }
      game = Game.new(options)
      command_runner = CommandRunner.new({ game: game })
      command_runner.set_load_mode!
      command_runner.new_game!("!new")
      res = command_runner.app_mode
      expect(res).to eql(:in_game)
    end
  end
end
