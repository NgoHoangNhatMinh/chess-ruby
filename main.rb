require_relative 'lib/board.rb'
require_relative 'lib/coordinate.rb'

require_relative 'lib/pieces/piece.rb'
require_relative 'lib/pieces/pawn.rb'
require_relative 'lib/pieces/rook.rb'
require_relative 'lib/pieces/knight.rb'
require_relative 'lib/pieces/bishop.rb'
require_relative 'lib/pieces/queen.rb'
require_relative 'lib/pieces/king.rb'

require 'yaml'

module YAML
  class << self
    alias_method :load, :unsafe_load
  end
end

def save_game(game)
  puts "Enter file name: "
  name = gets.chomp
  Dir.mkdir("game_data") unless Dir.exist?("game_data")
  filename = "game_data/#{name}.yaml"

  File.open(filename, 'w') do |file|
    file.puts YAML::dump(game)
  end
end

def load_game(name)
  puts File.basename(Dir.getwd)
  filename = "game_data/#{name}.yaml"
  begin
    YAML.load_file(filename)
  rescue
    puts "No such file exists"
  else
    game = YAML.load_file(filename)
  end
  game
end

def play
  while true
    puts "Do you want to start a new game? Y/n"
    new_game = gets.chomp.downcase
    if new_game.match(/\A[n|y]\z/)
      new_game = new_game == "y"
      break
    else 
      puts "Erroneous input! Try again..."
    end  
  end
  
  if new_game
    board = Board.new
  else
    puts "What game do you want to open?"
    name = gets.chomp
    board = load_game(name)
    if board.nil?
      puts "Creating new game..."
      board = Board.new
    end
  end

  while !board.checkmate
    puts "\e[H\e[2J"
    board.display_board

    if board.checkmate
      break
    end

    puts "#{board.player.capitalize} to play. Please enter your move: "
    move = gets.chomp.downcase

    if move == "save"
      save_game(board)
      break
    end

    board.update_board(move)
  end
end

puts "Chess initialized"

play
