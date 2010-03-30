module Rules
  class DummyRule
    
    # All Rule-classes implements this method. The argument is a set of dice
    # and the return value should be a tuple where the first value is the
    # maximum points for this rule and the given dice and the second value
    # is an Array of the dice not used
    def apply(dice)
      return 0,[]
    end
  end
end