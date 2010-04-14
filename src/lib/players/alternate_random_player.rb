require 'players/dummy_player'

module Players

  # AlternateRandomPlayer saves 50% of times when given a decision. When a save
  #  doesn't occur it will reroll a random amount of dice
  class AlternateRandomPlayer < DummyPlayer
    def roll(dice)
      if rand(2) == 0
        []
      else
        dice.shuffle.first(rand(dice.length)+1)
      end
    end
  end
end
