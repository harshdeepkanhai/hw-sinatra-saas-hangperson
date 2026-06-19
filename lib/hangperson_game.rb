class HangpersonGame
  # Get a word from remote "random word" service
  attr_accessor :word, :guesses, :wrong_guesses
  def initialize word
    @word = word
    @guesses= ''
    @wrong_guesses = ''
  end

  def guess letter
    raise ArgumentError unless letter =~ /[a-z]/i 
    letter.downcase!
    return false if @guesses.include? letter or @wrong_guesses.include? letter
    return @guesses << letter if @word.include? letter and !@guesses.include? letter
    @wrong_guesses << letter if !@wrong_guesses.include? letter
  end

  def word_with_guesses
    matches = @word.chars.map do |l| 
      if @guesses.include? l 
        l 
      else 
        '-'
      end
    end
    matches.join
  end

  def check_win_or_lose
    return :win if word_with_guesses == @word
    return :lose if @wrong_guesses.length >= 7
    :play
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  #
  # The original watchout4snakes.com service is defunct, so we use the
  # Datamuse API instead. It has no dedicated "random word" endpoint, so we
  # query a spelling pattern of all wildcards ('?' matches any single letter)
  # for a random word length and pick one of the results at random.
  def self.get_random_word
    require 'uri'
    require 'net/http'
    require 'json'
    length = rand(5..7)
    uri = URI("https://api.datamuse.com/words?max=1000&sp=#{'?' * length}")
    words = JSON.parse(Net::HTTP.get(uri)).map { |entry| entry['word'] }
    words.select { |w| w =~ /\A[a-z]+\z/ }.sample
  end

end
