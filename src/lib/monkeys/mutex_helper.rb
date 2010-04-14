class Mutex
  def try_synchronize(&block)
    begin
      synchronize { block.call }
    rescue ThreadError => e
      yield
    end
  end
end
