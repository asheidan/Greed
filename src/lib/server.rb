require 'drb/drb'
require 'logger'
require 'rules'
require 'rules/ones_and_fives_rule'

$SAFE = 1

$log = Logger.new(STDERR)
$log.datetime_format = "%Y-%m-%d %H:%M:%S"

class Server
  # Makes this class unserializeable (object will not be sent over network)
  include DRbUndumped
  
  attr_reader :uri
  
  def initialize(port=nil)
    $log.debug('initialize') { "port: #{port}" }
    @mutex = Mutex.new
    @clients = []
    @score_board = {}
    @uri = port.nil? ? nil : "druby://localhost:#{port}"
  end
  
  def start_service
    DRb.start_service(uri,self)
  end
  
  def stop_service
    DRb.stop_service
  end
  
  # Remotely called
  def connect(client)
    $log.debug('connect'){ "Client connected: #{client.inspect}" }
    
    # Maybe this should run in another thread so this returns
    # and player receives limits when it's added.
    @mutex.synchronize {
      @clients << client
      @score_board[client.name] = 0
    }
    client.limits(10000,300)
  end
  
  def start_game
    @clients.shuffle!
    game
  end
  
  def broadcast(method, parameters, except=[])
    # @mutex.synchronize {
      @clients.each do |c|
        if( !except.include? c ) then
          begin
            c.send(method,parameters)
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
    # loop do
      @mutex.synchronize {
        @clients.each { |c|
          broadcast(:update_scoreboard, @score_board)
          score = 0
          dice = []
          decision = [nil] * 6
          while decision != [] do
            dice = dice.concat(decision.collect{|d| rand(6)+1 }).sort
            broadcast(:status_update, [c.name, dice], [c])
            decision = c.roll(dice)
            decision.each{ |d|
              
            }
            if decision.empty? then
              score += Rules.apply_rules( dice )
            else
              # Calculate score for saved dice
              # If they are above limit
              # let player rethrow
            end
          end
        }
      }
    # end
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