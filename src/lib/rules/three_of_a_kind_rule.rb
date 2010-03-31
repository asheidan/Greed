class Array
  def freq
    f = {}
    each do |e|
      f[e] = f[e].to_i + 1 
    end
    f
  end
  
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

module Rules
  class ThreeOfAKindRule
    def apply(dice)
      points = 0
      dice.freq.to_a.collect{|k,v| k if v >= 3}.compact.each do |k|
        points += points_table(k)
        dice.remove_three!(k)
      end
      return points, dice
    end
    
    private
    def points_table(n)
      if n == 1 then
        1000
      else
        n * 100
      end
    end
  end
end