require 'byebug'
require 'colorize'
require_relative 'cursor'
require_relative 'board'
class Display
  attr_reader :board, :cursor
  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
  end

  def test
    until false
      system("clear")
      render
      cursor.get_input
    end
  end
  def render
    print %q(  0 1 2 3 4 5 6 7 ) + "\n"
    (0..7).each do |row|
      print "#{row} "
      (0..7).each do |col|
        display_char =
          if board[[row,col]].is_a?(NullPiece)
            "  "
          else
            board[[row,col]].class.to_s[0..1]
          end
        background_color = (row + col).even? ? :white : :green
        if [row,col] == cursor.cursor_pos
          print display_char.colorize(:background => :yellow)
        else
          print display_char.colorize(:background => background_color)
        end

      end
      print "\n"
    end
  end
end

if __FILE__ == $PROGRAM_NAME

  disp = Display.new(Board.new)
  disp.test
end
