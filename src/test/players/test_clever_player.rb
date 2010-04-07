require 'test/unit'

require 'players/is_a_player'
require 'players/clever_player'

class TestCleverlayer < Test::Unit::TestCase
  def setup
    @player = Players::CleverPlayer.new 'Nisse'
  end
  
  include IsAPlayer

  def test_00_clever_in_middle_position_should_have_position_between_0_and_1
    scores = {
      'Anna' => 5.0,
      'Nisse' => 10.9,
      'Sonja' => 15.0,
    }
    @player.update_scoreboard(scores)
    assert_in_delta(0.5, @player.position, 0.5)
  end
  
  def test_01_clever_in_leading_position_should_have_position_of_1
    scores = {
      'Anna' => 5.0,
      'Nisse' => 15.0,
      'Sonja' => 10.0,
    }
    @player.update_scoreboard(scores)
    assert_equal(1.0, @player.position)
  end

  def test_02_clever_in_last_position_should_have_position_of_0
    scores = {
      'Anna' => 10.0,
      'Nisse' => 5.0,
      'Sonja' => 15.0,
    }
    @player.update_scoreboard(scores)
    assert_equal(0.0, @player.position)
  end
end