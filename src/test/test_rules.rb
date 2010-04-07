require 'test/unit'
require 'logger'

$LOAD_PATH << 'lib' if !($:.include?("lib"))
require 'rules'
$rule_files = Dir.glob('../**/lib/rules/*_rule.rb').sort
$rule_files.each do |f| 
  require "rules/"+File.basename(f)
end

# Logger.new(STDERR).debug $rule_files

class TestRule < Test::Unit::TestCase

  def test_00_all_rules_applied_to_no_dice_should_return_zero
    result = Rules.apply_rules( [] )
    assert_equal([0,[]],result)
  end
  
  def test_01_should_find_all_rules
    found_rules = Rules::rules
    real_rules = $rule_files.collect do |f|
      # turns "apa_bepa" into "ApaBepa", can probably be done in a better way
      camelcased = File.basename(f,'.rb').split('_').collect{|s| s.capitalize}.join
      Rules.const_get( camelcased )
    end
    assert_equal(real_rules, found_rules)
  end
  
  def test_02_should_compute_points_correctly_for_a_single_die
    # puts Rules.rules.inspect
    result = Rules.apply_rules([1])
    assert_equal([100,[]], result)
  end
  
  def test_03_should_return_no_points_when_no_rules_apply
    initial_dice = [2,3,4,2,3,4]
    result = Rules.apply_rules( initial_dice )
    assert_equal([0, initial_dice], result)
  end
  
  def test_04_should_return_correct_points_when_two_rules_apply
    points = Rules.apply_rules( [1,3,6,4,4,4] )
    assert_equal([500,[3,6]], points)
  end
  
  def test_05_max_points_should_return_Fixnum
    points = Rules.max_points([1,2,3,4,5,6])
    assert_equal(1000, points)
  end
  
  def test_temp
    points = Rules.max_points([2, 3, 3, 3, 5, 6])
    assert_equal(350, points)
    points, unused = Rules.apply_rules([2, 3, 3, 3, 5, 6])
    assert_equal(350, points)
  end
end

