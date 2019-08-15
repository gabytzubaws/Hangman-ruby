require 'yaml'

class Game
  attr_accessor :guesses, :guess, :secret_word, :used_letters, :answer
  def initialize
    @guess = ''
    @guesses = 0
    @secret_word = ''
    @used_letters = ''
    @answer = ''
    puts "---HANGMAN-RUBY---"
    print "Would you like to load a saved game? (y/n): "
    load = gets.chomp.downcase
    if load == 'y' ? (self.load_game) : (self.new_game)
    end
  end

  def new_game
    @secret_word = self.get_secret_word
    @secret_word.length.times do |i|
      @answer += "_ "
    end
    self.play
  end

  def play
    puts @answer
    while !self.win? && guesses < 8
      current_guess = self.make_guess
      if(current_guess == 'save')
        break
      end
      self.replace_answer!(current_guess)
      puts @answer
      puts "Number of guesses left: #{8 - @guesses}"
    end
    if current_guess == 'save'
      puts "Your game was saved succesfully!"
    elsif self.win?
        puts "You found the secret word!"
      else
        puts "You lost. The secret word was #{@secret_word}"
      end
  end


  def replace_answer!(character)
    @secret_word.length.times do |i|
      @answer[2 * i] = @secret_word[i] if secret_word[i] == character
    end
  end


  def make_guess
    print "Enter a letter(or #{'save'} to save current session): "
    character = gets.chomp.downcase
    while @used_letters.include?(character)
      puts @answer
      print "Please enter a letter that was not used previously(or #{'save'} to save the current game): "

      character = gets.chomp.downcase
    end
    if character == 'save'
      self.save_game
    end
    @used_letters += character
    @guesses += 1 if !@secret_word.include?(character)
    character
  end

  def win?
    !@answer.include?("_")
  end

  def get_secret_word
    file = File.open("5desk.txt")
    dictionary = file.readlines.select do |word|
      word.strip!
      word.length > 5 && word.length < 12
    end
    dictionary[rand(dictionary.length)]
  end

  def load_game
    load_file = YAML::load(File.open("SavedGames/Save.txt"))
    load_file.play
  end

  def save_game
    save = YAML::dump(self)
    Dir.mkdir("SavedGames") unless Dir.exists?("SavedGames")
    filename = "SavedGames/Save.txt"
    File.open(filename, 'w') do |file|
      file.puts save
    end
  end

end

game = Game.new()
