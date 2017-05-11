class Hangman
  attr_reader :guesser, :referee, :board

  def initialize(players={})
    @players = players
  end

  def guesser
    @players[:guesser]
  end

  def referee
    @players[:referee]
  end

  def setup
    secret_word_length = referee.pick_secret_word
    guesser.register_secret_length(secret_word_length)
    @board = [nil] * secret_word_length
  end

  def take_turn
    guess = guesser.guess
    matched_idx = referee.check_guess(guess)
    update_board(guess, matched_idx)
    guesser.handle_response
  end

  def update_board(guess, matched_idx)
    i = 0
    while i < matched_idx.length
      @board[i] = guess
      i += 1
    end
  end

end

class HumanPlayer
end

class ComputerPlayer

  def initialize(dictionary)
    @dictionary = dictionary
  end

  def pick_secret_word
    @secret_word = @dictionary.sample
    @secret_word.length
  end

  def check_guess(letter)
    word = @secret_word.chars
    matched = []
    idx = 0
    while idx < word.length
      if word[idx] == letter
        matched << idx
      end
      idx += 1
    end
    matched
  end

  def register_secret_length(length)
    secret_word_option = @dictionary.select { |word| word.length == length }
    @dictionary = secret_word_option
  end

  def board
    @dictionary.chars
  end

  def guess(board)
    guessed = board.reject { |el| el == nil }
    counter = Hash.new(0)
    candidate_words.each do |word|
      word.chars.each { |ch| counter[ch] += 1 unless guessed.include?(ch) }
    end
    counter.sort_by { |k, v| v }.last[0]
  end

  def handle_response(guess, matched_idx)
    secret_word_option = []
    total_matched = []
    @dictionary.each do |word|
      word.chars.each_with_index do |letter, idx|
        if letter == guess
          total_matched << idx
        end
      end
      if total_matched == matched_idx
        secret_word_option << word
      end
      total_matched = []
    end
    @dictionary = secret_word_option
  end

  def candidate_words
    @dictionary
  end

end
