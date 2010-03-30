require "test/unit"

require 'test_player'
require 'players/dummy_player'

class TestDummyPlayer < Test::Unit::TestCase
  def setup
    @player = Players::DummyPlayer.new
  end
  
  include TestPlayer
end