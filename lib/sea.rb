include Rubygame

class Sea
  include EventHandler::HasEventHandler
  include Sprites::Sprite

  def initialize(height, flip)
    @flick_book = Circle.new
    7.times do |i|
      @flick_book.push Surface["sea_" + i.to_s + ".png"]
    end

    if flip then
      flipsea
    end

    @image = @flick_book.next
    @rect = [0,height,*@image.size]
  end

  def flipsea
    @flick_book.each { |img| img.flip(true,false) }
    3.times { @flick_book.nudge }
  end

  def update
    @image = @flick_book.next
  end
end
