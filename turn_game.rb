require_relative 'mastermind'
require_relative 'tictactoe'
require_relative 'hangman'

class TurnGame
  def initialize
    @board = prompt_game
    puts @board.play
  end

  def prompt_game
    puts 'Which game would you like to play?'
    puts '1: Tic Tac Toe, 2: Mastermind, 3: Hangman'
    input = gets.chomp.to_i
    case input
    when 1 then return TicTacToe::Board.new
    when 2 then return Mastermind::Board.new
    when 3
      return Hangman::load_game if load_game?
      return Hangman::Board.new
    else
      return prompt_game
    end
  end

  def load_game?
    loop do
      puts "Would you like to load the game (y/n)"
      choice = gets.chomp
      case choice
      when "y" then return true
      when "n" then return false
      else
        puts "Invalid input!"
      end
    end
  end
end

TurnGame.new