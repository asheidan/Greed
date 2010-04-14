require 'tk'

module UI
  class ClientWindow
    def initialize(client)
      host_var = TkVariable.new("localhost")
      port_var = TkVariable.new("8787")
      type_var = TkVariable.new(:Manual)
      name_var = TkVariable.new
      
      root = TkRoot.new do
        title 'Create player'
      end

      content_frame = TkFrame.new(root) do
        
        TkLabelFrame.new(self) do
          TkFrame.new(self) do
            TkLabel.new(self) do
              text 'Host:'
              grid :row => 0, :column => 0, :sticky => :e
            end
            host_entry = TkEntry.new(self) do
              textvariable host_var
              grid :row => 0, :column => 1
            end
            TkLabel.new(self) do
              text 'Port:'
              grid :row => 1, :column => 0, :sticky => :e
            end
            service_entry = TkEntry.new(self) do
              textvariable port_var
              grid :row => 1, :column => 1
            end
            pack
          end

          text 'Game Details'
          pady 2
          padx 2
          pack
        end

        TkLabelFrame.new(self) do
          TkLabel.new(self) do
            text 'Type:'
            grid :row => 0, :column => 0, :sticky => :e
          end
          TkFrame.new(self) do
            player_types = ['Manual', 'Clever', 'Coward', 'Gambler', 'Random']
            player_types.each do |type|
              TkRadioButton.new(self) do
                text type
                justify :left
                value type
                variable type_var
                #select if type.eql? 'Manual'
                pack :expand => true, :fill => :x
              end
            end
            grid :row => 0, :column => 1, :sticky => :w
          end
          TkLabel.new(self) do
            text 'Name:'
            grid :row => 1, :column => 0, :sticky => :e

          end
          TkEntry.new(self) do
            textvariable name_var
            grid :row => 1, :column => 1, :sticky => :w
          end

          text 'Player Details'
          pady 2
          padx 2
          pack :fill => :x
        end
        
        pady 2
        padx 2
        grid :row => 0, :column => 0
      end
      
      TkFrame.new(root) do
        TkButton.new(self) do
          text 'Quit'
          command do
            time_to_wait = 0
            $app_status = :will_quit
            while $state == :wait do
              time_to_wait = 1
            end
            client.disconnect
            sleep(time_to_wait)
            root.destroy
          end
          grid :row => 0, :column => 0
        end

        TkButton.new(self) do
          text 'Connect'
          command do
            client.host = host_var.value
            client.port = port_var.value
            client.type = type_var.value
            client.name = name_var.value
            
            if client.name.length == 0 then
              TkWarning.new("You have to enter a name")
              return
            end
            
            client.create_player
            
            root.title = client.name
            content_frame.ungrid
            state :disabled
            
            Thread.new do
              client.connect
            end
          end
          grid :row => 0, :column => 1
        end

        pady 2
        padx 2
        grid :row => 1, :column => 0
      end
    end
  end
end