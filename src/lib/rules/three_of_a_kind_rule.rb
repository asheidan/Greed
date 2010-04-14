require 'monkeys/array_helper'

module Rules
  # Implements a rule which gives points for three of a kind
  class ThreeOfAKindRule
    def apply(dice)
      dice = dice.clone
      points = 0
      dice.freq.to_a.collect{|value,count| value if count >= 3}.compact.each do |value|
        points += points_table(value)
        dice.remove_three!(value)
      end
      return points, dice
    end
    
    private
    def points_table(value)
      if value == 1 then
        1000
      else
        value * 100
      end
    end
  end
end