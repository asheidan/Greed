require 'test/unit'

$LOAD_PATH << 'lib' if !($:.include?("lib"))
require 'rules'
$rule_files = Dir.glob('lib/rules/*_rule.rb').sort
$rule_files.each {|f| require f }

class TestRule < Test::Unit::TestCase

  def test_all_rules_applied_to_no_dice_should_return_zero
    points = Rules.apply_rules( [] )
    assert_equal(0,points)
  end
  
  def test_should_find_all_rules
    found_rules = Rules::rules
    real_rules = $rule_files.collect do |f|
      # turns "apa_bepa" into "ApaBepa", can probably be done in a better way
      camelcased = File.basename(f,'.rb').split('_').collect{|s| s.capitalize}.join
      Rules.const_get( camelcased )
    end
    assert_equal(real_rules, found_rules)
  end
end

