require 'test/unit'

require 'throw'

class TestThrow < Test::Unit::TestCase
  def setup
    @throw = Throw.new
  end
  
  def test_00_instance_should_not_be_nil
    assert_not_nil(@throw)
  end
  
  def test_01_new_throw_should_have_sixe_dice
    assert_equal(6, @throw.size)
  end
  
  def test_02_new_throw_should_convert_to_a_with_six_Fixnum
    a = @throw.to_a
    assert_kind_of(Array, a)
    assert_equal(6, a.size)
    a.each{ |d|
      assert_kind_of(Fixnum, d)
    }
  end
  
  def test_03_throw_to_string_should_generate_string
    assert_kind_of(String, @throw.to_s)
  end
  
  def test_04_reroll_should_reroll_dice
    initial = @throw.clone.to_a
    @throw.reroll!
    assert_not_same(initial, @throw.to_a)
  end
  
  def test_05_new_throw_shouldnt_have_saved_dice
    assert_equal([], @throw.saved)
  end
  
  def test_06_saving_a_die_should_add_it_to_saved_dice
    element = @throw.dice.shuffle.first
    @throw.save element
    assert_equal([element], @throw.saved)
  end
  
  def test_07_saving_other_than_existing_dice_should_not_affect_throw
    @throw.save 42
    assert_equal([], @throw.saved)
  end
  
  def test_08_saving_element_should_make_it_survive_reroll
    element = @throw.dice.shuffle.first
    @throw.save element
    # Trying to make statistically sure that we save the dice
    result = ([nil]*100).select {
      @throw.reroll!
      !@throw.dice.include?(element)
    }
    assert_equal(0, result.size)
  end
  
  def test_09_clearing_saved_dice_should_make_saved_empty
    @throw.save(@throw.to_a.first)
    @throw.clear_saved
    assert_equal([], @throw.saved)
  end
  
  def test_10_clearing_and_rerolling_should_make_throw_contain_6_dice
    @throw.save(@throw.to_a.first)
    @throw.clear_saved
    @throw.reroll!
    assert_equal(6, @throw.size)
  end
  
  def test_11_new_throw_roll_should_contain_6_Fixnum
    assert_equal(6, @throw.rolled.size)
    @throw.rolled.each{ |d|
      assert_kind_of(Fixnum, d)
    }
  end
  
  def test_12_saving_several_elements_should_save
    Throw.class_eval do
      attr_writer :rolled
    end
    
    @throw.rolled = [1,1,1,1,1,1]
    @throw.save 1
    @throw.save 1
    
    assert_equal([1,1], @throw.saved)
    assert_equal([1,1,1,1], @throw.rolled)
  end
  
  def test_13_setting_roll_should_update_saved
    Throw.class_eval do
      attr_writer :rolled
    end
    
    @throw.rolled = [1,2,3,4,5,6]
    @throw.roll = [1,2,3]
    assert_equal([1,2,3], @throw.rolled)
    assert_equal([4,5,6], @throw.saved)
  end
  
  def test_14_saving_three_of_a_kind
    Throw.class_eval do
      attr_writer :rolled
    end
    
    @throw.rolled = [1,1,1,4,5,6]
    @throw.roll = [4,5,6]
    assert_equal([4,5,6], @throw.rolled)
    assert_equal([1,1,1], @throw.saved)
  end
  
  def test_15_changing_returned_rolled_array_shouldnt_change_instance_array
    returned = @throw.rolled
    returned.delete_at 0
    assert_not_equal(returned, @throw.rolled)
  end

  def test_15_changing_returned_saved_array_shouldnt_change_instance_array
    returned = @throw.saved
    returned << "arne"
    assert_not_equal(returned, @throw.saved)
  end
end