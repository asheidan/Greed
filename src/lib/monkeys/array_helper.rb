class Array
  def sum
    result = 0
    each do |e|
      result += e
    end
    result
  end

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