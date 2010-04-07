require 'players/dummy_player'
require 'rules/three_of_a_kind_rule'

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
        dice.freq.to_a.collect do |k,v|
          if v == 6 then
            [k,k]
          elsif v >= 3 then
            k
          end
        end.compact.flatten.each{|k| dice.remove_three!(k) }
      end
      dice.reject{|die| die == 1 || die == 5 }
    end
  end
end
