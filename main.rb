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
  puts filename
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
    p board
    gets
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

# Testing
# board = Board.new
# board.update_board("d4")
# board.update_board("d5")
# board.update_board("bf4")
# board.update_board("bf5")
# board.update_board("qd2")
# board.update_board("qd7")
# board.update_board("0-0-0")
# board.update_board("kd8")
# board.update_board("nf3")
# board.update_board("ke8")
# board.update_board("e3")
# board.update_board("0-0-0")

# # board.update_board("kd5")
# board.display_board

# black_queen = board.white_pieces[:queen][0]
# black_queen.has_attribute?('first_move')

# start = Coordinate.new(1, 3) 
# final = Coordinate.new(7, 3)


# p white_bishop
# puts black_queen.is_valid_move?(start, final, board.board)

# p board


# black_king = board.black_pieces[:king][0]
# black_king.pos = final
# white_queen = board.white_pieces[:queen][0]
# p white_queen

# p white_queen.pos
# p black_king.pos
# puts white_queen.is_valid_move?(white_queen.pos, black_king.pos, board.board)

# start = Coordinate.new(7, 3)

# pawn = Pawn.new("white", start)
# pawn.is_valid_move?(start, final, board.board)

# king = King.new("white", start)
# puts king.is_check?(board)

# queen = Queen.new("white", start)
# puts queen.is_valid_move?(start, final, board.board)