require 'rubygems'
require 'rubygame'
require 'rubygoo'

require './lib/audio.rb'
require './lib/catch_fish.rb'
require './lib/click.rb'
require './lib/drop_line.rb'
require './lib/drop_sweet.rb'
require './lib/exiter.rb'
require './lib/feeder.rb'
require './lib/fish.rb'
require './lib/fish_fed.rb'
require './lib/fish_hit.rb'
require './lib/game.rb'
require './lib/game_over.rb'
require './lib/gui.rb'
require './lib/gulp.rb'
require './lib/hooked_fish.rb'
require './lib/hook_line.rb'
require './lib/line.rb'
require './lib/menu.rb'
require './lib/results.rb'
require './lib/sea.rb'
require './lib/stats.rb'
require './lib/sweet.rb'
require './lib/timer.rb'
require './lib/utils.rb'
require './lib/wasted_food.rb'

include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers
include Rubygoo

$stdout.sync = true

Surface.autoload_dirs = [ File.join(Dir.pwd,"gfx") ]
Music.autoload_dirs = [ File.join(Dir.pwd,"audio") ]
Sound.autoload_dirs = [ File.join(Dir.pwd,"audio") ]
Rubygame.init()

TTF.setup()

@screen = Screen.open([800,600],16,[HWSURFACE])
@screen.colorkey = :black
$game = Game.new(@screen)
$game.go
Rubygame.quit()
