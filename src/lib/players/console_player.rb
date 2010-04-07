require 'logger'
require 'players/dummy_player'
require 'rules'

$log = Logger.new(STDERR)
module Players
  class ConsolePlayer < DummyPlayer
    
    def update_scoreboard(scores)
      $log.debug('scores'){scores}
    end
    
    def status_update(*args)
      $log.debug('status'){args}
    end
    
    def roll(dice)
      puts "#{dice.inspect} -- #{Rules.apply_rules(dice)}"
      $stderr.print "# "
      response = nil
      while !response.is_a?(Array) do
        str = gets
        if str.nil? then
          response = []
        else
          response = eval str
        end
      end
      $log.debug('response'){response}
      response
    end
    def name
      "nisse"
    end
  end
end

if __FILE__ == $0
  # require 'drb/drb'
  require 'server'
  require 'players/gambler_player'
  # DRb.start_service
  player = Players::ConsolePlayer.new

  server = Server.new
  server.connect(Players::GamblerPlayer.new)
  server.connect(player)
  
  server.start_game
end