require_relative 'board'
require 'singleton'
require_relative 'sliding_piece'
require_relative 'stepping_piece'
require 'byebug'

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
    move.reject{|position| move_into_check?(position)}
  end

  def move_into_check?(end_pos)
    test_board = board.dup
    test_board.move_piece(position,end_pos)
    test_board.in_check?(color)
  end

  def dup(new_board)
    self.class.new(color, new_board, position.dup)
  end
end

class Rook < Piece
  include SlidingPiece
  def move_dir
    {horizontal: true}
  end
end

class Bishop < Piece
  include SlidingPiece
  def move_dir
    {diagonal: true}
  end
end

class Queen < Piece
  include SlidingPiece
end

class Knight < Piece
  include SteppingPiece

  def move_diffs
    [[2,1],[2,-1],[-2,1],[-2,-1],
    [1,2],[1,-2],[-1,2],[-1,-2]]
  end
end

class King < Piece
  include SteppingPiece

  def move_diffs
    [[1,0],[-1,0],[0,1],[0,-1],
    [1,1],[-1,1],[1,-1],[-1,-1]]
  end
end

class Pawn < Piece
  STARTING_POS = {black: 1, white: 6}
  VERTICAL_DIRS = {black: 1, white: -1}

  def move
    potential_moves = []
    next_move = next_move(position)
    return if !board.valid_pos?(next_move)
    #pawn should be swapped with the choosing of the player
    potential_moves << next_move if board[next_move].is_a?(NullPiece)

    next_move = next_move(next_move)
    if position[0] == STARTING_POS[color] && board[next_move].is_a?(NullPiece)
      potential_moves << next_move
    end

    left_attack_pos, right_attack_pos = next_move(position,-1), next_move(position,1)
    [left_attack_pos,right_attack_pos].each do |pos|
      # debugger
      if board.valid_pos?(pos) && !board[pos].is_a?(NullPiece) && board[pos].color != color
        potential_moves << pos
      end
    end

    potential_moves
  end
  private
  def next_move(curr_pos, attack = 0)
    [curr_pos[0] + VERTICAL_DIRS[color], curr_pos[1] + attack]
  end
end

class NullPiece < Piece
  include Singleton
  def initialize
  end

  def move
    # raise CantMoveError.new("you chose a null piece, try again")
  end

end

CantMoveError = Class.new(StandardError)
