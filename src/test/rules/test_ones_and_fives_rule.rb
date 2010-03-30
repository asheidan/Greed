require "test/unit"

require 'test_rule'
require 'rules/ones_and_fives_rule'

class TestOnesAndFivesRule < Test::Unit::TestCase
  def setup
    @rule = Rules::OnesAndFivesRule.new
  end
  
  include TestRule
  
  def test_00_no_dice_should_return_zero_points
    points, dice = @rule.apply( [] )
    assert_equal(0, points)
  end
  
  def test_01_one_one_should_equal_100_points
    points, dice = @rule.apply( [1] )
    assert_equal(100, points)
    assert(dice.empty?)
  end
  
  def test_02_two_ones_should_equal_200_points
    points, dice = @rule.apply( [1,1,3] )
    assert_equal(200, points)
    assert_equal([3], dice)
  end
  
  def test_03_one_five_should_equal_50_points
    points, dice = @rule.apply( [5] )
    assert_equal(50, points)
    assert(dice.empty?)
  end
  
  def test_04_no_ones_and_fives_should_equal_zero_points
    initial_dice = [2,3,4,6]
    points, dice = @rule.apply( initial_dice )
    assert_equal(0, points)
    assert_equal(initial_dice, dice)
  end
  
  def test_05_a_one_and_a_five_should_equal_150_points
    initial_dice = [1,2,3,4,5,6]
    points, dice = @rule.apply( initial_dice )
    assert_equal(150, points)
    assert_equal(initial_dice - [1,5], dice)
  end
end


