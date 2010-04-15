require 'test/unit'

require 'players/is_a_player'
require 'players/alternate_random_player'

class TestAlternateRandomPlayer < Test::Unit::TestCase
  def setup
	@player = Players::AlternateRandomPlayer.new
  end

  include IsAPlayer

  def test_00_alternaterandom_only_rethrows_dice_he_got_in_the_first_place
	dice = [1, 2, 2, 4, 5, 5]
    rethrow = @player.roll(dice)	
	rethrow.each {|x| assert(dice.include?(x))}
  end

  #Hard to test something that is supposed to act randomly
  # Well, not really. Make sure that the dice selected for
  # rethrowing was sent to the player in hte first place.
end

  
