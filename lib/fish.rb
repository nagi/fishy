include Rubygame

class Fish
  BOTTOM_POS_Y = 375
  INCREMENT = 16
  MAX_POS = 5

  include EventHandler::HasEventHandler
  include Sprites::Sprite

  attr_reader :x, :column, :pos

  def initialize(x, column)
    @x = x
    @column = column
    @flick_book = Circle.new
    @flick_book.push Surface["fish_open.png"]
    @flick_book.push Surface["fish_closed.png"]
    @image = @flick_book.next
    @rect = Rect.new([(x-(@image.w / 2)),BOTTOM_POS_Y,*@image.size])
    @pos = 0
  end

  def catchable?
    @pos >= MAX_POS
  end

  def catch
    puts "Caught @fish#{@column}"
  end

  def rise
    unless @pos >= MAX_POS then
      @pos += 1
    else
      $game.queue << DropLine.new(@x, @column)
    end
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
