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

  UNICODE_MAPPINGS = {
    King => "\u265A ",
    Queen => "\u265B ",
    Rook => "\u265C ",
    Bishop => "\u265D ",
    Knight => "\u265E ",
    Pawn => "\u265F "
  }

  def render
    system("clear")
    print %q(  a b c d e f g h ) + "\n"
    (0..7).each do |row|
      print "#{row + 1} "
      (0..7).each do |col|
        pos = [row,col]
        display_char =
          if board[pos].is_a?(NullPiece)
            "  "
          else
            UNICODE_MAPPINGS[board[pos].class]
          end
        background_color = (row + col).even? ? :grey : :green
        if pos == cursor.cursor_pos
          print display_char.colorize(:color => board[pos].color, :background => :yellow)
        else
          print display_char.colorize(:color => board[pos].color, :background => background_color)
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
