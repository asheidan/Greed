require 'test/unit'

require 'players/is_a_player'
require 'players/alternate_random_player'

class TestAlternateRandomPlayer < Test::Unit::TestCase
  def setup
	@player = Players::AlternateRandomPlayer.new
  end

  include IsAPlayer

  #Hard to test something that is supposed to act randomly
  # Well, not really. Make sure that the dice selected for
  # rethrowing was sent to the player in hte first place.
end

  
