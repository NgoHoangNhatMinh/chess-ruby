require_relative 'lib/board.rb'
require_relative 'lib/coordinate.rb'

require_relative 'lib/pieces/piece.rb'
require_relative 'lib/pieces/pawn.rb'
require_relative 'lib/pieces/rook.rb'
require_relative 'lib/pieces/knight.rb'
require_relative 'lib/pieces/bishop.rb'
require_relative 'lib/pieces/queen.rb'
require_relative 'lib/pieces/king.rb'

def play
  board = Board.new

  while !board.checkmate
    puts "\e[H\e[2J"
    board.display_board

    if board.checkmate
      break
    end

    puts "#{board.player.capitalize} to play. Please enter your move: "
    move = gets.chomp.downcase

    board.update_board(move)
  end
end

play

# Testing
# board = Board.new
# board.update_board("a3")
# board.update_board("a6")
# board.update_board("qf3")
# board.update_board("d5")
# board.update_board("qf7")
# board.update_board("kf7")
# # board.update_board("kd4")
# # board.update_board("kd5")
# board.display_board

# p board

# final = Coordinate.new(1, 5)

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