class Timer
  def initialize(time_limit)
    @time_limit = time_limit
    @elapsed_time = 0
  end

  def add_time(event)
    @elapsed_time += event.milliseconds
    if time_up? then
      return true
    else
      return false
    end
  end

  private

  def time_up?
    if @elapsed_time > @time_limit then
      true
      @elapsed_time = 0
    else
      false
    end
  end
end
