module Rules
  class OnesAndFivesRule
    def apply(dice)
      points = !dice.empty? ? 100 : 0
      return points,[]
    end
  end
end