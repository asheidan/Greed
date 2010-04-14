require 'test/unit'
require 'thread'
require 'monkeys/mutex_helper'

class TestMutexHelper < Test::Unit::TestCase
  def setup
    @mutex = Mutex.new
  end
  
  def test_00_mutex_should_throw_error_when_synronizing_in_synchronized_block
    assert_raise(ThreadError) {
      @mutex.synchronize {
        @mutex.synchronize {
          flunk("Synchronizing in a synchronized block should give error")
        }
      }
    }
  end
  
  def test_01_try_synchronize_in_a_synchronized_block_should_work_fine
    assert_nothing_raised(ThreadError) {
      @mutex.synchronize {
        @mutex.try_synchronize {
          a = 0
        }
      }
    }
  end
  
  # def test_02_try_synchronize_should_mask_errors
  #   assert_raise(ThreadError) do
  #     @mutex.synchronize {
  #       @mutex.try_synchronize {
  #         raise ThreadError.new("We're just another brick in the wall")
  #       }
  #     }
  #   end
  # end
end
