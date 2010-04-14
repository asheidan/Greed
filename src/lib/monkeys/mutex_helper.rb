class Mutex
  def try_synchronize(&block)
    begin
      synchronize { block.call }
    rescue ThreadError
      yield
    end
  end
end
