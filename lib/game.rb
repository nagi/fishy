require 'rubygems'
require 'rubygame'
require 'lib/gui.rb'
require 'lib/timer.rb'
require 'lib/drop_sweet.rb'

include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers

$stdout.sync = true

Surface.autoload_dirs = [ File.join(Dir.pwd,"gfx") ]
Rubygame.init()

class Game
  include EventHandler::HasEventHandler
  
  attr_reader :clock, :queue

  def initialize
    setup_gui
    setup_queue
    setup_clock
    setup_hooks
    setup_timers
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
        :q => proc{@gui.fish_rise(0)},
        :w => proc{@gui.fish_rise(1)},
        :e => proc{@gui.fish_rise(2)},
        :r => proc{@gui.fish_rise(3)},
        :t => proc{@gui.fish_rise(4)},
        :a => proc{@gui.fish_feed(0)},
        :s => proc{@gui.fish_feed(1)},
        :d => proc{@gui.fish_feed(2)},
        :f => proc{@gui.fish_feed(3)},
        :g => proc{@gui.fish_feed(4)},
        :z => proc{@gui.fish_sink(0)},
        :x => proc{@gui.fish_sink(1)},
        :c => proc{@gui.fish_sink(2)},
        :v => proc{@gui.fish_sink(3)},
        :b => proc{@gui.fish_sink(4)},
        :y => proc{@gui.feeder_tip(0)},
        :u => proc{@gui.feeder_tip(1)},
        :i => proc{@gui.feeder_tip(2)},
        :o => proc{@gui.feeder_tip(3)},
        :p => proc{@gui.feeder_tip(4)},
        DropSweet => proc{ | owner, event | @gui.drop_sweet(event)} 
      }
    )
  end
  
  def timer(event)
    @gui.screen.title = @clock.framerate.to_s unless @gui.screen.nil?
    #@gui.sea_anim_frame if @sea_timer.add_time(event)
    #@gui.fish_anim_frame if @fish_timer.add_time(event)
    @gui.sweet_anim_frame if @sweet_timer.add_time(event)
    @gui.feeder_anim_frame if @feeder_timer.add_time(event)
    @gui.ocean_anim_frame if @ocean_timer.add_time(event)
  end
end
