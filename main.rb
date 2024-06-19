require 'yaml'

class Hangman
  
  def initialize()
    puts "What's your name?"
    @name = gets.chomp.to_s
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
    load_game?
  end

  def get_guess
    puts "If you would like to save your game, type 'save'.\nOtherwise, just take a guess:"

    loop do
      @guess = gets.chomp.to_s.downcase
      if @guess == 'save'
        save_game
        exit
      elsif @guess.match(/^[a-zA-Z]$/)
        break
      else
        puts "Invalid input. Please enter a single letter or type 'save' to save the game:"
      end
    end
    @guess
  end

  def load_game?
    puts "Would you like to load a game?"
    if gets.chomp == 'y'
      self.load_game
    else
      gameplay_loop
    end
  end

  def gameplay_loop
    puts '- - H A N G M A N - -'
    @wrong_guess = []
    @lives = 6
    puts @board.join(' ')
    until @lives == 0 || !@board.include?('_') do
      get_guess
      if @word_arr.include?(@guess)
        update_board(@guess)
        puts "Previous guesses: #{@wrong_guess.join(' - ')}"
      else
        @wrong_guess << @guess
        @lives -= 1
        puts @board.join(' ')
        puts "Wrong guess! #{@lives} remaining lives"
        puts "Previous guesses: #{@wrong_guess.join(' - ')}"
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
    yaml = YAML.dump ({
      name: @name,
      score: @score,
      word: @word,
      board: @board,
      word_arr: @word_arr,
      previous_guess: @wrong_guess,
    })
    Dir.mkdir('saves') unless Dir.exist?('saves')
    filename = "saves/#{@name}.yml"
    File.open(filename, 'w') do |file|
      file.puts yaml
    end
  end

  def load_game()
    Dir.chdir 'saves'
    saves = Dir.entries('.').each_with_index {|file,idx| puts "#{idx}. #{file}"}
    
    puts 'Choose a save using the number'
    string = saves[gets.chomp.to_i]
    
    puts "Loading file: #{string}"
    data = YAML.load File.read(string)
    @name = data[:name]
    @score = data[:score]
    @word = data[:word]
    @word_arr = data[:word_arr]
    @board = data[:board]
    @wrong_guess = data[:previous_guess]
    Dir.chdir '..'
    gameplay_loop
  end

end



new_game = Hangman.new()
new_game.play