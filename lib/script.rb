require_relative 'stages'

    


  class Game
    
    @current_stage
    @word
    def initialize
        dictionary_file = File.open("dictionary.txt","r")
        @@dictionary=[]
        dictionary_file.each_line do |word|
             @@dictionary.push(word.downcase)
                                end
        dictionary_file.close 
        puts "dictionary #{@@dictionary.class} initialized"
        @stage_index=-1
        @wrong_guesses = []

            @word = @@dictionary.sample.chomp

            
            @word_display = Array.new(@word.length, "_ ")
            round
            

    end

    def round
        
        if @word_display.any?("_ ") == false
         
            puts "Congratulations! You guessed it!"
            exit
        end
        @current_stage = Stages::STAGES[@stage_index+1]
        if @stage_index == 5
            puts @current_stage
            puts "YOU LOST! The word was '#{@word}'"
            exit
        end
        puts @current_stage
            puts @word_display.join()
            puts "Wrong guesses: #{@wrong_guesses.join(",")}"
         puts "Okay. What's your guess?"
            @guess = gets.chomp
            guess_validity_checker(@guess)
            if @word.index(@guess).nil?
                @stage_index = @stage_index+1
                @wrong_guesses.push(@guess)
            else
                @word_display[@word.index(@guess)] = @guess
                i = @word.index(@guess)
                while i <@word.length
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
        guess_precedence_checker(guess)
    end

    def guess_precedence_checker(guess)
        if @wrong_guesses.include?(guess) || @word_display.include?(guess)
            puts "You have already guessed this letter. Try another."
            @guess = gets.chomp
            guess_validity_checker(@guess)
        end
    end
end


new_game=Game.new

