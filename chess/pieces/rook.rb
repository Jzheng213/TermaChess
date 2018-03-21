class Rook < Piece
  include SlidingPiece
  attr_accessor :moved

  def initialize(color, board, position, moved = false)
    super(color, board, position)
    @moved = moved
  end

  def move_dir
    { horizontal: true }
  end
end
