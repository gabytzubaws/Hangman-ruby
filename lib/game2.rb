

class Game
  attr_accessor :guesses, :guess, :secret_word, :used_letters, :answer
  def initialize
    @guess = ''
    @guesses = 0
    @secret_word = ''
    @used_letters = ''
    @answer = ''
    puts "---HANGMAN-RUBY---"
    puts
  end

  def new_game
    @secret_word = self.get_secret_word
    @secret_word.length.times do |i|
      @answer += "_ "
    end
  end

  def play
    while !self.win? && guesses <= 8
      self.replace_answer!(self.make_guess)
      @guesses += 1
      puts @answer
    end
    if(self.win?)
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
    print "Enter a letter: "
    character = gets.chomp.downcase
    while @used_letters.include?(character)
      puts @answer
      print "Please enter a letter that was not used previously: "

      character = gets.chomp.downcase
    end
    @used_letters += character
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


end

game = Game.new()
game.new_game
game.play
