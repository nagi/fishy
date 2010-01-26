require 'rubygems'
require 'rubygame'
require 'lib/sea.rb'
require 'lib/fish.rb'
require 'lib/feeder.rb'
require 'lib/sweet.rb'

include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers

class Gui
  attr_accessor :screen
  COLUMNS = [134, 267, 400, 533, 666, 799]
  include EventHandler::HasEventHandler

  def initialize(size)
    @sprites = Array.new
    @aquarium = Array.new
    @feeders = Array.new
    @sweet_shop = Array.new
    @screen = Screen.open(size)
    setup_background
    #setup_sea_bg
    setup_fish
    setup_sea
    setup_feeder
    draw_all
    @screen.update
  end

  def setup_background
    @background = Surface["bg.png"]
    @background.blit(@screen,[0,0])
  end

  def setup_sea_bg
    @sea_bg = Sea.new(340,true)
    @sea_bg.draw(@screen)
    @sprites.push(@sea_bg)
  end

  def setup_sea
    @sea = Sea.new(350,false)
    @sea.draw(@screen)
    @sprites.push(@sea)
  end

  def setup_fish
    @fish0 = Fish.new(COLUMNS[0])
    @fish1 = Fish.new(COLUMNS[1])
    @fish2 = Fish.new(COLUMNS[2])
    @fish3 = Fish.new(COLUMNS[3])
    @fish4 = Fish.new(COLUMNS[4])
    @aquarium.push @fish0
    @aquarium.push @fish1
    @aquarium.push @fish2
    @aquarium.push @fish3
    @aquarium.push @fish4
    @aquarium.each {|f|@sprites.push f}
  end

  def setup_feeder
    @feeder0 = Feeder.new(COLUMNS[0])
    @feeder1 = Feeder.new(COLUMNS[1])
    @feeder2 = Feeder.new(COLUMNS[2])
    @feeder3 = Feeder.new(COLUMNS[3])
    @feeder4 = Feeder.new(COLUMNS[4])
    @feeders.push @feeder0
    @feeders.push @feeder1
    @feeders.push @feeder2
    @feeders.push @feeder3
    @feeders.push @feeder4
    @feeders.each {|f|@sprites.push f}
  end
  
  def drop_sweet(event)
    @sweet_shop.push Sweet.new(event.x)
  end

  def fish_rise(n)
    @aquarium[n].rise
    ocean_anim_frame
  end

  def fish_feed(n)
    @aquarium[n].feed
    ocean_anim_frame
  end

  def fish_sink(n)
    @aquarium[n].sink
    ocean_anim_frame
  end

  def undraw_all
    #@sprites.each { |s| s.undraw(@screen,@background) }
    @background.blit(@screen,[0,0])
  end

  def draw_all
    @sprites.each { |s| s.draw(@screen) }
  end

  def feeder_tip(n)
    @feeders[n].tip
  end

  def feeder_anim_frame
    @feeders.each do |f|
      unless f.still? then
        f.undraw(@screen,@background)
        f.update
        f.draw(@screen)
      end
    end
    @screen.update
  end

  def sweet_anim_frame
    @sweet_shop.each do |s|
        s.undraw(@screen,@background)
        if s.update then
          s.undraw(@screen,@background)
          @sweet_shop.delete(s)
        end
        s.draw(@screen)
    end
  end

 # def fish_anim_frame
 #   undraw_all
 #   @aquarium.each do |f|
 #     f.update
 #   end
 #   draw_all
 #   @screen.update
 # end

 # def sea_anim_frame
 #   undraw_all
 #   @sea.update
 #   #@sea_bg.update
 #   draw_all
 #   @screen.update
 # end

  def ocean_anim_frame
    @aquarium.each { |f| f.undraw(@screen,@background) }
    @sea.undraw(@screen,@background)
    @aquarium.each { |f| f.update }
    @sea.update
    @aquarium.each { |f| f.draw(@screen) }
    @sea.draw(@screen)
  end
end
