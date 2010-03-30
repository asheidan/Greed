require 'rules/dummy_rule'

@rules = [DummyRule.new]

module Rules
  def apply_rules(dice)
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
