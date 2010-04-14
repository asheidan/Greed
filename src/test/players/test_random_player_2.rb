require 'test/unit'

require 'players/is_a_player'
require 'players/random_player_2'

class TestRandomPlayer2 < Test::Unit::TestCase
  def setup
	@player = Players::RandomPlayer2.new
  end

  include IsAPlayer

  #Hard to test something that is supposed to act randomly
end

  
