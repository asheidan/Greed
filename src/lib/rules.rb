
module Rules
  def self.apply_rules(dice)
    rules.collect do |rule|
      # TODO: Object creation in Ruby isn't great, possible optimization here
      points, rethrow = rule.new.apply(dice)
      if rethrow.empty? || points == 0
        points
      else
        (points + apply_rules(rethrow))
      end
    end.max
  end
  
  # Returns a sorted Array with all Classes in this module (no submodules)
  def self.rules
    self.constants.sort.collect do |const_name|
      c = self.const_get( const_name )
      c if c.is_a? Class
    end
  end
end
