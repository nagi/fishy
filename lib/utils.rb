class Circle < Array
  def initialize
    @pointer = -1
  end

  def next
    self[(@pointer += 1) % self.length]
  end

  def nudge
    @pointer += 1
  end

  def un_nudge
    @pointer -= 1
  end

  def peek
    self[@pointer]
  end

  def reset
    @pointer = 0
  end
end
