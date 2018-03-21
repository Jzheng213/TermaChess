class Knight < Piece
  include SteppingPiece

  def move_diffs
    [[2,1],[2,-1],[-2,1],[-2,-1],
    [1,2],[1,-2],[-1,2],[-1,-2]]
  end
end
