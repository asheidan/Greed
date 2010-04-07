class Array
  def sum
    result = 0
    each do |e|
      result += e
    end
    result
  end
end