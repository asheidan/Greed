require 'players/dummy_player'

module Players

  # RandomPlayer2 saves 50% of times when given a decision. When a save
  #  doesn't occur it will reroll a random amount of dice
  class RandomPlayer2 < DummyPlayer
    def roll(dice)
      if rand(2) == 0
        []
      else
        dice.shuffle.first(rand(dice.length)+1)
      end
    end
  end
end
