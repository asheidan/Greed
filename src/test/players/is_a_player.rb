
module IsAPlayer
  def test_player_should_respond_to_updated_scoreboard
    @player.update_scoreboard( {} )
  end
  
  def test_player_should_respond_correctly_to_roll
    assert_nothing_thrown(NoMethodError) {
      dice = @player.roll( [] )
      assert_instance_of(Array, dice)
    }
  end
  
  def test_player_should_respond_to_status_update
    assert_nothing_thrown(NoMethodError) {
      @player.status_update("Nisse",[1,2,3,4,5,6],[])
    }
  end

  def test_player_should_respond_to_limits
    assert_nothing_thrown(NoMethodError) {
      @player.limits(10000,300)
    }
  end
end