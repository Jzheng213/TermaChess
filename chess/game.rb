require_relative 'board'
require_relative 'human_player'
require_relative 'display'

class Game

  def initialize(player1, player2)
    @board = Board.new
    @display = Display.new(@board)
    @current_player = player1
    @other_player = player2
  end

  def play
    until game_over?
      display.render
      turn_message
      begin
        start_pos, end_pos = current_player.make_move(display)
        board.move_piece(start_pos, end_pos, current_player.color)
      rescue IllegalMoveError => e
        puts e.message
        sleep(2)
        retry
      end
      switch_player!
    end
  end

  def turn_message
    puts "It's #{@current_player}'s turn, color: #{@current_player.color}"
  end

  def switch_player!
    @current_player, @other_player = @other_player, @current_player
  end

  def game_over?
    board.checkmate?(:white) || board.checkmate?(:black)
  end


  private
  attr_reader :display, :board, :current_player, :other_player
end

if __FILE__ == $PROGRAM_NAME
  player1 = HumanPlayer.new('player1',:white)
  player2 = HumanPlayer.new('player2',:black)

  game = Game.new(player1,player2)
  game.play

end
