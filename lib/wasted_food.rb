class WastedFood
  attr_accessor :column, :what

  def initialize(column)
    @what = :wasted_food
    @column = column
  end
end
