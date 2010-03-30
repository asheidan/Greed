module Players
  class DummyPlayer
    
    # Called by server with information about all players scores
    def update_scoreboard(scores = {})
    end
    
    # Called by server with information about current turn
    def status_update(name, dice, saved=[])
    end
    
    # Called by server when it's this players turn
    def roll(dice)
      dice
    end
  end
end
