require 'rules/ones_and_fives_rule'
require 'rules/street_rule'
require 'rules/three_of_a_kind_rule'
require 'players/dummy_player'
require 'players/gambler_player'

module Players
  # CleverPlayer plays differently depending on the current position.
  class CleverPlayer < DummyPlayer
    def roll(dice)
      if position < 1.0
        GamblerPlayer.new.roll(dice)
      else
        []
      end
    end
    
    # Calculates the position of the player normalized against the leading
    # and the lest player.
    def position
      if !@scores.nil? and @scores.include? @name
        (@scores[@name] - @scores.values.min) / (@scores.values.max - @scores.values.min)
      else
        1.0
      end
    end
    
    def update_scoreboard(scores = {})
      @scores = scores
    end
  end
end