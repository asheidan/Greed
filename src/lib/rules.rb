
module Rules
  
  # Makes a "brute force"-search of how many points the given dice can give
  def self.apply_rules(dice)
    rules.collect { |rule|
      # TODO: Object creation in Ruby isn't great, possible optimization here
      points, unused = rule.new.apply(dice)
      if points == 0 then
        [0,dice]
      elsif unused.empty? then
        [points, []]
      else
        other_points, unused = apply_rules(unused)
        [(points+other_points), unused]
      end
    }.max { |this,other| this.first <=> other.first }
  end
  
  def self.max_points(dice)
    apply_rules(dice).first
  end
  
  # Returns a sorted Array with all Classes in this module (no submodules)
  def self.rules
    self.constants.sort.collect do |const_name|
      klass = self.const_get( const_name )
      klass if klass.is_a? Class
    end
  end
end
