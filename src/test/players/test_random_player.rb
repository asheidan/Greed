require 'test/unit'

require 'players/is_a_player'
require 'players/random_player'

class TestRandomPlayer < Test::Unit::TestCase
  def setup
    @player = Players::RandomPlayer.new
  end
  
  include IsAPlayer
  
  # How do you test something that is supposed to work randomly?
end