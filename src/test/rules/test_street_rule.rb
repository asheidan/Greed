require "test/unit"

require "rules/is_a_rule"
require "rules/street_rule"

class TestStreetRule < Test::Unit::TestCase
  def setup
    @rule = Rules::StreetRule.new
  end
  
  include IsARule
  
  def test_00_no_street_should_be_0_points
    initial_dice = [1,4,2,6,3,4]
    points, dice = @rule.apply( initial_dice )
    assert_equal(0, points)
    assert_equal(initial_dice, dice)
  end
  
  def test_01_street_should_be_1000_points
    initial_dice = [1,2,3,4,5,6]
    points, dice = @rule.apply( initial_dice )
    assert_equal(1000, points)
    assert_equal([], dice)
  end
  
  def test_02_should_recognize_disorderly_street
    initial_dice = [4,5,1,2,3,6]
    points, dice = @rule.apply( initial_dice )
    assert_equal(1000, points)
    assert_equal([], dice)
  end
end