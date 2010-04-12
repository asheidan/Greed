require 'drb/drb'

module Players
  
  # Inherit this class and override the methods you want/need/like
  class DummyPlayer
    
    include DRbUndumped
    
    def initialize(name = '')
      @name = name
      @limit = 10000
      @bust = 300
    end
    
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
    
    # Called by server when a joining a game.
    def limits(limit,bust)
      @limit = limit
      @bust = bust
    end
    
    # Just a string representing your name, should be unique
    def name
      @name.empty? ? to_s : @name
    end
    
    # TODO: Players should be notified when somebody wins
    # TODO: Player should start DRb service when connecting to remote host
  end
end
