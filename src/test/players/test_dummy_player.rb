require "test/unit"

require 'players/is_a_player'
require 'players/dummy_player'

class TestDummyPlayer < Test::Unit::TestCase
  def setup
    @player = Players::DummyPlayer.new
  end
  
  include IsAPlayer
end