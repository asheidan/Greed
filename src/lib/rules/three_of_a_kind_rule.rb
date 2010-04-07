require 'monkeys/array_helper'

module Rules
  class ThreeOfAKindRule
    def apply(dice)
      dice = dice.clone
      points = 0
      dice.freq.to_a.collect{|k,v| k if v >= 3}.compact.each do |k|
        points += points_table(k)
        dice.remove_three!(k)
      end
      return points, dice
    end
    
    private
    def points_table(n)
      if n == 1 then
        1000
      else
        n * 100
      end
    end
  end
end