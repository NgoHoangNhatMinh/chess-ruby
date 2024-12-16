require_relative 'piece.rb'

class Knight < Piece
  def initialize(color, pos)
    super(color, pos)
  end

  def symbol
    if @color == "white"
      return 0x2658.chr('UTF-8')
    else
      return 0x265E.chr('UTF-8')
    end
  end

  def is_valid_move?(start, final, board)
    if start.x == final.x && start.y == final.y
      return false
    elsif ((final.y - start.y).abs == 2 && (final.x - start.x).abs == 1) || ((final.y - start.y).abs == 1 && (final.x - start.x).abs == 2)
      # puts "Valid move check"
      val = board[final.x][final.y] == "_" ||  board[final.x][final.y].color != @color
      # puts board[final.x][final.y]
      # puts val
      return val
    else
      # puts "Invalid move check"
      return false
    end
  end
end