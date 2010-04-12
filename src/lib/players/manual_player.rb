require 'players/dummy_player'
require 'ui/manual_window'

module Players
  
  # The manual player is not controlled by the computer, it is controlled by
  # the user that is running the program. That means that the player object
  # is note responsible for making any decisions. It will however delegate 
  # those decisions to the user using the user interface.
  
  class ManualPlayer < DummyPlayer
    
    # Creates a graphical user interface object which is used to interact
    # with the user.
    def initialize(name = '')
      super(name)
      @ui = UI::ManualWindow.new
    end
    
    # Called by server with information about all players scores
    def update_scoreboard(scores = {})
      @ui.update_scoreboard(scores)
    end
    
    # Called by server with information about current turn
    def status_update(name, dice, saved=[])
      @ui.status_update(name, dice, saved)
    end
    
    # Called by server when it's this players turn.
    # The method returns an Array with the dice the player want's to throw
    # again and an empty Array when it's time to save.
    def roll(dice)
      @ui.roll(dice, @name)
    end
    
    # Called by server when a joining a game.
    def limits(limit, bust)
      super(limit, bust)
      @ui.limits(limit,bust)
    end
  end
end