require_relative 'piece.rb'

class Bishop < Piece
  def initialize(color, pos)
    super(color, pos)
  end

  def symbol
    if @color == "white"
      return 0x2657.chr('UTF-8')
    else
      return 0x265D.chr('UTF-8')
    end
  end

  def is_valid_move?(start, final, board)
    if start.x == final.x && start.y == final.y
      return false
    elsif (start.x - final.x).abs == (start.y - final.y).abs && (board[final.x][final.y] == "_" || board[final.x][final.y].color != @color)
      
      n = (start.x - final.x).abs
      for i in 1..(n-1)
        dx = final.x > start.x ? i : -i
        dy = final.y > start.y ? i : -i

        if board[start.x + dx][start.y + dy] != '_'
          return false
        end
      end

      return true
    else
      return false
    end
  end
end