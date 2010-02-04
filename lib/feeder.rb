require 'lib/utils.rb'

include Rubygame

class Feeder
  POS_Y = 23

  include EventHandler::HasEventHandler
  include Sprites::Sprite

  attr_accessor :x, :column

  def initialize(x, column)
    @x = x
    @column = column
    @tipping = 0
    @flick_book = Circle.new
    @flick_book.push Surface["feeder_still.png"]
    @flick_book.push Surface["feeder_tip_0.png"]
    @flick_book.push Surface["feeder_tip_1.png"]
    @flick_book.push Surface["feeder_tip_0.png"]
    @image = @flick_book.next
    @rect = Rect.new([(x-(@image.w / 2)),POS_Y,*@image.size])
  end

  def tip
    @tipping = @flick_book.length unless @tipping > 0
  end

  def still?
    @tipping == 0
  end

  def update
    if @tipping > 0
      @image = @flick_book.next
      @tipping -= 1
      puts "Fire Sweety!"
      $game.queue << DropSweet.new(@x, @column) if @tipping == 2
    end
  end
end
