require "test/unit"

require 'test_rule'

require "rules/dummy_rule"

class TestDummyRule < Test::Unit::TestCase
  def setup
    @rule = Rules::DummyRule.new
  end
  
  include TestRule
  
end