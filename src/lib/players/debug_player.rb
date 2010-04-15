#!/usr/bin/env ruby

require 'logger'
require 'players/dummy_player'
require 'drb/drb'

if $log.nil? then
	$log = Logger.new(STDERR)
	$log.datetime_format = "%Y-%m-%d %H:%M:%S"
end

module Players
	class DebugPlayer < DummyPlayer
		def roll(dice)
			$log.debug('roll'){dice}
			[]
		end

		def status_update(*args)
			$log.debug('status'){args}
		end

		def update_scoreboard(scores)
			$log.debug('scores'){scores}
		end

		def limits(*args)
			$log.debug('limits'){args}
		end
	end
end

if __FILE__ == $0
	if ARGV.empty? then
		$stderr.puts "#{$0} uri"
	else
		player = Players::DebugPlayer.new
		DRb.start_service
		server = DRb::DRbObject.new_with_uri(ARGV[0])
		server.connect(player)
		DRb.thread.join # wait for server to end
	end
end
