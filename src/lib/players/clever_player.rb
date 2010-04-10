require 'players/dummy_player'
require 'players/gambler_player'

module Players
  # CleverPlayer plays differently depending on the current position.
  # When it is not in the leading position it will take high risks and
  # try to win as fast as possible. When it is leading it will save 
  # direcly and not take any risks.
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
        begin
          (@scores[@name] - @scores.values.min) / (@scores.values.max - @scores.values.min)
        rescue ZeroDivisionError
          # For cases when max is equal to min, which can happen any time or always
          # when only one player is playing.
          1.0
        end
      else
        1.0
      end
    end
    
    def update_scoreboard(scores = {})
      @scores = scores
    end
  end
end