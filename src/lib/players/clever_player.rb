require 'players/dummy_player'
require 'players/gambler_player'

module Players
  # CleverPlayer plays differently depending on the current position.
  class CleverPlayer < DummyPlayer
    def roll(dice)
      GamblerPlayer.new.roll(dice)
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