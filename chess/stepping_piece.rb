module SteppingPiece

  def move
    move_diffs.each_with_object([]) do |(dx,dy), moves_arr|
      x, y = self.position
      move = [x+dx,y+dy]
      next if !board.valid_pos?(move) || board[move].color == self.color
      moves_arr << move
    end
  end

  def move_diffs
  end
  
end
