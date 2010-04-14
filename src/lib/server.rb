require 'drb/drb'
require 'drb/acl'
require 'logger'
require 'rules'
require 'rules/ones_and_fives_rule'
require 'rules/three_of_a_kind_rule'
require 'rules/street_rule'
require 'monkeys/mutex_helper'
require 'monkeys/array_helper'
require 'throw'

$SAFE = 1

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
    @uri = port.nil? ? nil : "druby://:#{port}"
    
    @game_started = false
    
    @bust = bust
    @limit = limit
  end
  
  def start_service
    acl = ACL.new(%w[allow all])
    DRb.install_acl(acl)
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
    if !@game_started then
      @game_started = true
      $log.info('start_game'){ "Game is commencing" }
      @mutex.synchronize{
        @clients.shuffle!
      }
      $log.debug('start_game'){ @clients }
      winner = game
      broadcast(:update_scoreboard, [@score_board])
      broadcast(:game_over, [winner])
    end
  end
  
  # Calls the specified method in all clients except those in except
  # with the given parameters.
  def broadcast(method, parameters, except=[])
    @mutex.try_synchronize {
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
    }
  end
  private :broadcast
  
  # Sketch for game round. @clients should be shuffle!d before each game.
  # Returns the name of the winner
  def game
    # TODO: In dire need of refactorization
    loop do
      $log.debug('game'){ "--- New round ---"}
      @mutex.synchronize {
        @clients.each { |c|
          begin
            $log.debug('game'){ "---- #{c.name} ----"}
            broadcast(:update_scoreboard, [@score_board])
            round_score = 0
            cup = Throw.new
            reroll_dice = [nil] * 6
            while reroll_dice != [] do
              cup.reroll!
              saved_dice = cup.rolled
              $log.debug('game: dice') {cup}
              broadcast(:status_update, [c.name, cup.rolled, cup.saved])
              reroll_dice = c.roll(cup.rolled)
              $log.debug('game'){ "reroll: #{reroll_dice.inspect}" }
              reroll_dice.each{ |d|
                saved_dice.remove!(d)
              }
              $log.debug('game'){ "saved: #{saved_dice.inspect}" }
              # Calculate score for saved dice
              throw_score,saved_unscoring_dice = Rules.apply_rules( saved_dice )
              # This would remove a saved die that doesn't score but would
              # potentially leave player with less than 6 dice
              saved_unscoring_dice.each{ |d|
                saved_dice.remove!(d)
              }
              $log.debug('game'){ "saved: #{saved_dice.inspect}" }
              # Don't know why it doesn't iterate fine without the clone
              $log.debug('cup '){ "reroll: #{cup.rolled.inspect}" }
              saved_dice.clone.each{|d|
                cup.save d
              }
              $log.debug('cup '){ "saved: #{cup.saved.inspect}" }
              $log.debug('game'){ "unscored: #{saved_unscoring_dice.inspect}" }
              if round_score == 0 then
                if (throw_score >= @bust) then
                  round_score += throw_score
                else
                  $log.debug('game'){ "Player: #{c.name} busted" }
                  reroll_dice = []
                end
              elsif throw_score > 0 then
                round_score += throw_score
                if cup.saved.length == 6 then
                  # All dice scored, reroll is allowed
                  cup.clear_saved
                end
              else
                $log.debug('game'){ "Player: #{c.name} got no points"}
                round_score = 0
                reroll_dice = []
              end
            end
            @score_board[c.name] += round_score
            if @score_board[c.name] >= @limit then
              $log.info('game'){ "#{c.name} won!"}
              return c.name
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
