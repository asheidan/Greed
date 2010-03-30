require 'test/unit'

$LOAD_PATH << 'lib' if !($:.include?("lib"))
require 'rules'

class TestRule < Test::Unit::TestCase

  def test_all_rules_applied_to_no_dice_should_return_zero
    points = Rules.apply_rules( [] )
    assert_equal(0,points)
  end
end

