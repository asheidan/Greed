require "test/unit"

require "rules/is_a_rule"
require "rules/three_of_a_kind_rule"

class TestThreeOfAKindRule < Test::Unit::TestCase
  def setup
    @rule = Rules::ThreeOfAKindRule.new
  end
  
  include IsARule
  
  def test_00_1000_points_for_three_ones
    points, dice = @rule.apply( [1,1,1] )
    assert_equal(1000, points)
    assert_equal([], dice)
  end
  
  def test_01_200_points_for_three_twos
    points, dice = @rule.apply( [2,2,2] )
    assert_equal(200, points)
    assert_equal([], dice)
  end
  
  def test_02_300_points_for_three_threes
    points, dice = @rule.apply( [3,3,3] )
    assert_equal(300, points)
    assert_equal([], dice)
  end

  def test_03_400_points_for_three_fours
    points, dice = @rule.apply( [4,4,4] )
    assert_equal(400, points)
    assert_equal([], dice)
  end

  def test_04_500_points_for_three_fives
    points, dice = @rule.apply( [5,5,5,2] )
    assert_equal(500, points)
    assert_equal([2], dice)
  end

  def test_05_600_points_for_three_sixes
    points, dice = @rule.apply( [3,4,6,6,2,6] )
    assert_equal(600, points)
    assert_equal([3,4,2], dice)
  end

  def test_06_apply_should_not_change_argument
    dice = [3,3,3,4,1,6]
    @rule.apply(dice)
    assert_equal([3,3,3,4,1,6], dice)
  end
end