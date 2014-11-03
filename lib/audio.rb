class Audio
  def initialize
    @song = Music["song.wav"]
    @gulp = Sound["gulp.wav"]
    @click = Sound["click.wav"]
  end

  def play_music(volume)
    @song.volume = volume
    @song.play
  end

  def stop_music
    @song.stop
    @song.rewind
  end

  def gulp
    @gulp.play
  end

  def click
    @click.play
  end
end
