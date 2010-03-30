module Players
  
  # Inherit this class and override the methods you want/need/like
  class DummyPlayer
    
    # Called by server with information about all players scores
    def update_scoreboard(scores = {})
    end
    
    # Called by server with information about current turn
    def status_update(name, dice, saved=[])
    end
    
    # Called by server when it's this players turn.
    # The method returns an Array with the dice the player want's to throw
    # again and an empty Array when it's time to save.
    def roll(dice)
      dice
    end
    
    # Called when a joining a game. 
    # Limits might look like this {:limit => 10000,:bust => 300}
    def limits(limits)
    end
  end
end
