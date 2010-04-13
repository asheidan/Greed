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
    3.times { remove!(n) }
  end
    
  def remove!(element)
    i = index(element)
    unless i.nil? then
      delete_at i
    end
  end
  
end