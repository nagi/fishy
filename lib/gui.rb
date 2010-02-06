include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers

class Gui
  attr_reader :aquarium
  attr_accessor :screen
  COLUMNS = [134, 267, 400, 533, 666, 799]
  include EventHandler::HasEventHandler

  def initialize(screen)
    @screen = screen
    @aquarium = Array.new
    @feeders = Array.new
    @sweet_shop = Array.new
    @lines = Array.new
    @hooked_fishes = Array.new
    setup_frames(screen.size)
    setup_lines
    setup_fish
    setup_sea
    setup_feeder
  end

  def setup_frames(size)
    @back_frame = Surface.new(size)
    @background = Surface["bg.png"]
    @background.blit(@back_frame,[0,0])
    @lines_frame = Surface.new(size)
    @lines_frame.colorkey = :black
    @blank = Surface.new(size)
    @blank.fill(:black)
  end

  def setup_lines
    @line0 = Line.new(COLUMNS[0],0)
    @line1 = Line.new(COLUMNS[1],1)
    @line2 = Line.new(COLUMNS[2],2)
    @line3 = Line.new(COLUMNS[3],3)
    @line4 = Line.new(COLUMNS[4],4)
    @lines << @line0 << @line1 << @line2 << @line3 << @line4
    @lines.each { | l | l.draw(@lines_frame) }
  end

  def setup_sea
    @sea = Sea.new(350,false)
    @sea.draw(@back_frame)
  end

  def setup_fish
    @fish0 = Fish.new(COLUMNS[0],0)
    @fish1 = Fish.new(COLUMNS[1],1)
    @fish2 = Fish.new(COLUMNS[2],2)
    @fish3 = Fish.new(COLUMNS[3],3)
    @fish4 = Fish.new(COLUMNS[4],4)
    @aquarium.push @fish0
    @aquarium.push @fish1
    @aquarium.push @fish2
    @aquarium.push @fish3
    @aquarium.push @fish4
    @aquarium.each { |f| f.draw(@back_frame) }
  end

  def setup_feeder
    @feeder0 = Feeder.new(COLUMNS[0],0)
    @feeder1 = Feeder.new(COLUMNS[1],1)
    @feeder2 = Feeder.new(COLUMNS[2],2)
    @feeder3 = Feeder.new(COLUMNS[3],3)
    @feeder4 = Feeder.new(COLUMNS[4],4)
    @feeders.push @feeder0
    @feeders.push @feeder1
    @feeders.push @feeder2
    @feeders.push @feeder3
    @feeders.push @feeder4
    @feeders.each { |f| f.draw(@back_frame) }
  end
  
  def drop_sweet(event)
    @sweet_shop << Sweet.new(event.x, event.column)
  end

  def drop_line(event)
    @lines[event.column].drop
  end

  def fish_rise(n)
    @aquarium[n].rise
    ocean_anim_frame
  end

  def fish_feed(n)
    fish = @aquarium[n]
    if fish.pos == 0 then
      $game.queue << WastedFood.new(n)
    else
      $game.queue << FishFed.new(n)
      $game.queue << Gulp.new
    end
    fish.feed
    ocean_anim_frame
  end

  def fish_sink(n)
    @aquarium[n].sink
    ocean_anim_frame
  end

  def fish_sink_all
    @aquarium.each do |f|
      f.sink
    end
  end

  def feeder_tip(n)
    @feeders[n].tip
  end

  def check_hook_fish(n)
    fish = @aquarium[n]
    if fish.catchable?
      $game.queue << CatchFish.new(n)
    else
      @lines[n].raise_up
    end
  end

  def catch_fish(n)
    @lines[n].top
    fish_sink(n)
    @hooked_fishes << HookedFish.new(COLUMNS[n],n)

    if $game.stats.score_board[:fish_lost] >= 2 then
      $game.queue << GameOver.new(:too_many_dead_fish)
    end
  end

  def feeder_anim_frame
    @feeders.each do |f|
      unless f.still? then
        f.undraw(@back_frame,@background)
        f.update
        f.draw(@back_frame)
      end
    end
    frame
  end

  def sweet_anim_frame
    @sweet_shop.each do |s|
      s.undraw(@back_frame,@background)
      if sweet_colliding?(s) then
        $game.queue << FishHit.new(s.column)
        s.undraw(@back_frame,@background)
        @sweet_shop.delete(s)
      elsif s.bottom? then
        s.undraw(@back_frame,@background)
        @sweet_shop.delete(s)
      else 
        s.update
        s.draw(@back_frame)
      end
    end
  end

  def sweet_colliding?(sweet)
    sweet.collide_sprite?(@aquarium[sweet.column])
  end

  def ocean_anim_frame
    @aquarium.each { |f| f.undraw(@back_frame,@background) }
    @sea.undraw(@back_frame,@background)
    @aquarium.each { |f| f.update }
    @sea.update
    @aquarium.each { |f| f.draw(@back_frame) }
    @sea.draw(@back_frame)
  end

  def line_anim_frame
    @lines_frame.fill(:black)
    @lines.each do |l| 
      l.update
      l.draw(@lines_frame)
    end

    @hooked_fishes.each do | h |
      h.update
      @hooked_fishes.delete(h) if h.top?
      h.draw(@lines_frame)
    end
  end

  def frame
    @back_frame.blit(@screen,[0,0])
    @lines_frame.blit(@screen,[0,0])
    @screen.update
  end
end

