class Mutex
  def try_synchronize(&block)
    begin
      synchronize { block.call }
    rescue ThreadError => e
      if e.message =~ /thread [^ ]* tried to join itself/ then
        yield
      end
    end
  end
end