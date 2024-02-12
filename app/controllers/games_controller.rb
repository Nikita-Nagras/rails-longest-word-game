require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    alphabet = alphabet.shuffle
    @letters = alphabet.sample(10)
  end

  def score
    @points = 0
    @answer = params[:answer]
    @letters = params[:letters].split
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    user_serialized = URI.open(url).read
    dictionary = JSON.parse(user_serialized)
    included_on_grid = @answer.chars.all? do |letter|
      @letters.include? letter.upcase
    end

    if dictionary["found"] && included_on_grid
      @points = @points + 2
      if @answer.length > 4
        @points = @points + 3
      end
      @result = "You have earned #{@points} points!"
    elsif dictionary["found"]
      @result = "You haven't used the correct letters."
    else
      @result = "Sorry, #{@answer} is not a word."
    end
  end
end
