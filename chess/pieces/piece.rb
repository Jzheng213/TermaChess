require_relative '../board'
require 'singleton'
require_relative '../sliding_piece'
require_relative '../stepping_piece'

class Piece
  attr_reader :color, :board
  attr_accessor :position

  def initialize(color,board,position)
    @color = color
    @board = board
    @position = position
  end

  def inspect
    {piece_type: self.class, color: color, position: position}.inspect
  end

  def valid_moves

    move.reject{ |position| move_into_check?(position) }
  end

  def move_into_check?(end_pos)
    test_board = board.dup
    test_board.move_piece!(position, end_pos)
    test_board.in_check?(color)
  end

  def dup(new_board)
    if self.is_a?(King) || self.is_a?(Rook)
      self.class.new(color, new_board, position.dup, moved)
    else
      self.class.new(color, new_board, position.dup)
    end
  end
end
