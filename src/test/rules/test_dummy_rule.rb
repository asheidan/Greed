require "test/unit"

require "rules/is_a_rule"
require "rules/dummy_rule"

class TestDummyRule < Test::Unit::TestCase
  def setup
    @rule = Rules::DummyRule.new
  end
  
  include IsARule
  
end