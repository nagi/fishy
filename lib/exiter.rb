class Exiter
  CAUGHT_DELAY = 200

  def initialize(gui,raise,first_raise)
    @timer = []
    @ticks_raise = raise
    @ticks_first_raise = first_raise
    @gui = gui
    @aquarium = gui.aquarium
    reset_all_fish
  end

  def tick
    @aquarium.each_with_index do |f,i|
      if(@timer[i] == 0)
        @gui.fish_rise(i)
        reset_fish_timer(i)
      else
        @timer[i] -= 1
      end
    end
  end

  def feed_fish(n)
    @gui.fish_feed(n)
    reset_fish_timer(n)
  end

  def reset_fish_timer(n)
    if(@aquarium[n].pos == 0) then
      @timer[n] = random(@ticks_first_raise[0], @ticks_first_raise[1])
    else
      @timer[n] = random(@ticks_raise[0], @ticks_raise[1])
    end
  end

  def reset_all_fish
    @gui.fish_sink_all
    @timer = []

    @aquarium.length.times do
      @timer.push random(@ticks_first_raise[0], @ticks_first_raise[1])
    end
  end

  def catch_fish(n)
    @timer[n] = CAUGHT_DELAY
    @gui.catch_fish(n)
  end

  def random(lower, higher)
    (lower + rand(higher-lower)).round
  end

  def set_difficulty(raise, first_raise)
    @ticks_raise = raise
    @ticks_first_raise = first_raise
  end
end
