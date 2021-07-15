require_relative 'stages'

    
  #doesn't fill all occurrences of a letter

  class Game
    
    @current_stage
    @word
    def initialize
        dictionary_file = File.open("dictionary.txt","r")
        @@dictionary=[]
        dictionary_file.each_line do |word|
             @@dictionary.push(word)
                                end
        dictionary_file.close 
        puts "dictionary #{@@dictionary.class} initialized"
        @stage_index=-1
        @wrong_guesses = []

            @word = @@dictionary.sample.chomp
            p "word is #{@word}"

            
            @word_display = Array.new(@word.length, "_ ")
            round
            

    end

    def round
        p @word
        @current_stage = Stages::STAGES[@stage_index+1]
        if @stage_index == 5
            puts "YOU LOST"
            exit
        end
        #show hangman
        puts @current_stage
            puts @word_display.join()
            puts "Wrong guesses: #{@wrong_guesses.join(",")}"
         #when player gives letter
         puts "Okay. What's your guess?"
            #check if only one letter
            @guess = gets.chomp
            guess_validity_checker(@guess)
            #if @word.index is nil, advance one stage. if not, remove _ from word_display at the index and add the letter
            if @word.index(@guess).nil?
                @stage_index = @stage_index+1
                @wrong_guesses.push(@guess)
            else
                #find index, replace word_display at index with correct letter
                @word_display[@word.index(@guess)] = @guess
                i = @word.index(@guess)
                while i <@word.length
                    p @word
                    p "#{i} smaller than #{@word.length}"
                    if @word.index(@guess, i).nil?
                        i = @word.length
                    else
                        @word_display[@word.index(@guess, i)] = @guess
                        i = i+1
                    end
                end
                
            end
            round
    end

    def guess_validity_checker(guess)
        unless @guess.match?(/[[:alpha:]]/) && @guess.length == 1
            puts "#{@guess} is not a letter! This is hangman, don't you know the rules!? Come on, what's your guess?"
            @guess = gets.chomp
            guess_validity_checker(@guess)
        end
    end
end


new_game=Game.new

