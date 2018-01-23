require_relative 'cursor'
class HumanPlayer
  attr_reader :color, :name
  #TODO: include color instance variable
  def initialize(name, color)
    @name = name
    @color = color
  end
  def make_move(display)
    ret_arr = []
    while true
      display.render
      position = display.cursor.get_input
      ret_arr << position if position.is_a?(Array)
      break if ret_arr.size == 2
    end

    ret_arr
  end
end
