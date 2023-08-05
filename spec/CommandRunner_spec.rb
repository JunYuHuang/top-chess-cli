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
    it "returns false if called with '!new' on a CommandRunner object that is not in the correct app mode that has a valid game object that has all the required dependencies" do
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

    it "returns false if called with 'new game' on a CommandRunner object that is in the correct app mode that has a valid game object that has all the required dependencies" do
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

    it "returns true if called with '!new' on a CommandRunner object that is in the correct app mode that has a valid game object that has all the required dependencies" do
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
    it "sets its app mode to the in-game mode if called with '!new' on a CommandRunner object that is in the correct app mode that has a valid game object that has all the required dependencies" do
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

  describe "#can_save_game?" do
    it "returns false if called with '!save' on a CommandRunner object that is not in the correct app mode that has a valid game object that has all the required dependencies" do
      options = {
        piece_factory_class: PieceFactory,
        game_save_class: GameSave,
        player_class: MockPlayer,
        human_player_class: MockPlayer,
      }
      game = Game.new(options)
      command_runner = CommandRunner.new({ game: game })
      command_runner.set_load_mode!
      res = command_runner.can_save_game?("!save")
      expect(res).to eql(false)
    end

    it "returns false if called with 'save game' on a CommandRunner object that is in the correct app mode that has a valid game object that has all the required dependencies" do
      options = {
        piece_factory_class: PieceFactory,
        game_save_class: GameSave,
        player_class: MockPlayer,
        human_player_class: MockPlayer,
      }
      game = Game.new(options)
      command_runner = CommandRunner.new({ game: game })
      command_runner.set_in_game_mode!
      res = command_runner.can_save_game?("save game")
      expect(res).to eql(false)
    end

    it "returns true if called with '!save' on a CommandRunner object that is in the correct app mode that has a valid game object that has all the required dependencies" do
      options = {
        piece_factory_class: PieceFactory,
        game_save_class: GameSave,
        player_class: MockPlayer,
        human_player_class: MockPlayer,
      }
      game = Game.new(options)
      command_runner = CommandRunner.new({ game: game })
      command_runner.set_in_game_mode!
      res = command_runner.can_save_game?("!save")
      expect(res).to eql(true)
    end
  end

  describe "#save_game!" do
    it "sets its app mode to the in-game mode if called with '!save' on a CommandRunner object that is in the correct app mode that has a valid game object that has all the required dependencies" do
      saves_path = "./test_saves"
      delete_saves_folder(saves_path)
      options = {
        piece_factory_class: PieceFactory,
        game_save_class: GameSave,
        player_class: MockPlayer,
        human_player_class: MockPlayer,
      }
      game = Game.new(options)
      game.game_save.path = saves_path
      game.game_save.name_prefix = "test_save_"
      command_runner = CommandRunner.new({ game: game })
      command_runner.set_in_game_mode!
      res = command_runner.save_game!("!save")
      expect(res.include?("test_save_")).to eql(true)
      expect(command_runner.app_mode).to eql(:in_game)
    end
  end

  describe "#can_load_game?" do
    it "returns false if called with '!load test_save_0' on a CommandRunner object that is not in the correct app mode that has a valid game object that has all the required dependencies" do
      options = {
        piece_factory_class: PieceFactory,
        game_save_class: GameSave,
        player_class: MockPlayer,
        human_player_class: MockPlayer,
      }
      game = Game.new(options)
      command_runner = CommandRunner.new({ game: game })
      command_runner.set_in_game_mode!
      res = command_runner.can_load_game?("!load test_save_0")
      expect(res).to eql(false)
    end

    it "returns false if called with 'load game' on a CommandRunner object that is in the correct app mode that has a valid game object that has all the required dependencies" do
      options = {
        piece_factory_class: PieceFactory,
        game_save_class: GameSave,
        player_class: MockPlayer,
        human_player_class: MockPlayer,
      }
      game = Game.new(options)
      command_runner = CommandRunner.new({ game: game })
      command_runner.set_load_mode!
      res = command_runner.can_load_game?("load game")
      expect(res).to eql(false)
    end

    it "returns false if called with '!load test_save_0' on a CommandRunner object that is in the correct app mode that has a valid game object that has all the required dependencies but 'test_save_0' is not an existing save file" do
      saves_path = "./test_saves"
      delete_saves_folder(saves_path)
      options = {
        piece_factory_class: PieceFactory,
        game_save_class: GameSave,
        player_class: MockPlayer,
        human_player_class: MockPlayer,
      }
      game = Game.new(options)
      game.game_save.path = saves_path
      game.game_save.name_prefix = "test_save_"
      command_runner = CommandRunner.new({ game: game })
      command_runner.set_load_mode!
      res = command_runner.can_load_game?("!load test_save_0")
      expect(res).to eql(false)
    end

    it "returns true if called with '!load test_save_0' on a CommandRunner object that is in the correct app mode that has a valid game object that has all the required dependencies but 'test_save_0' is an existing valid save file" do
      saves_path = "./test_saves"
      delete_saves_folder(saves_path)
      options = {
        piece_factory_class: PieceFactory,
        game_save_class: GameSave,
        player_class: MockPlayer,
        human_player_class: MockPlayer,
      }
      game = Game.new(options)
      game.game_save.path = saves_path
      game.game_save.name_prefix = "test_save_"
      game.game_save.create_save
      command_runner = CommandRunner.new({ game: game })
      command_runner.set_load_mode!
      res = command_runner.can_load_game?("!load test_save_0")
      expect(res).to eql(true)
    end
  end

  describe "#load_game!" do
    it "sets its app mode to the in-game mode if called with '!load test_save_0' on a CommandRunner object that is in the correct app mode that has a valid game object that has all the required dependencies" do
      # create a game and save it
      saves_path = "./test_saves"
      delete_saves_folder(saves_path)
      options = {
        piece_factory_class: PieceFactory,
        game_save_class: GameSave,
        player_class: MockPlayer,
        human_player_class: MockPlayer,
      }
      game = Game.new(options)
      game.game_save.path = saves_path
      game.game_save.name_prefix = "test_save_"
      game.game_save.create_save
      command_runner = CommandRunner.new({ game: game })

      # reset some of the game state
      game.turn_color = nil
      game.board = nil
      game.white_captured = nil
      game.black_captured = nil

      # load the game and check if the game's state was updated correctly
      command_runner.set_load_mode!
      command_runner.load_game!("!load test_save_0")
      expect(command_runner.app_mode).to eql(:in_game)
      expect(game.turn_color).to eql(:white)
      expect(game.board.size).to eql(8)
      expect(game.board[0].size).to eql(8)
      expect(game.players.size).to eql(2)
      game.players.each do |player_obj|
        expect(player_obj.class).to eql(MockPlayer)
      end
      expect(game.white_captured.size).to eql(5)
      expect(game.black_captured.size).to eql(5)
    end
  end
end
