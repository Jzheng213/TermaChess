class Bishop < Piece
  include SlidingPiece
  def move_dir
    {diagonal: true}
  end
end
