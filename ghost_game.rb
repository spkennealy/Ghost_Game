require_relative "player.rb"
require "set"

class Ghost_Game

    attr_reader :words, :dictionary, :fragment, :players, :losses

    def initialize(player_names)
        @players = []
        
        player_names.each do |player|
            @players << Player.new(player)
        end 

        @fragment = ""
        @words = File.readlines("dictionary.txt").map(&:chomp)
        @dictionary = Set.new(words)
        @guess_count = 0
        @round = 1
        @losses = {}
        @players.each { |player| @losses[player] = "" }
    end 

    def play_round
        puts "--------Round ##{@round.to_s}---------"

        take_turn(self.current_player) until match_word?(@fragment)

        if match_word?(@fragment)
            puts "Uh oh, you matched a word!" 
            puts ""
            puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
            letter_count = @losses[self.previous_player].length
            @losses[self.previous_player] += add_letter(letter_count)
            @fragment = ""
            @round += 1

            @losses.each do |player, string|
                puts "#{player.name} has \"#{string}\""
            end
            puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
            puts ""

            if self.loser? 
                loser = self.previous_player
                @players.delete(loser)
                @losses[loser] = "LOST"
                
                puts "#{loser.name} got \"GHOST\"! #{loser.name} is out!"
                puts ""

                if @players.length == 1
                    puts "Game over! #{self.players[0].name} wins!"
                else 
                    @round += 1
                    play_round
                end 
            else
                play_round
            end 
        else 
            
            take_turn(self.current_player)
            puts "Great turn. Next up #{@players[1].name}"
            self.next_player!
            p players
        end
    end 

    def match_word?(string)
        @dictionary.any? {|word| word.downcase == @fragment}
    end 

    def loser?
        @losses.any? { |player, string| string == "GHOST" }
    end 

    def add_letter(letter_count)
        if letter_count == 0
            return "G"
        elsif letter_count == 1
            return "H"
        elsif letter_count == 2
            return "O"
        elsif letter_count == 3
            return "S"
        elsif letter_count == 4
            return "T"
        end 
    end 

    def current_player
        @players[0]
    end 

    def previous_player
        @players[-1]
    end 

    def next_player!
        played = @players.shift
        @players << played
    end 

    def take_turn(player)
        if @guess_count >= 5
            puts "You lose! Too many incorrect guesses!"
            return false
        end 

        guessed_letter = player.guess

        if valid_play?(guessed_letter)
            @fragment += guessed_letter
            self.next_player!
        else
            player.alert_invalid_guess
            @guess_count += 1
            take_turn(player)
        end 
    end 

    def valid_play?(string)
        alphabet = ("a".."z")
        return false unless alphabet.include?(string.downcase)
        guessed = @fragment + string
        @dictionary.any? {|word| word.start_with?(guessed)}
    end 

end 