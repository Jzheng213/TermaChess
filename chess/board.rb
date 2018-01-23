require_relative 'piece'
# require './piece.rb'

class Board
  attr_reader :rows

  def initialize(dup = false)
    @rows = Array.new(8){Array.new(8)}

    unless dup
      8.times do |col|
        self[[6,col]] = Pawn.new(:white, self, [6,col])
      end

      8.times do |col|
        self[[1,col]] = Pawn.new(:black, self, [1,col])
      end

      [[7,:white],[0,:black]].each do |row,color|
        self[[row,0]] = Rook.new(color, self, [row,0])
        self[[row,7]] = Rook.new(color, self, [row,7])

        self[[row,1]] = Knight.new(color, self, [row,1])
        self[[row,6]] = Knight.new(color, self, [row,6])

        self[[row,2]] = Bishop.new(color, self, [row,2])
        self[[row,5]] = Bishop.new(color, self, [row,5])

        self[[row,3]] = Queen.new(color, self, [row,3])
        self[[row,4]] = King.new(color, self, [row,4])

      end


      (2..5).each do |row|
        (0..7).each do |col|
          pos = [row,col]
          self[pos] = NullPiece.instance
        end
      end
    end
  end

  def move_piece(start_pos, end_pos)
    if self[start_pos].is_a?(NullPiece)
      raise NoPieceError.new("No piece here")
    elsif !valid_pos?(end_pos)
      raise IllegalMoveError.new("Can't move here")
    end

    # self[end_pos].position = nil unless self[end_pos].is_a?(NullPiece)
    self[end_pos],self[start_pos] = self[start_pos], NullPiece.instance
    self[end_pos].position = end_pos
  end

  def in_check?(color)
    king = rows.flatten.find { |piece| piece.is_a?(King) && piece.color == color}
    opponent_pieces = rows.flatten.select {|piece| piece.color && piece.color != color}
    opponent_pieces.any? do |piece|
      piece.move.include?(king.position)
    end
  end

  def checkmate?(color)
    players_pieces = rows.flatten.select {|piece| piece.color && piece.color == color}
    in_check?(color) && players_pieces.all?{|piece| piece.valid_moves.empty?}
  end

  def valid_pos?(pos)
    pos.all?{|coord| coord.between?(0,7)}
  end

  def dup
    duped_board = Board.new(dup = true)
    (0..7).each do |row|
      (0..7).each do |col|
        pos   = [row, col]
        piece = self[pos]
        duped_board[pos] = piece.is_a?(NullPiece) ? piece : piece.dup(duped_board)
      end
    end
    duped_board
  end

  def []=(pos, value)
    row, col = pos
    rows[row][col] = value
  end

  def [](pos)
    row, col = pos
    rows[row][col]
  end

  private

end


NoPieceError = Class.new(StandardError)
IllegalMoveError = Class.new(StandardError)

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  p board.rows
end
