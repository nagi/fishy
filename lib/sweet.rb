require 'lib/utils.rb'

include Rubygame

class Sweet
  Y_TOP = 126
  Y_BOTTOM = 450
  Y_DROP = 16

  include EventHandler::HasEventHandler
  include Sprites::Sprite

  attr_accessor :x, :column

  def initialize(x, column)
    @x = x
    @column = column
    @image = Surface["sweet_" + rand(5).to_s + ".png"]
    @rect = Rect.new([(x-(@image.w / 2)),Y_TOP,*@image.size])
  end

  def update
    @rect.y = @rect.y + Y_DROP
  end

  def bottom?
    @rect.y >= Y_BOTTOM
  end
end
