class Results
  def initialize(screen,stats)
    @screen = screen
    @screen.fill([0x2D,0x2D,0x2D])

    font0 = TTF.new('gfx/FreeSans.ttf',60)
    text0 = font0.render("GAME OVER",true,[200,200,200])
    text0.blit(screen,[200,80])

    font1 = TTF.new('gfx/FreeSans.ttf',30)
    text1 = font1.render("Score = " + stats.score.to_s,true,[200,200,200]) 
    text1.blit(screen,[200,160])

    @next = Surface['next.png']
    @next.blit(@screen,[368,400])
    @button = Rect.new([368,400,128,128])
    @screen.update
  end

  def mouse_event(event)
    if(@button.collide_point?(event.pos[0],event.pos[1])) then
      $game.restart_game
    end
  end
end
