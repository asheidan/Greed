class Mutex
  def try_synchronize(&block)
    begin
      if try_lock then
        yield
        unlock
      else
        yield
      end
    end
  end
end
