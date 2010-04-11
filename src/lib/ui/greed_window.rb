require 'tk'

module UI
  class GreedWindow
    def initialize(app)
      root = TkRoot.new do
        title 'Greed'
      end
      
      TkFrame.new(root) do
        TkLabel.new(self) do
          image TkPhotoImage.new(:file => 'ruby.gif')
          pack
        end
        
        TkButton.new(self) do
          text 'New Game'
          command do
            app.spawn_server
          end
          pack :fill => :x
        end
        
        TkButton.new(self) do
          text 'Connect To Game'
          command do
            app.spawn_client
          end
          pack :fill => :x
        end
        
        TkButton.new(self) do
          text 'Quit'
          command do
            root.destroy
          end
          pack :fill => :x
        end
        
        pady 10
        padx 10
        pack
      end
    end
  end
end