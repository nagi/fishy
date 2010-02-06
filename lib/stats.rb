class Stats
  attr_reader :score_board
  attr_accessor :difficulty, :why_ended

  def initialize
    @difficulty = :not_set
    @why_ended = :not_set
    @score_board = 
      {
        :fish_fed => 0,
        :wasted_food => 0,
        :lines_dropped => 0,
        :fish_lost => 0,
        :completed_easy => 0,
        :completed_medium => 0,
        :completed_hard => 0
      }
  end

  def inc(what)
    unless @score_board[what].nil? then
      @score_board[what] += 1
    end
  end
  
  def score
    score = 0
    score += @score_board[:fish_fed] * 125
    score -= @score_board[:wasted_food] * 300
    score -= @score_board[:fish_lost] * 1000
    score += @score_board[:completed_easy] * 20000
    score += @score_board[:completed_medium] * 40000
    score += @score_board[:completed_hard] * 80000
  end
end
