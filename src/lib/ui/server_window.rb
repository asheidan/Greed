require 'tk'

module UI
  class ServerWindow
    def initialize
      win_var = TkVariable.new("10000")
      bust_var = TkVariable.new("300")
      port_var = TkVariable.new("8787")
      
      root = TkRoot.new do
        title 'Launch server'
      end

      content_frame = TkFrame.new(root) do
        
        TkLabelFrame.new(self) do
          TkFrame.new(self) do
            TkLabel.new(self) do
              text 'Win limit:'
              grid :row => 0, :column => 0, :sticky => :e
            end
            service_entry = TkEntry.new(self) do
              textvariable win_var
              grid :row => 0, :column => 1, :sticky => :w
            end
            TkLabel.new(self) do
              text 'Bust limit:'
              grid :row => 1, :column => 0, :sticky => :e
            end
            service_entry = TkEntry.new(self) do
              textvariable bust_var
              grid :row => 1, :column => 1, :sticky => :w
            end
            TkLabel.new(self) do
              text 'Port:'
              grid :row => 2, :column => 0, :sticky => :e

            end
            TkEntry.new(self) do
              textvariable port_var
              grid :row => 2, :column => 1, :sticky => :w
            end
            pack
          end

          text 'Game Details'
          pady 2
          padx 2
          pack
        end

        pady 2
        padx 2
        pack
      end
      
      TkFrame.new(root) do
        start_button = TkButton.new(self) do
          text 'Start Game'
          state :disabled
          command do
            start_button.state = :disabled
            Server.start_game
            Tk.root.title = "Game is running"
          end
          grid :row => 0, :column => 3
        end
        
        launch_button = TkButton.new(self) do
          text 'Launch Server'
          command do
            content_frame.unpack
            launch_button.state = :disabled
            start_button.state = :normal
            Server.launch_server(port_var.to_i, win_var.to_i, bust_var.to_i)
            Tk.root.title = "Server launched"
          end
          grid :row => 0, :column => 1
        end
        
        TkButton.new(self) do
          text 'Quit'
          command do
            root.destroy
          end
          grid :row => 0, :column => 0
        end

        pady 2
        padx 2
        pack
      end
    end
  end
end