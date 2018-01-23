require 'byebug'

module SlidingPiece
  HORIZONTAL_DIRS = [[1,0],[-1,0],[0,1],[0,-1]]
  DIAGONAL_DIRS = [[1,1],[-1,1],[1,-1],[-1,-1]]

  def move
    moves_arr = []
    moves_arr.concat(diagonal_dirs) if move_dir[:diagonal]
    moves_arr.concat(horizontal_dirs) if move_dir[:horizontal]
    moves_arr
  end

  def horizontal_dirs
    HORIZONTAL_DIRS.each_with_object([]) do |(dx,dy), horizontal_moves|
      horizontal_moves.concat(grow_unblocked_moves_in_dir(dx,dy))
    end
  end

  def diagonal_dirs
    DIAGONAL_DIRS.each_with_object([]) do |(dx,dy), diagonal_moves|
      diagonal_moves.concat(grow_unblocked_moves_in_dir(dx,dy))
    end
  end

  private

  def move_dir
    {horizontal: true, diagonal: true}
  end

  def grow_unblocked_moves_in_dir(dx, dy)
    move = self.position
    unblocked_moves = []

    while true
      x, y = move
      move = [x+dx,y+dy]
      break if !board.valid_pos?(move) || board[move].color == self.color
      unblocked_moves << move
      break unless board[move].is_a?(NullPiece)
    end
    unblocked_moves
  end

end
