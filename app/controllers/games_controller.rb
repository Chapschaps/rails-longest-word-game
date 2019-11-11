class GamesController < ApplicationController
  def new
    @letters = (0...9).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    require 'open-uri'
    @attempt = params[:longest]
    @letters = params[:tags_list].split('')
    @newlet = []
    @letters.each { |element| @newlet << element if ("A".."Z").to_a.include?(element) }
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    chosenword = Hash.new(0)
    @attempt.upcase.split("").each { |a| chosenword[a] += 1 }
    hashgrid = Hash.new(0)
    @newlet.each { |a| hashgrid[a] += 1 }
    if chosenword.length <= hashgrid.length
      if chosenword.all? { |key, value| value <= hashgrid[key] }
        if word["found"] == true
          @finalscore = chosenword.length + 1
          @message_result = "Well Done!"
        elsif word["found"] == false
          @finalscore = 0
          @message_result = "not an english word"
        end
      else
        @finalscore = 0
        @message_result = "not in the grid"
      end
    end
  end
end
