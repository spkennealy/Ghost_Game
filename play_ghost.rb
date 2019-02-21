require_relative "ghost_game.rb"

puts "Let's play a game of GHOST!"
puts ""
puts "How many players for this game?"
player_count = gets.chomp.to_i

if player_count < 2
    raise "You must have more than 1 player to play this game."
    puts "Please try again."
    player_count = gets.chomp.to_i
end 

players = []

player_count.times do |i|
    puts "Please enter player #{(i + 1).to_s}:"
    player = gets.chomp.capitalize
    players << player
end 

game = Ghost_Game.new(players)
puts ""
game.play_round