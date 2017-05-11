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
    @board = "_" * secret_word_length
  end

  # def board
  #   @board = [nil] * secret_word_length
  # end

  def take_turn
    guess = guesser.guess
    matched_idx = referee.check_guess(guess)
    update_board(guess, matched_idx)
    guesser.handle_response
    # update_board
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
    @dictionary[0].length
  end

  def check_guess(letter)
    word = @dictionary[0].chars
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

end
