require 'players/dummy_player'

class Array
  def remove_three!(n)
    remove!(n,3)
  end
  
  def remove!(element,number)
    reject! do |e|
      if e == element then
        if number <= 0 then
          false
        else
          number -= 1
          true
        end
      else
        false
      end
    end
  end
end

module Players
  
  # GamblerPlayer implements a foolheardy greed-player
  # Gambler saves Street and 3 of a kind. Right now the player doesn't
  # reroll everything if it gets a street or points on all af the dice
  class GamblerPlayer < DummyPlayer
    def roll(dice)
      if dice.sort == [1,2,3,4,5,6] # Street
        dice = []
      elsif dice.count >= 3
        freq = {
          1 => 0, 2 => 0, 3 => 0,
          4 => 0, 5 => 0, 6 => 0
        }
        dice.each{|n| freq[n] += 1 }
        freq.to_a.collect do |k,v|
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
