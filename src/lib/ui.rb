require 'tk'

# Creating the window that is displayed when playing the game.
def create_game_window
  top = TkToplevel.new(root) do
    title 'Game'
  end
  
  TkFrame.new(top) do
    TkLabelFrame.new(self) do
      TkLabel.new(self) do
        text 'Currently playing: name'
        pack
      end
      TkLabel.new(self) do
        text 'Score for this turn: #'
        pack
      end
      TkFrame.new(self) do
        buttons = []
        6.times do |num|
          TkFrame.new(self) do
            TkLabel.new(self) do
              text '#'
              bind '1' do
                buttons[num].toggle
              end
              pack
            end
            buttons << TkCheckButton.new(self) do
              pack
            end
            pack :side => :left
          end
        end
        pack
      end
      TkFrame.new(self) do
        TkButton.new(self) do
          text 'Roll'
          pack :side => :left
        end
        TkButton.new(self) do
          text 'Stay'
          pack :side => :left
        end
        pack
      end
      text 'Turn Status'
      pack :fill => :x
    end
  
    TkFrame.new(self) do
      TkLabelFrame.new(self) do
        TkScrollbox.new(self) do
          pack :fill => :x
        end
        TkLabel.new(self) do
          text 'Win limit: #  Bust limit: #'
          pack
        end
        text 'Game Status'
        pack :fill => :x
      end
      pack :fill => :x
    end
    
    TkFrame.new(self) do
      TkButton.new(self) do
        text 'Leave Game'
        command do
          top.destroy
        end
        pack
      end
      pack
    end
    
    pady 2
    padx 2
    pack
  end
end

# Creates a window from where a completely new game can be launched.
def create_new_game_window
  top = TkToplevel.new(root) do
    title 'New Game'
  end
  
  TkLabelFrame.new(top) do
    TkLabel.new(self) do
      text 'Win limit:'
      grid :row => 0, :column => 0, :sticky => :e
    end
    TkEntry.new(self) do
      grid :row => 0, :column => 1
    end
    TkLabel.new(self) do
      text 'Bust limit:'
      grid :row => 1, :column => 0, :sticky => :e
    end
    TkEntry.new(self) do
      grid :row => 1, :column => 1
    end
    TkLabel.new(self) do
      text 'Service:'
      grid :row => 2, :column => 0, :sticky => :e
    end
    TkEntry.new(self) do
      grid :row => 2, :column => 1
    end
    
    text 'Game Details'
    pady 2
    padx 2
    pack
  end
  
  TkFrame.new(top) do
    TkButton.new(self) do
      text 'Cancel'
      command do
        top.destroy
      end
      grid :row => 0, :column => 0
    end
    
    TkButton.new(self) do
      text 'Launch'
      command do
        create_game_window
        top.destroy
      end
      grid :row => 0, :column => 1
    end
    
    pady 2
    padx 2
    pack
  end
end

# Creates a window from where a connection can be made to an existing game.
def create_existing_game_window
  top = TkToplevel.new(root) do
    title 'Existing Game'
  end
  
  # Has to declare them here or configure won't find them
  host_entry = service_entry = nil
  
  TkLabelFrame.new(top) do
    TkFrame.new(self) do
      choice = TkVariable.new
      TkRadioButton.new(self) do
        text 'Localhost'
        value :localhost
        variable choice
        select
        command do
          host_entry.configure :state, :disabled
          service_entry.configure :state, :disabled
        end
        pack :side => :left
      end
      TkRadioButton.new(self) do
        text 'Remote'
        value :remote
        variable choice
        deselect
        command do
          host_entry.configure :state, :normal
          service_entry.configure :state, :normal
        end
        pack :side => :left
      end
      pack
    end
    
    TkFrame.new(self) do
      TkLabel.new(self) do
        text 'Host:'
        grid :row => 0, :column => 0, :sticky => :e
      end
      host_entry = TkEntry.new(self) do
        state :disabled
        grid :row => 0, :column => 1
      end
      TkLabel.new(self) do
        text 'Service:'
        grid :row => 1, :column => 0, :sticky => :e
      end
      service_entry = TkEntry.new(self) do
        state :disabled
        grid :row => 1, :column => 1
      end
      pack
    end
    
    text 'Game Details'
    pady 2
    padx 2
    pack
  end
  
  TkFrame.new(top) do
    TkButton.new(self) do
      text 'Cancel'
      command do
        top.destroy
      end
      grid :row => 0, :column => 0
    end
    
    TkButton.new(self) do
      text 'Connect'
      command do
        create_game_window
        top.destroy
      end
      grid :row => 0, :column => 1
    end
    
    pady 2
    padx 2
    pack
  end
end

# Creates the main (first?) window. From there new games can be launched and
# connections can be made to existing ones.
def create_main_window
  root = TkRoot.new do
    title 'Greed'
  end
  
  TkLabel.new(root) do
    text 'Shall we play a game?'
    pack
  end
  
  TkFrame.new(root) do
    TkLabel.new(self) do
      text 'Name:'
      pack :side => :left
    end
    TkEntry.new(self) do
      pack :side => :left
    end
    
    pady 2
    padx 2
    pack
  end
    
  TkFrame.new(root) do
    TkButton.new(self) do
      text 'New Game'
      command do
        create_new_game_window
      end
      grid :row => 1, :column => 0
    end

    TkButton.new(self) do
      text 'Existing Game'
      command do
        create_existing_game_window
      end
      grid :row => 1, :column => 1
    end

    TkButton.new(self) do
      text 'Quit'
      command do
         Tk.root.destroy
       end
      grid :row => 1, :column => 2
    end
    
    pady 2
    padx 2
    pack
  end
end

create_main_window
Tk.mainloop