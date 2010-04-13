require 'monkeys/array_helper'

# Represents a cup of dice and should be renamed
class Throw
  
  attr_reader :saved, :rolled
  
  def initialize(size = 6)
    @rolled = ([nil]*size).collect{ rand(6)+1 }.sort
    @saved = []
  end

  def size
    @rolled.size + @saved.size
  end

  def dice
    @rolled + @saved
  end

  def save(element)
    $log.debug('save'){ "saving: #{element.inspect}" } unless $log.nil?
    @saved << element if @rolled.include? element
    @rolled.remove!(element,1)
  end

  def clear_saved
    @saved = []
  end

  def reroll!
    @rolled = @rolled.collect{ rand(6)+1 }
    while( size < 6 ) do
      @rolled << rand(6)+1
    end
    @rolled.sort!
  end

  def to_s
    @rolled.inspect + "," + @saved.inspect
  end

  def to_a
    dice
  end
end