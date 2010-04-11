require 'tk'
require 'ui/greed_window'

class Greed
  def spawn_client
    fork do
      exec 'ruby client.rb'
    end
  end
  
  def spawn_server
    fork do
      exec 'ruby server.rb'
    end
  end
end

if __FILE__ == $0
  app = Greed.new
  UI::GreedWindow.new(app)
  Tk.mainloop
end