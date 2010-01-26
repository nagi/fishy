require 'lib/utils.rb'

include Rubygame

class Fish
  BOTTOM_POS_Y = 375
  INCREMENT = 16
  MAX_POS = 5

  include EventHandler::HasEventHandler
  include Sprites::Sprite

  def initialize(x)
    @flick_book = Circle.new
    @flick_book.push Surface["fish_open.png"]
    @flick_book.push Surface["fish_closed.png"]
    @image = @flick_book.next
    @rect = [(x-(@image.w / 2)),BOTTOM_POS_Y,*@image.size]
    @pos = 0
  end

  def rise
    unless @pos >= MAX_POS then 
      @pos += 1
    end
    puts "Fire an event to drop line" if @pos == MAX_POS
  end
  
  def feed
    @pos -= 1 if @pos == 1
    @pos -= 2 unless @pos < 2
  end

  def sink
    @pos = 0
  end

  def update
    @rect[1] = BOTTOM_POS_Y - (INCREMENT * @pos)
    @image = @flick_book.next
  end
end
