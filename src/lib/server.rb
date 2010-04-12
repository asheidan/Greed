require 'drb/drb'
require 'logger'
require 'rules'
require 'rules/ones_and_fives_rule'
require 'rules/three_of_a_kind_rule'
require 'rules/street_rule'

# $SAFE = 1

$log = Logger.new(STDERR)
$log.datetime_format = "%Y-%m-%d %H:%M:%S"

class Server
  # Makes this class unserializeable (object will not be sent over network)
  include DRbUndumped
  
  attr_reader :uri, :score_board
  attr_accessor :bust, :limit
  
  def initialize(port=nil, limit=10000, bust=300)
    $log.debug('initialize') { "port: #{port}" }
    @mutex = Mutex.new
    @clients = []
    @score_board = {}
    @uri = port.nil? ? nil : "druby://localhost:#{port}"
    
    @bust = bust
    @limit = limit
  end
  
  def start_service
    DRb.start_service(uri,self)
  end
  
  def stop_service
    DRb.stop_service
  end
  
  # Remotely called
  
  # Connects a client to the server and adds it to the game.
  def connect(client)
    $log.debug('connect'){ "Client connected: #{client.inspect}" }
    
    begin
      # Maybe this should run in another thread so this returns
      # and player receives limits when it's added.
      client.limits(@limit,@bust)
      client.update_scoreboard(@score_board)
      @mutex.synchronize {
        @clients << client
        @score_board[client.name] = @score_board[client.name].to_i
      }
    rescue DRb::DRbConnError
      $log.warn('connect'){ "Client wants to be connected but doesn't respond: #{client.inspect}"}
    end
  end
  
  def disconnect(client)
    # TODO: This method is sort of pointless
    # since the UI will hang untill the current round is finished
    # and the server will realize that the client disappeared when it doesn't
    # respond
    $log.debug('disconnect'){ "Client disconnected: #{client.inspect}" }
    @mutex.synchronize {
      @clients.delete client
    }
  end
  
  def start_game
    $log.info('start_game'){ "Game is commencing" }
    # TODO: If a game is already in progress clients shouldn't be able to start_game
    @mutex.synchronize{
      @clients.shuffle!
    }
    $log.debug('start_game'){ @clients }
    game
  end
  
  # Calls the specified method in all clients except those in except
  # with the given parameters.
  def broadcast(method, parameters, except=[])
    @clients.each do |c|
      if( !except.include? c ) then
        begin
          # $log.debug parameters
          c.__send__(method,*parameters)
        rescue DRb::DRbError => e
          $log.error('broadcast') { "Removing #{c.inspect} #{e.message}" }
          @clients.delete c
        end
      end
    end
  end
  private :broadcast
  
  # Sketch for game round. @clients should be shuffle!d before each game.
  def game
    loop do
      $log.debug('game'){ "--- New round ---"}
      @mutex.synchronize {
        @clients.each { |c|
          begin
            $log.debug('game'){ "---- #{c.name} ----"}
            broadcast(:update_scoreboard, [@score_board])
            round_score = 0
            saved_dice = throw_dice = []
            decision = [nil] * 6
            while decision != [] do
              rethrow_count = 6 - saved_dice.length
              throw_dice = decision.collect{|d| rand(6)+1 }.sort[0..(rethrow_count-1)]
              $log.debug('game: dice') {throw_dice}
              broadcast(:status_update, [c.name, throw_dice], [c])
              decision = c.roll(throw_dice)
              decision.each{ |d|
                throw_dice.remove!(d,1)
              }
              broadcast(:status_update, [c.name, throw_dice, saved_dice], [c])
              # Calculate score for saved dice
              throw_score = Rules.max_points( throw_dice )
              if round_score == 0 then
                if (throw_score >= @bust) then
                  round_score += throw_score
                  saved_dice += throw_dice
                else
                  $log.debug('game'){ "Player: #{c.name} busted" }
                  decision = []
                end
              elsif throw_score > 0 then
                saved_dice += throw_dice
                round_score += throw_score
                if saved_dice.length == 6 then
                  saved_dice = []
                end
              else
                $log.debug('game'){ "Player: #{c.name} got no points"}
                round_score = 0
                decision = []
              end
              $log.debug('game'){ "decision: #{decision.inspect}"}
            end
            @score_board[c.name] += round_score
            if @score_board[c.name] >= @limit then
              $log.debug('game'){ "#{c.name} won!"}
              return c
            end
          rescue DRb::DRbConnError
            $log.warn('game') { "Client not responding" }
            @clients.delete c
          end
        }
      }
      sleep 1 if @clients.empty?
    end
  end
  private :game
  
  def self.launch_server(port, limit, bust)
    @@server = Server.new(port, limit, bust)
    DRb::DRbServer.verbose = true
    @@server.start_service
    # Thread.new do
    #   DRb.thread.join
    # end
    @@server
  end
  
  def self.start_game
    Thread.new do
      @@server.start_game
    end
  end
  
end

# This section is true when running ruby "this file"
if __FILE__ == $0
  if require 'tk' then
    require 'ui/server_window'

    UI::ServerWindow.new
    Tk.mainloop
  else
    server = Server.new(port=8787)
    server.start_service
    server.start_game
  end
end