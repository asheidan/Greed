class Array
  def sum
    result = 0
    each do |element|
      result += element.to_i
    end
    result
  end

  def freq
    freq_hash = {}
    each do |element|
      freq_hash[element] = freq_hash[element].to_i + 1 
    end
    freq_hash
  end
  
  def remove_three!(element)
    3.times { remove!(element) }
  end
    
  def remove!(element)
    element_index = index(element)
    unless element_index.nil? then
      delete_at element_index
    end
  end
  
end