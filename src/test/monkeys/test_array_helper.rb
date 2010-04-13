require 'test/unit'

require 'monkeys/array_helper'

class TestArrayHelper < Test::Unit::TestCase
  def test_00_array_sum_should_returm_correct_value
    a = [1,2,3,4,5,6,7,8,9]
    assert_equal(45, a.sum)
  end
  
  def test_01_array_freq_should_return_correct_value
    a = [1,1,1,2,4,4,9]
    assert_equal({1 => 3,2 => 1,4 => 2,9 => 1}, a.freq)
  end
  
  def test_02_removing_unexisting_element_shouldnt_affect_array
    a = [1,3,6,3,8,3,4]
    b = a.clone
    b.remove!(9)
    assert_equal(a, b)
  end
  
  def test_03_removing_element_should_leave_twin
    a = [1,1,2,2]
    a.remove!(2)
    assert_equal([1,1,2], a)
  end
end