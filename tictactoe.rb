# When #new is called, initializes board, delegates which player is a computer and which player is a human, and plays the board.
class TurnGame
  def initialize
    @board = TTTBoard.new

    puts "PLAYER 1: "
    @player_1 = player_prompt
    puts "PLAYER 2: "
    @player_2 = player_prompt

    board.play(@player_1, @player_2)
  end

  # Helper method for deciding which players are computers or humans.
  def player_prompt
    puts "Human or Computer?"
    choice = gets.chomp.downcase
    if choice == "human"
      player = HumanPlayer.new
    elsif choice == "computer"
      player = ComputerPlayer.new
    else
      puts "Invalid input.\n"
      return player_prompt
    end
    player
  end
end

# Main tic-tac-toe class.
class TTTBoard
  def initialize
    rows = [[7, 8, 9], [4, 5, 6], [1, 2, 3]]
  end

  def play(player_1, player_2)
    

    loop do
      display_board

    end
  end

  def display_board

  end
end

class HumanPlayer

end

class ComputerPlayer

end