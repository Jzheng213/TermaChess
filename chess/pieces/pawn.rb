class Pawn < Piece
  STARTING_POS = {black: 1, white: 6}
  VERTICAL_DIRS = {black: 1, white: -1}

  def move
    potential_moves = []
    next_move = next_move(position)
    return unless board.valid_pos?(next_move)
    potential_moves << next_move if board[next_move].is_a?(NullPiece)
    potential_moves.concat(attack_moves) unless attack_moves.empty?
    next_move = next_move(next_move)
    if position[0] == STARTING_POS[color] && board[next_move].is_a?(NullPiece)
      potential_moves << next_move
    end

    potential_moves
  end

  private

  def attack_moves
    potential_moves = []
    left_attack_pos, right_attack_pos = next_move(position,-1), next_move(position,1)
    [left_attack_pos, right_attack_pos].each do |pos|
      if board.valid_pos?(pos) && !board[pos].is_a?(NullPiece) && board[pos].color != color
        potential_moves << pos
      end
    end
    potential_moves
  end

  def next_move(curr_pos, attack = 0)
    [curr_pos[0] + VERTICAL_DIRS[color], curr_pos[1] + attack]
  end
end
