module TicTacToe
  require 'enumerator'

  # Plays the game.
  class Board
    def initialize
      @rows = [
          [7, 8, 9],
          [4, 5, 6],
          [1, 2, 3]
      ]
      @winning_positions = [[7, 4, 1], [8, 5, 2], [9, 6, 3], [1, 2, 3], [4, 5, 6], [7, 8, 9], [7, 5, 3], [9, 5, 1]]

      puts 'PLAYER 1: '
      @player_1 = player_prompt(1)
      puts 'PLAYER 2: '
      @player_2 = player_prompt(2)

      play
    end

    # Main method for gameplay. Randomizes the turn order and has players input moves until a win or a draw.
    def play
      p_arr = randomize_players(@player_1, @player_2)
      current_player = p_arr[0]
      next_player = p_arr[1]
      current_player.piece = 'X'
      next_player.piece = 'O'
      puts "Player #{current_player.id.to_s} goes first!"

      end_message = ""
      loop do
        set_cell(current_player.move(self))
        if check_win?
          end_message = current_player.win_message
          break
        elsif check_draw?
          end_message = "It's a draw."
          break
        end
        current_player, next_player = next_player, current_player
      end

      display_board
      end_message
    end

    # Helper method for deciding which players are computers or humans.
    def player_prompt(id)
      puts 'Human or Computer?'
      choice = gets.chomp.downcase
      if choice == 'human'
        player = HumanPlayer.new(id)
      elsif choice == 'computer'
        player = ComputerPlayer.new(id)
      else
        puts "Invalid input.\n"
        return player_prompt(id)
      end
      player
    end

    # Displays the board in the command line.
    def display_board
      col_separator = ' | '
      row_separator = '--+---+--'

      @rows.each_with_index do |row, row_number|
        row.each_with_index do |col, col_number|
          print col.to_s
          print col_separator unless col_number + 1 >= row.length
        end
        puts ''
        puts row_separator unless row_number + 1 >= @rows.length
      end
    end

    # Sets the inputted cell on the board with the inputted piece.
    def set_cell(args)
      arr = @rows.flatten
      arr[arr.find_index(args[:position])] = args[:piece]
      @rows = arr.enum_for(:each_slice, 3).to_a
    end

    # Takes a position number and returns true if it is available for play.
    def valid_position?(position)
      arr = @rows.flatten
      arr.find_index(position)
    end

    # Returns true if there are any rows full of Xs or Os
    def check_win?
      deconstruct = @rows +
                    @rows.transpose +
                    [[@rows[0][0], @rows[1][1], @rows[2][2]]] +
                    [[@rows[0][2], @rows[1][1], @rows[2][0]]]

      deconstruct.any? do |line|
        line.all? { |element| element == line[0] }
      end
    end

    # Returns true if the board is full.
    def check_draw?
      @rows.all? do |row|
        row.all? { |cell| cell == "X" || cell == "O" }
      end
    end

    # Returns an array for a shuffled turn order.
    def randomize_players(p1, p2)
      r = rand(2)
      a = []
      if r == 0
        a << p1
        a << p2
      else
        a << p2
        a << p1
      end
      a
    end
  end

  # Plays each turn in the game as a Human, with human input.
  class HumanPlayer
    attr_accessor :piece
    attr_reader :id

    def initialize(id)
      @id = id
    end

    # Takes user input and returns the player's move.
    def move(board)
      board.display_board
      print "Enter move for Player #{@id.to_s} (#{@piece}): "
      position = gets.to_i
      return {position: position, piece: @piece} if board.valid_position?(position)
      puts "Invalid position."
      move(board)
    end

    # This is displayed if the player wins.
    def win_message
      puts "Player #{@id.to_s} (#{@piece}) wins!"
    end
  end

  class ComputerPlayer
    attr_accessor :piece
    attr_reader :id

    def initialize(id)
      @id = id
    end

    def move(board)

    end
  end
end