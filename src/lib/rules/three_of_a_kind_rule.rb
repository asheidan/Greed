module Rules
  class ThreeOfAKindRule
    def apply(dice)
      points = 0
      if dice == [1,1,1]
        points =  1000
      elsif dice == [2,2,2]
        points = 200
      elsif dice == [3,3,3]
        points = 300
      end
      return points, []
    end
  end
end