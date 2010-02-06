class Audio
  def initialize(song)
    @song = Music[song]
    @gulp = Sound["gulp.ogg"]
    @click = Sound["click.ogg"]
  end

  def play_music(volume)
    @song.volume = volume
    @song.play
  end

  def gulp
    @gulp.play
  end

  def click
    @click.play
  end
end
