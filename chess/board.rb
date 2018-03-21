Dir['./pieces/*'].each {|file| require file }
require 'byebug'

class Board
  attr_reader :rows

  def initialize(is_dup = false)
    @rows = Array.new(8) { Array.new(8) }
    unless is_dup
      set_pawns
      set_non_pawns
      set_empty_tiles
    end
  end

  def move_piece(start_pos, end_pos, player_color)

    raise IllegalMoveError.new("No piece here") if self[start_pos].is_a?(NullPiece)
    raise IllegalMoveError.new("Not your piece") if self[start_pos].color != player_color
    raise IllegalMoveError.new("Can't move off the board") if !valid_pos?(end_pos)
    raise IllegalMoveError.new("Not a valid move") if !self[start_pos].valid_moves.include?(end_pos)

    if self[start_pos].is_a?(King) && (end_pos[1] - start_pos[1]).abs > 1
      middle = [start_pos[0], (end_pos[1] + start_pos[1]) / 2]
      raise IllegalMoveError.new("can't castle while checked") if in_check?(self[start_pos].color)
      raise IllegalMoveError.new("Can't castle through check") if !self[start_pos].valid_moves.include?(middle)
      castle_move(start_pos, end_pos)
    end

    self[end_pos],self[start_pos] = self[start_pos], NullPiece.instance
    self[end_pos].position = end_pos
    self[end_pos].moved = true if self[end_pos].is_a?(King) || self[end_pos].is_a?(Rook)

  end


  def move_piece!(start_pos, end_pos)
    raise NoPieceError.new("No piece here") if self[start_pos].is_a?(NullPiece)
    raise IllegalMoveError.new("Can't move off the board") if !valid_pos?(end_pos)

    self[end_pos],self[start_pos] = self[start_pos], NullPiece.instance
    self[end_pos].position = end_pos
  end

  def in_check?(color)
    king = rows.flatten.find { |piece| piece.is_a?(King) && piece.color == color }
    opponent_pieces = rows.flatten.select {|piece| piece.color && piece.color != color }
    opponent_pieces.any? do |piece|
      piece.move.include?(king.position)
    end
  end

  def checkmate?(color)
    players_pieces = rows.flatten.select {|piece| piece.color && piece.color == color}
    in_check?(color) && players_pieces.all?{|piece| piece.valid_moves.empty?}
  end

  def valid_pos?(pos)
    pos.all?{ |coord| coord.between?(0, 7) }
  end

  def dup
    duped_board = Board.new(true)
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
  def castle_move(start_pos, end_pos)
    case end_pos[1] - start_pos[1]
    when -2
      pos = [start_pos[0], start_pos[1] - 1]
      self[pos] = self[[start_pos[0], 0]]
      self[[start_pos[0], 0]] = NullPiece.instance
      self[pos].position = pos
    when 2
      pos = [start_pos[0], start_pos[1] + 1]
      self[pos] = self[[start_pos[0], 7]]
      self[[start_pos[0], 7]] = NullPiece.instance
      self[pos].position = pos
    end

  end

  def set_pawns
    8.times do |col|
      self[[6, col]] = Pawn.new(:white, self, [6, col])
    end

    8.times do |col|
      self[[1, col]] = Pawn.new(:black, self, [1, col])
    end
  end

  def set_non_pawns
    [[7, :white], [0, :black]].each do |row, color|
      self[[row, 0]] = Rook.new(color, self, [row, 0])
      self[[row, 7]] = Rook.new(color, self, [row, 7])

      # self[[row, 1]] = Knight.new(color, self, [row, 1])
      # self[[row, 6]] = Knight.new(color, self, [row, 6])

      self[[row, 2]] = Bishop.new(color, self, [row, 2])
      self[[row, 5]] = Bishop.new(color, self, [row, 5])

      # self[[row, 3]] = Queen.new(color, self, [row, 3])

      self[[row, 4]] = King.new(color, self, [row, 4])
    end
  end

  def set_empty_tiles
    (0..7).each do |row|
      (0..7).each do |col|
        pos = [row, col]
        self[pos] = NullPiece.instance unless self[pos]
      end
    end
  end
end

IllegalMoveError = Class.new(StandardError)

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  p board.rows
end
