require 'test/unit'
require 'players/coward_player'
require 'players/is_a_player'

class TestCowardPlayer < Test::Unit::TestCase
	def setup
		@player = Players::CowardPlayer.new
	end

	include IsAPlayer

	def test_00_coward_always_save
		rethrow = @player.roll([1,1,1,2,4,6])
		assert_equal([], rethrow)
	end	

end
