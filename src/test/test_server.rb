require 'test/unit'

require 'server'

require 'players/dummy_player'

# Hide log-messages
$log.level = Logger::WARN

class TestServer < Test::Unit::TestCase
  PORT = 8787

  def setup
    @server = Server.new( PORT )
  end
  
  def test_00_should_have_local_url_with_correct_port
    assert_equal("druby://localhost:#{PORT}", @server.uri)
  end
  
  def test_01_connecting_client_should_receive_limits
    # Adding used method to MockObject
    MockPlayer.class_eval do
      def limits(limit,bust)
        raise LimitsSuccessException
      end
      def update_scoreboard(*ignore)
      end
      def roll(*ignore)
        []
      end
    end
      
    client = MockPlayer.new
    assert_raise(LimitsSuccessException) {
      @server.connect(client)
    }
  end
  
  def test_02_connected_player_should_receive_scores_when_game_starts
    MockPlayer.class_eval do
      attr_reader :scores
      def limits(*ignore)
      end
      def roll(*ignore)
        []
      end
      def update_scoreboard(scores)
        @scores = scores
      end
    end
    
    player = MockPlayer.new
    @server.connect(player)
    
    @server.start_game
    assert_kind_of(Hash, player.scores)
  end
  
  def test_03_game_with_one_player_should_receive_roll_when_game_starts
    MockPlayer.class_eval do
      attr_reader :dice
      def limits(*ignore)
      end
      def update_scoreboard(*ignore)
      end
      def roll(dice)
        @dice = dice
        []
      end
    end
    
    player = MockPlayer.new
    @server.connect(player)
    
    @server.start_game
    dice = player.dice
    $log.debug('test: dice'){dice}
    assert_kind_of(Array, dice)
    assert_equal(6, dice.length)
  end
  
  def test_04_one_player_one_round
    MockPlayer.class_eval do
      attr_reader :scores, :limit, :bust
      def limits(limit, bust)
        @limit = limit
        @bust = bust
      end
      def update_scoreboard(scores)
        @scores = scores if @scores.nil?
      end
      def roll(*ignore)
        []
      end
    end
    
    player = MockPlayer.new
    
    @server.connect(player)
    @server.start_game
    
    assert_equal(10000, player.limit)
    assert_equal(300, player.bust)
    # assert_equal({player.name => 0}, player.scores)
  end
  
  def test_05_score_board_should_contain_connected_players
    MockPlayer.class_eval do
      attr_reader :name
      def initialize(name)
        @name = name
      end
      def limits(*ignore);end
    end
    
    player1 = MockPlayer.new("pelle")
    @server.connect(player1)
    player2 = MockPlayer.new("arne")
    @server.connect(player2)
    assert_equal([player1.name,player2.name].sort, @server.score_board.keys.sort)
  end
  
  def test_06_starting_a_game_when_a_game_is_in_progress_shouldnt_do_anything
    t = Thread.new do
      @server.start_game
    end
    assert_nil(@server.start_game)
    t.kill
  end
  
  def test_07_players_should_be_told_who_won
    require 'players/coward_player'
    MockPlayer.class_eval do
      attr_reader :winner
      def game_over(name)
        @winner = name
      end
      
      def roll(ignore)
        []
      end
    end
    
    name = "Nisse"
    dummy = MockPlayer.new(name)
    @server.connect dummy
    @server.start_game
    
    assert_equal(name, dummy.winner)
  end
end

class LimitsSuccessException < Exception; end

class MockPlayer < Players::DummyPlayer
  def name
    to_s
  end
end
  