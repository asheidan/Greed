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
end