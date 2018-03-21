class NullPiece < Piece
  include Singleton
  def initialize
  end

  def move
    raise CantMoveError.new("you chose a null piece, try again")
  end

end

CantMoveError = Class.new(StandardError)
