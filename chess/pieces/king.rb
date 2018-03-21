require 'byebug'

class King < Piece
  include SteppingPiece
  attr_accessor :moved

  def initialize(color, board, position, moved = false)
    super(color, board, position)
    @moved = moved
  end

  def move

    moves_arr = super
    moves_arr.concat(castle) unless moved
    moves_arr
  end

  private

  def castle
    moves = []
    [-1, 1].each do |direction|
      next unless castle_empty(direction)
      next if castle_rook_moved(direction)
      moves << [position[0], position[1] + direction * 2]
    end
    moves
  end


  def move_diffs
    [[1,0],[-1,0],[0,1],[0,-1],
    [1,1],[-1,1],[1,-1],[-1,-1]]
  end

  def castle_rook_moved(direction)
    case direction
    when -1
      pos = [0, position[0]]
      return true if !board[pos].is_a?(Rook) || board[pos].moved
    when 1
      pos = [7, position[0]]
      return true if !board[pos].is_a?(Rook) || board[pos].moved
    end
    false
  end

  def castle_empty(direction)
    row = position[1]
    while row > 1 && row < 6
      row += direction
      pos = [position[0], row]
      return false unless board[pos].is_a?(NullPiece)
    end
    true
  end

  def next_move(curr_pos, direction)
    [curr_pos[0], curr_pos[0] + direction]
  end
end
