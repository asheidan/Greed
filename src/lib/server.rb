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
  
  def initialize(port=nil)
    $log.debug('initialize') { "port: #{port}" }
    @mutex = Mutex.new
    @clients = []
    @score_board = {}
    @uri = port.nil? ? nil : "druby://localhost:#{port}"
    
    @bust = 300
    @limit = 10000
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
    
    # Maybe this should run in another thread so this returns
    # and player receives limits when it's added.
    @mutex.synchronize {
      @clients << client
      @score_board[client.name] = 0
    }
    client.limits(@limit,@bust)
  end
  
  def start_game
    @clients.shuffle!
    game
  end
  
  # Calls the specified method in all clients except those in except
  # with the given parameters.
  def broadcast(method, parameters, except=[])
    # @mutex.synchronize {
      @clients.each do |c|
        if( !except.include? c ) then
          begin
            # $log.debug parameters
            c.send(method,*parameters)
          rescue DRb::DRbError => e
            $log.error('broadcast') { "Removing #{c.inspect} #{e.message}" }
            @clients.delete c
          end
        end
      end
    # }
  end
  private :broadcast
  
  # Sketch for game round. @clients should be shuffle!d before each game.
  def game
    # Just one round implemented for now
    loop do
      @mutex.synchronize {
        @clients.each { |c|
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
            # broadcast(:status_update, [c.name, throw_dice], [c])
            # Calculate score for saved dice
            throw_score = Rules.apply_rules( throw_dice )
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
            else
              $log.debug('game'){ "Player: #{c.name} got no points"}
              round_score = 0
              decision = []
            end
          end
          
          @score_board[c.name] += round_score
          if @score_board[c.name] >= @limit then
            $log.debug('game'){ "#{c.name} won!"}
            return c
          end
        }
        sleep 1 if @clients.empty?
      }
    end
  end
  private :game
end

# This section is true when running ruby "this file"
if __FILE__ == $0
  server = Server.new(8787)
  DRb::DRbServer.verbose = true
  server.start_service

  $log.info "Service started"
  $log.info server.uri
  DRb.thread.join
end