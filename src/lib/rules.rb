require 'rules/dummy_rule'


module Rules
  @rules = [DummyRule.new]
  def self.apply_rules(dice)
    @rules.collect do |rule|
      points, dice = rule.apply(dice)
      if dice.empty?
        points
      else
        points + apply_rules(dice)
      end
    end.max
  end
end
