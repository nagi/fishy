require 'lib/utils.rb'

include Rubygame

class Sweet
  Y_TOP = 126
  Y_BOTTOM = 450
  Y_DROP = 12

  include EventHandler::HasEventHandler
  include Sprites::Sprite

  def initialize(px)
    @image = Surface["sweet_" + rand(5).to_s + ".png"]
    @rect = [(px-(@image.w / 2)),Y_TOP,*@image.size]
  end

  def update # if this returns true, the sweet has dropped all the way
    @rect[1] = @rect[1] + Y_DROP
    if(@rect[1] >= Y_BOTTOM)
      true
    else
      false
    end
  end
end
