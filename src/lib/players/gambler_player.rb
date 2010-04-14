require 'players/dummy_player'
require 'monkeys/array_helper'

module Players
  
  # GamblerPlayer implements a foolheardy greed-player
  # Gambler saves Street and 3 of a kind. Right now the player doesn't
  # reroll everything if it gets a street or points on all af the dice
  class GamblerPlayer < DummyPlayer
    def roll(dice)
      dice = dice.clone
      if dice.sort == [1,2,3,4,5,6] # Street
        dice = []
      elsif dice.count >= 3
        dice.freq.to_a.collect do |key,value|
          if value == 6 then
            [key,key]
          elsif value >= 3 then
            key
          end
        end.compact.flatten.each{|key| dice.remove_three!(key) }
      end
      dice.reject{|die| die == 1 || die == 5 }
    end
  end
end
