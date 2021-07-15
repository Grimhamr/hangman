require_relative 'stages'

  class Game    
    @current_stage
    @word
    def initialize
        puts "Do you want to start a new game or load your save?
        1. New
        2. Load"
            input = gets.chomp
                if input == "1"
                    new_game()
                elsif input == "2"
                    load_game()
                else
                    initialize()
                end
    end

        def new_game
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

    def load_game
        require_relative "saved_game.rb"
        @word = Saved_Data::DATA[0]
        @word_display = Saved_Data::DATA[1]
        @wrong_guesses = Saved_Data::DATA[2]
        @stage_index = Saved_Data::DATA[3]
        round
    end

    def save_game
        puts "Game saved!"
        filename = "saved_game.rb"
        File.open(filename, "w") do |file|
            file.puts "module Saved_Data"
            file.puts "DATA = ['#{@word}', #{@word_display}, #{@wrong_guesses}, #{@stage_index}]"
            file.puts "end"
            end
         exit
    end

    def round
        if @word_display.any?("_ ") == false
            puts @word
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
        puts "Okay. What's your guess? Type save if you want to continue later"
        @guess = gets.chomp.downcase
            if @guess == "save"
                save_game()
            end
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
        if @guess == "save"
            save_game()
        end
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

