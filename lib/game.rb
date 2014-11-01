class Game
  include EventHandler::HasEventHandler
  
  attr_reader :clock, :queue, :gui, :stats

  MENU_STATE = 0
  GAME_STATE = 1
  GAMEOVER_STATE = 2

  def initialize(screen)
    @state = MENU_STATE
    @difficulty = :unset
    setup_menu(screen)
    setup_gui(screen)
    setup_audio
    setup_hooks
    setup_timers
    setup_clock
    setup_queue
    setup_stats
    #setup_exiter
  end

  def go
    catch(:quit) do
      loop do
        step
      end
    end
  end

  def quit
    puts " *** Quit *** "
    throw :quit
  end 

  def start_game(difficulty)
    @stats.difficulty = difficulty
    @state = GAME_STATE
    setup_exiter(difficulty)
  end

  def restart_game
    $game = Game.new(@screen)
    $game.go
  end

  def stop_game(event)
    @stats.why_ended = event.why
    @state = GAMEOVER_STATE
  end

  private

  def step
    if(@state == GAME_STATE) then
      @queue.fetch_sdl_events
      @queue << @clock.tick 
      #puts @queue.to_yaml unless @queue.empty?
      @queue.each do |event|
        puts event unless event.class == ClockTicked
        if event.class == MousePressed || event.class == MouseReleased then
          @queue.delete(event)
        else
          handle(event)
        end
      end
    elsif(@state == MENU_STATE) then
      @queue.each do | event |
        if event.class == MousePressed 
          handle(event)
        else
          @queue.delete(event)
        end
      end
    elsif(@state == GAMEOVER_STATE) then
      unless @results then
        @results = Results.new(@screen, @stats)
      end

      @queue.each do | event |
        if event.class == MouseReleased
          handle(event)
        else
          @queue.delete(event)
        end
      end
    else
      raise 'Unimplemented state'
    end
  end

  def setup_menu(screen)
    @menu = Menu.new(screen)
  end

  def setup_gui(screen)
    @screen = screen
    @gui = Gui.new(@screen)
  end

  def setup_audio
    @audio = Audio.new("song.ogg")
    #@audio.play_music(0.2)
  end

  def setup_queue
    @queue = EventQueue.new()
    @queue.enable_new_style_events
    @queue.ignore = [MouseMoved]
  end

  def setup_clock
    @clock = Clock.new()
    @clock.target_framerate = 40
    # Adjust the assumed granularity to match the system.
    # This helps minimize CPU usage on systems with clocks
    # that are more accurate than the default granularity.
    @clock.calibrate
    # Make Clock#tick return a ClockTicked event.
    @clock.enable_tick_events
  end

  def setup_timers
    #@sea_timer = Timer.new(200)
    #@fish_timer = Timer.new(200)
    @game_timer = Timer.new(25000)
    @feeder_timer = Timer.new(20)
    @ocean_timer = Timer.new(300)
    @sweet_timer = Timer.new(20)
    @line_timer = Timer.new(40)
    @exiter_timer = Timer.new(40)
  end

  def setup_exiter(difficulty)
    case difficulty
    when :hard
      @exiter = Exiter.new(@gui,[20,20],[40,240])
    when :medium
      @exiter = Exiter.new(@gui,[30,30],[60,440])
    when :easy
      @exiter = Exiter.new(@gui,[40,40],[80,640])
    end
  end
  
  def setup_stats
    @stats = Stats.new
  end

  def setup_hooks
    make_magic_hooks(
      {
        QuitRequested => :quit,
        :escape => :quit,
        :tick => :timer,
        GameOver => proc{ | owner,event | owner.stop_game(event) }
      }
    )
    make_magic_hooks_for(@gui,
      {
        :q => proc{@gui.feeder_tip(0)},
        :w => proc{@gui.feeder_tip(1)},
        :e => proc{@gui.feeder_tip(2)},
        :r => proc{@gui.feeder_tip(3)},
        :t => proc{@gui.feeder_tip(4)},
        :y => proc{@gui.feeder_tip(0)},
        :u => proc{@gui.feeder_tip(1)},
        :i => proc{@gui.feeder_tip(2)},
        :o => proc{@gui.feeder_tip(3)},
        :p => proc{@gui.feeder_tip(4)},
        DropSweet => proc{ | owner, event | @gui.drop_sweet(event)},
        DropLine => proc{ | owner, event | @gui.drop_line(event)},
        HookLine => proc{ | owner, event | @gui.check_hook_fish(event.column)},
      }
    )
    make_magic_hooks_for(@exiter,
      {
        FishHit => proc{ | owner, event | @exiter.feed_fish(event.column)},
        CatchFish => proc{ | owner, event | @exiter.catch_fish(event.column)}
      }
    )
    make_magic_hooks_for(@stats,
      {
        FishFed => proc{ | owner, event | @stats.inc(event.what)},
        WastedFood => proc{ | owner, event | @stats.inc(event.what)},
        CatchFish => proc{ | owner, event | @stats.inc(event.what)}
      }
                        )
    make_magic_hooks_for(@audio,
      {
        Gulp => proc{ @audio.gulp },
        Click => proc{ @audio.click}
      }
    )
    make_magic_hooks_for(@menu,
      {
        MousePressed => proc{ | owner, event | @menu.mouse_event(event)}
      }
    )
    make_magic_hooks_for(@results,
      {
        MouseReleased => proc{ | owner, event | @results.mouse_event(event)},
      }
    )
  end

  def timer(event)
    @gui.screen.title = @clock.framerate.round.to_s + ' Score = ' + @stats.score.to_s unless @gui.screen.nil?
    $game.queue << GameOver.new(:completed) if @game_timer.add_time(event)
    @gui.sweet_anim_frame if @sweet_timer.add_time(event)
    @gui.feeder_anim_frame if @feeder_timer.add_time(event)
    @gui.ocean_anim_frame if @ocean_timer.add_time(event)
    @gui.line_anim_frame if @line_timer.add_time(event)
    @exiter.tick if @exiter_timer.add_time(event)
  end
end
