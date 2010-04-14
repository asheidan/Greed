module Rules
  # Implements a rule which gives 1000 points for a straight
  class StreetRule
    def apply(dice)
      if dice.sort == [1,2,3,4,5,6]
        return 1000,[]
      else
        return 0,dice
      end
    end
  end
end