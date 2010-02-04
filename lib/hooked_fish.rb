class HookedFish
  Y_TOP = -850
  Y_BOTTOM = -600
  Y_RISE = 10

  include EventHandler::HasEventHandler
  include Sprites::Sprite

  attr_accessor :x, :column

  def initialize(x, column)
    @x = x
    @column = column
    @flick_book = Circle.new
    @flick_book.push Surface["hooked_0.png"]
    @flick_book.push Surface["hooked_1.png"]
    @flick_book.push Surface["hooked_2.png"]
    @flick_book.push Surface["hooked_1.png"]
    @image = @flick_book.next
    @rect = Rect.new([(x-(@image.w / 2)),Y_BOTTOM,*@image.size])
  end

  def update
    @image = @flick_book.next
    @rect.y = @rect.y - Y_RISE
  end

  def top?
    @rect.y < Y_TOP
  end
end
