include Rubygame

class Line
  POS_Y_TOP = -870
  POS_Y_BOTTOM = -530
  POS_Y_INCREMENT = 10
  POS_Y_DECREMENT = 40

  include EventHandler::HasEventHandler
  include Sprites::Sprite

  attr_accessor :x, :column

  def initialize(x, column)
    @x = x
    @column = column
    @flick_book = Circle.new
    @flick_book.push Surface["rope_0.png"]
    @flick_book.push Surface["rope_1.png"]
    @flick_book.push Surface["rope_2.png"]
    @flick_book.push Surface["rope_3.png"]
    @image = @flick_book.next
    @column.times do
      @image = @flick_book.next
    end
    @rect = Rect.new([(x-(@image.w / 2)),POS_Y_TOP,*@image.size])
    @falling = false
  end

  def drop
    @falling = true unless @raising
  end

  def raise_up
    @raising = true
  end

  def top
    @rect.y = POS_Y_TOP
  end

  def update
    @image = @flick_book.next
    if @falling then
      if @rect.y < POS_Y_BOTTOM then
        @rect.y += POS_Y_INCREMENT
      else
        @falling = false
        $game.queue << HookLine.new(@column)
      end
    elsif @raising then
      if @rect.y > POS_Y_TOP
        @rect.y -= POS_Y_DECREMENT
      else
        @raising = false
      end
    end
  end
end
