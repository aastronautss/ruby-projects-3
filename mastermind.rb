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

# Package of Board and Player types for Mastermind game.
module Mastermind
  # Main class for Mastermind. Variable size, number of guesses, and colors.
  class Board
    def initialize(input = {})
      @size = input.fetch(:size, 4)
      @colors = input.fetch(:colors, 6)
      @tries = input.fetch(:tries, 12)

      print "CODE MAKER: Human or Computer? "
      @code_maker = player_prompt(1)
      print "CODE BREAKER: Human or Computer? "
      @code_breaker = player_prompt(2)

      @step_log = []
    end

    def play
      @code_maker.make_key(options_hash)

      @tries.times do
        guess = @code_breaker.guess(options_hash)
        answer = @code_maker.judge(guess)
        @step_log << [guess, answer]
        p @code_maker.key
        p answer
        display_board
        return "The code has been broken!" if winner?(answer)
      end
      "The code breaker has run out of guesses! The key was: " + @code_maker.key.join(", ") + "."
    end

    private

    def winner?(answer)
      answer[:right_position] == 4
    end

    # Returns a hash with the board's options so I don't have to write the parameters more than once.
    def options_hash
      {size: @size, colors: @colors}
    end

    def display_board
      puts header
      @step_log.each_with_index do |pair, i|
        puts (i + 1).to_s +
             ':' +
             guess_string(pair[0]) +
             '|' +
             feedback_string(pair[1])
      end
      puts footer
    end

    def header
      "  " + " GUESS LOG ".center(50, "=") + "\n  " + "Guess".center(29, "-") + "+" + "Feedback".center(20, "-")
    end

    def guess_string(guesses)
      guesses.join('  ').center(29)
    end

    def feedback_string(feedback)
      arr = []
      right_position = feedback[:right_position]
      right_color = feedback[:right_color]
      blank = @size - right_position - right_color
      right_position.times { arr << "+" }
      right_color.times { arr << "x" }
      blank.times { arr << "o" }
      arr.join(' ').center(20)
    end

    def footer
      "  " + 'KEY'.center(50, "-") + "\n  " + "+: right position; x: right color; o: no match".center(50) + "\n  " + "".center(50, "=")
    end

    # Returns a type of player depending on the input. Can be a Computer or Human on either side of the board.
    def player_prompt(id)
      choice = gets.chomp.downcase
      if choice == "human"
        delegate_human(id)
      elsif choice == "computer"
        delegate_computer(id)
      else
        player_prompt(id)
      end
    end

    def delegate_human(id)
      if id == 1
        HumanCodeMaker.new
      else
        HumanCodeBreaker.new
      end
    end

    def delegate_computer(id)
      if id == 1
        ComputerCodeMaker.new
      else
        ComputerCodeBreaker.new
      end
    end
  end

  # Creates a key, judges a CodeBreaker's guesses.
  class CodeMaker
    attr_reader :key

    # Makes key an empty array to be filled when #make_key is called.
    def initialize
      @key = []
    end

    # Fills the key with 'nil' values by default.
    def make_key(input)
      size = input.fetch(:size)
      size.times { @key << nil }
    end

    def judge(guess)
      feedback = {right_position: 0, right_color: 0}
      key_temp = @key.map { |i| i }
      guess_temp = guess.map { |i| i }
      guess.each_index do |i|
        if @key[i] == guess[i]
          feedback[:right_position] += 1
          key_temp[i] = nil
          guess_temp[i] = nil
        end
      end
      unless feedback[:right_position] == 4
        guess_temp.each_with_index do |color, i|
          if !color.nil? && key_temp.include?(color)
            feedback[:right_color] += 1
            key_temp[key_temp.index(color)] = nil # Remove one of the colors from key
            guess_temp[i] = nil
          end
        end
      end
      feedback
    end
  end

  # Extends the CodeMaker class for CPU functionality.
  class ComputerCodeMaker < CodeMaker
    # Fills the key with random numbers depending on the number of colors in the game.
    def make_key(input)
      size = input.fetch(:size)
      colors = input.fetch(:colors)
      size.times { |i| @key << (rand(colors) + 1) }
      @key
    end
  end

  # Can make a guess on the board.
  class CodeBreaker
    # Returns a random array of guesses based on the options by default.
    def guess(input)
      size = input.fetch(:size)
      colors = input.fetch(:colors)
      guess_array = []
      size.times { guess_array << (rand(colors) + 1)}
      guess_array
    end
  end

  class HumanCodeBreaker < CodeBreaker
    def guess(input)
      size = input.fetch(:size)
      colors = input.fetch(:colors)
      puts "Enter #{size} numbers from 1 through #{colors} (inclusive), separated by commas:"
      guess_arr = gets.chomp.split(/,\s?/)
      guess_arr.map! { |i| i.to_i }
      return guess(input) unless valid_guess?(guess_arr, input)
      guess_arr
    end

    def valid_guess?(guess_arr, input)
      return true if guess_arr.length == input.fetch(:size) && guess_arr.all? {|num| (1..input.fetch(:colors)) === num }
      false
    end
  end
end

module TicTacToe
  class Board

  end
end

TurnGame.new