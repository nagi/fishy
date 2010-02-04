class Audio
  def initialize(song)
    @song = Music[song]
    @gulp = Sound["gulp.ogg"]
  end

  def play_music(volume)
    @song.volume = volume
    @song.play
  end

  def gulp
    @gulp.play
  end
end
