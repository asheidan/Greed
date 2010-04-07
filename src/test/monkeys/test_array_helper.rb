require 'test/unit'

require 'monkeys/array_helper'

class TestArrayHelper < Test::Unit::TestCase
  def test_00_array_sum_should_returm_correct_value
    a = [1,2,3,4,5,6,7,8,9]
    assert_equal(45, a.sum)
  end
end