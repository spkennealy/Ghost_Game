class Player

    attr_reader :name

    def initialize(name)
        @name = name
    end 

    def guess
        puts "#{@name}, please guess a letter: "
        gets.chomp
    end

    def alert_invalid_guess
        puts "That's not a valid play. Please try again."
    end 

end 