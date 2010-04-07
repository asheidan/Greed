require 'players/dummy_player'

module Players
  # CleverPlayer plays differently depending on 
  class CleverPlayer < DummyPlayer
    def roll(dice)
      dice
    end
    
    # Calculates the position of the player normalized against the leading
    # and the lest player.
    def position
      (@scores[@name] - @scores.values.min) / (@scores.values.max - @scores.values.min)
    end
    
    def update_scoreboard(scores = {})
      @scores = scores
    end
  end
end