class CatchFish
attr_accessor :column, :what
  def initialize(column)
    @what = :fish_lost
    @column = column
  end
end
