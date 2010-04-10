require 'tk'
require 'drb/drb'
require 'ui/client_window'
require 'players/clever_player'
require 'players/coward_player'
require 'players/gambler_player'
require 'players/random_player'
require 'players/manual_player'

class Client
  
  # The client object is responsible for setting up a communication channel
  # to the server. Once the channel has been established however the control
  # is delegated to a player object which is responsible for answering to 
  # calls from the server.
  
  attr_accessor :host, :port, :type, :name
  
  def create_player
    case @type
    when 'Manual'
      @player = Players::ManualPlayer.new(@name)
    when 'Clever'
      @player = Players::CleverPlayer.new(@name)
    when 'Coward'
      @player = Players::CowardPlayer.new(@name)
    when 'Gambler'
      @player = Players::GamblerPlayer.new(@name)
    when 'Random'
      @player = Players::RandomPlayer.new(@name)
    end
  end
  
  def connect
    DRb.start_service
    @server = DRbObject.new_with_uri("druby://#{@host}:#{@port}")
    @server.connect(@player)
  end
  
  def disconnect
    @server.disconnect(@player) unless @server.nil?
    DRb.stop_service
  end
end

if __FILE__ == $0
  $app_status = :running
  client = Client.new
  UI::ClientWindow.new(client)
  Tk.mainloop
end