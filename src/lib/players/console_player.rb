require 'logger'
require 'players/dummy_player'
require 'rules'

$log = Logger.new(STDERR)
module Players
  class ConsolePlayer < DummyPlayer
    
    def update_scoreboard(scores)
      scores.keys.sort.each do |k|
        puts "#{sprintf("%5d",scores[k])} #{k}"
      end
      # $log.debug('scores'){scores}
    end
    
    def status_update(*args)
      $log.debug('status'){args}
    end
    
    def roll(dice)
      puts "#{dice.inspect} -- #{Rules.max_points(dice)}"
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
      "Console"
    end
  end
end

if __FILE__ == $0
  # require 'drb/drb'
  require 'server'
  require 'players/gambler_player'
  require 'players/clever_player'
  require 'players/random_player'
  require 'players/coward_player'
  # DRb.start_service
  player = Players::ConsolePlayer.new

  server = Server.new
  2.times{ server.connect(Players::CleverPlayer.new) }
  2.times{ server.connect(Players::GamblerPlayer.new) }
  2.times{ server.connect(Players::RandomPlayer.new) }
  server.connect(Players::CowardPlayer.new)
  server.connect(player)
  
  server.start_game
end
