require 'rubygems'
require 'rubygame'
require 'lib/gui.rb'
require 'lib/audio.rb'
require 'lib/timer.rb'
require 'lib/drop_sweet.rb'
require 'lib/exiter.rb'
require 'lib/gulp.rb'
require 'lib/sea.rb'
require 'lib/catch_fish.rb'
require 'lib/hooked_fish.rb'
require 'lib/fish.rb'
require 'lib/line.rb'
require 'lib/feeder.rb'
require 'lib/sweet.rb'
require 'lib/fish_fed.rb'

include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers

$stdout.sync = true

Surface.autoload_dirs = [ File.join(Dir.pwd,"gfx") ]
Music.autoload_dirs = [ File.join(Dir.pwd,"audio") ]
Sound.autoload_dirs = [ File.join(Dir.pwd,"audio") ]
Rubygame.init()

class Game
  include EventHandler::HasEventHandler
  
  attr_reader :clock, :queue, :gui

  def initialize
    setup_gui
    setup_audio
    setup_hooks
    setup_timers
    setup_clock
    setup_queue
    setup_exiter
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

  private

  def step
    @queue.fetch_sdl_events
    @queue << @clock.tick 
    #puts @queue.to_yaml unless @queue.empty?
    @queue.each do |event|
      puts event unless event.class == ClockTicked
      handle(event)
    end
  end

  def setup_gui
    @gui = Gui.new([800,600])
  end

  def setup_audio
    @audio = Audio.new("song.ogg")
    @audio.play_music(0.2)
  end

  def setup_queue
    @queue = EventQueue.new()
    @queue.enable_new_style_events
    @queue.ignore = [MouseMoved]
  end

  def setup_clock
    @clock = Clock.new()
    @clock.target_framerate = 32
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
    @feeder_timer = Timer.new(10)
    @ocean_timer = Timer.new(200)
    @sweet_timer = Timer.new(10)
    @line_timer = Timer.new(20)
  end

  def setup_exiter
    @exiter = Exiter.new(@gui,[20,20],[40,240])
  end
  
  def setup_hooks
    make_magic_hooks(
      {
        QuitRequested => :quit,
        :escape => :quit,
        :tick => :timer
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
        FishFed => proc{ | owner, event | @exiter.feed_fish(event.column)},
        CatchFish => proc{ | owner, event | @exiter.catch_fish(event.column)}
      }
    )
    make_magic_hooks_for(@audio,
      {
        Gulp => proc{ @audio.gulp }
      }
    )
  end
  
  def timer(event)
    @exiter.tick
    @gui.screen.title = @clock.framerate.to_s unless @gui.screen.nil?
    @gui.sweet_anim_frame if @sweet_timer.add_time(event)
    @gui.feeder_anim_frame if @feeder_timer.add_time(event)
    @gui.ocean_anim_frame if @ocean_timer.add_time(event)
    @gui.line_anim_frame if @line_timer.add_time(event)
  end
end
