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
end


