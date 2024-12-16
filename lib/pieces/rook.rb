require_relative 'piece.rb'

class Rook < Piece
  def initialize(color, pos)
    super(color, pos)
    @first_move = true
  end

  def symbol
    if @color == "white"
      return 0x2656.chr('UTF-8')
    else
      return 0x265C.chr('UTF-8')
    end
  end

  def is_valid_move?(start, final, board)
    if start.x == final.x && start.y == final.y
      return false
    elsif (start.x == final.x || start.y == final.y) && (board[final.x][final.y] == "_" || board[final.x][final.y].color != @color)
      # puts board[final.x][final.y] == "_"
      # puts "Check valid move"
      n = [start.x - final.x, start.y - final.y].max
      for i in 1..(n-1)
        # p start
        # p final
        dx = final.x > start.x ? i : final.x < start.x ? -i : 0
        dy = final.y > start.y ? i : final.y < start.y ? -i : 0

        # puts dx
        # puts dy

        if board[start.x + dx][start.y + dy] != '_'
          # puts false
          return false
        end
      end

      # puts true
      return true
    else
      return false
    end
  end
end