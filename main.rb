require 'yaml'

class Hangman
  
  def initialize(name)
    @name = name
    @score = 0
    @dictionary = []
    self.load_dictionary
  end

  def load_dictionary
    filename = 'google-10000-english-no-swears.txt'

    File.readlines(filename).each do |line|
      next unless line.length.between?(5,12)
        @dictionary << line
    end
  end

  def get_random_word
    @dictionary[rand(@dictionary.length)].chomp
  end

  def play
    @word = get_random_word
    @word_arr = @word.split('')
    @board =  Array.new(@word_arr.length, '_')
    gameplay_loop
  end

  def get_guess
    puts 'Take a guess!'
    @guess = 0
    until @guess.to_s.match(/[a-zA-Z]/) do
      @guess = gets.chomp.downcase
    end
    @guess.downcase
  end

  def gameplay_loop
    puts '- - H A N G M A N - -'
    wrong_guess = []
    @lives = 6
    puts @board.join(' ')
    until @lives == 0 || !@board.include?('_') do
      get_guess
      if @word_arr.include?(@guess)
        update_board(@guess)
        puts "Previous guesses: #{wrong_guess.join(' - ')}"
      else
        wrong_guess << @guess
        @lives -= 1
        puts @board.join(' ')
        puts "Wrong guess! #{@lives} remaining lives"
        puts "Previous guesses: #{wrong_guess.join(' - ')}"
      end
    end
    if @lives == 0
      @score -= 1
      puts "You lost! Your score is #{@score}. The word was #{@word}
      Continue playing? (y/n)"
      play_again?(gets.chomp)
    else 
      @score += 1
      puts "You won! Your score is #{@score}. Continue playing? (y/n)"
      play_again?(gets.chomp)
    end
  end

  def update_board(guess)
    @word_arr.each_with_index do |letter,idx|
      letter == guess ? @board[idx] = "#{guess.capitalize}" : next
    end
    puts @board.join(' ')
  end

  def play_again?(option)
    if option == 'y'
      self.play()
    end
  end

  def save_game
    
  end
end



new_game = Hangman.new('owen')
new_game.play