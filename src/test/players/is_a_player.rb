
module IsAPlayer
  def test_player_should_respond_to_updated_scoreboard
    @player.update_scoreboard( {} )
  end
  
  def test_player_should_respond_correctly_to_roll
    dice = @player.roll( [] )
    assert_instance_of(Array, dice)
  end
  
  def test_player_should_respond_to_status_update
    @player.status_update("Nisse",[1,2,3,4,5,6],[])
  end
end