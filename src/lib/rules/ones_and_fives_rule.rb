module Rules
  class OnesAndFivesRule
    def apply(dice)
      points = 0
      rethrow = dice.select do |die|
        if die == 1
          points += 100
          false
        elsif die == 5
          points += 50
          false
        else
          true
        end
      end
      return points,rethrow
    end
  end
end