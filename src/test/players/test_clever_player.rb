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
      'Nisse' => 10.0,
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
  
  def test_03_clever_should_save_if_a_street_if_behind
    scores = {
      'Anna' => 5.0,
      'Nisse' => 10.0,
      'Sonja' => 15.0,
    }
    @player.update_scoreboard(scores)
    rethrow = @player.roll( [1,2,3,4,5,6] )
    assert_equal([], rethrow)
  end
  
  def test_04_clever_should_save_three_of_a_kind_if_behind
    scores = {
      'Anna' => 5.0,
      'Nisse' => 10.0,
      'Sonja' => 15.0,
    }
    @player.update_scoreboard(scores)
    initial_throw = [2,2,3,4,4,4]
    rethrow = @player.roll( initial_throw )
    assert_equal([2,2,3], rethrow)
  end
  
  def test_05_clever_should_save_two_three_of_a_kind_if_behind
    scores = {
      'Anna' => 5.0,
      'Nisse' => 10.0,
      'Sonja' => 15.0,
    }
    @player.update_scoreboard(scores)
    initial_throw = [3,4,4,4,3,3]
    rethrow = @player.roll( initial_throw )
    assert_equal([], rethrow)
  end
  
  def test_06_clever_should_not_save_trailing_of_a_kind_if_behind
    scores = {
      'Anna' => 5.0,
      'Nisse' => 10.0,
      'Sonja' => 15.0,
    }
    @player.update_scoreboard(scores)
    initial_throw = [3,4,4,4,4,3]
    rethrow = @player.roll( initial_throw )
    assert_equal([3,4,3], rethrow)
  end

  def test_07_clever_should_save_six_of_a_kind_if_behind
    scores = {
      'Anna' => 5.0,
      'Nisse' => 10.0,
      'Sonja' => 15.0,
    }
    @player.update_scoreboard(scores)
    rethrow = @player.roll( [1,1,1,1,1,1] )
    assert_equal([], rethrow)
  end
  
  def test_08_clever_should_save_1_and_5_if_behind
    scores = {
      'Anna' => 5.0,
      'Nisse' => 10.0,
      'Sonja' => 15.0,
    }
    @player.update_scoreboard(scores)
    rethrow = @player.roll( [1,3,3,3,5,4])
    assert_equal([4], rethrow)
  end
end