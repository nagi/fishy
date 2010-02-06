class Menu
  def initialize(screen)
    @screen = screen

    @bg_icon = Surface["menu_bg.png"]
    @traffic_icon = Surface["traffic.png"]
    @start_icon = Surface["play.png"]
    @arrow_icon = Surface["arrow.png"]

    @difficulty = :medium

    @red = Rect.new([200,60,250,65])
    @amber = Rect.new([200,160,250,65])
    @green = Rect.new([200,250,250,65])

    @play = Rect.new([333,383,144,144])
    draw([400,60])
  end

  def draw(arrow_pos)
    @screen.fill(:white)
    #@bg_icon.blit(@screen,[0,0])
    @traffic_icon.blit(@screen,[200,30])
    @arrow_icon.blit(@screen,arrow_pos)
    @start_icon.blit(@screen,[325,380])
    @screen.update
  end

  def mouse_event(event)
    puts event.class
    if(@red.collide_point?(event.pos[0],event.pos[1])) then
      hard
    elsif(@amber.collide_point?(event.pos[0],event.pos[1])) then
      medium
    elsif(@green.collide_point?(event.pos[0],event.pos[1])) then
      easy
    elsif(@play.collide_point?(event.pos[0],event.pos[1])) then
      play
    end
  end

  def hard
    puts 'hard'
    @difficulty = :hard
    $game.queue << Click.new
    draw([400,-25])
  end

  def medium
    puts 'medium'
    @difficulty = :medium
    $game.queue << Click.new
    draw([400,65])
  end

  def easy
    puts 'easy'
    @difficulty = :easy
    $game.queue << Click.new
    draw([400,155])
  end

  def play
    puts 'play'
    $game.queue << Click.new
    $game.start_game(@difficulty)
  end
end


#200 <-> 650
#
#60
#|
#
#160
#|
#
#250
#|
