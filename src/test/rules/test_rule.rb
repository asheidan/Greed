
module TestRule
  def test_rule_should_respond_to_apply
    points,dice = @rule.apply( [1,2,3,4,5,6] )
    assert_instance_of(Fixnum, points)
    assert_instance_of(Array, dice )
  end
  
  def test_rule_should_not_invent_dice
    points, dice = @rule.apply( [] )
    assert_equal([], dice)
  end
end