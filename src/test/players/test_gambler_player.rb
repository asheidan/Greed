require "test/unit"

require 'players/is_a_player'
require 'players/gambler_player'

class TestGamblerPlayer < Test::Unit::TestCase
  def setup
    @player = Players::GamblerPlayer.new
  end
  
  include IsAPlayer
  
  def test_00_gambler_should_save_if_a_street
    rethrow = @player.roll( [1,2,3,4,5,6] )
    assert_equal([], rethrow)
  end
  
  def test_01_gambler_should_save_three_of_a_kind
    initial_throw = [2,2,3,4,4,4]
    rethrow = @player.roll( initial_throw )
    assert_equal([2,2,3], rethrow)
  end
  
  def test_02_gambler_should_save_two_three_of_a_kind
    initial_throw = [3,4,4,4,3,3]
    rethrow = @player.roll( initial_throw )
    assert_equal([], rethrow)
  end
  
  def test_03_gambler_should_not_save_trailing_of_a_kind
    initial_throw = [3,4,4,4,4,3]
    rethrow = @player.roll( initial_throw )
    assert_equal([3,4,3], rethrow)
  end

  def test_04_gambler_should_save_six_of_a_kind
    rethrow = @player.roll( [1,1,1,1,1,1] )
    assert_equal([], rethrow)
  end
  
  def test_05_gambler_should_save_1_and_5
    rethrow = @player.roll( [1,3,3,3,5,4])
    assert_equal([4], rethrow)
  end
end