class FishFed
  attr_accessor :column, :what
  def initialize(column)
    @what = :fish_fed
    @column = column
  end
end
