require_relative 'mastermind'
require_relative 'tictactoe'

class TurnGame
  def initialize
    @board = prompt_game
    puts @board.play
  end

  def prompt_game
    puts 'Which game would you like to play?'
    puts '1: Tic Tac Toe, 2: Mastermind'
    input = gets.chomp.to_i
    case input
      when 1 then return TicTacToe::Board.new
      when 2 then return Mastermind::Board.new
      else
        return prompt_game
    end
  end
end

TurnGame.new