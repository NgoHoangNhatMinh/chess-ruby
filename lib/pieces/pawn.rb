require_relative 'piece.rb'

class Pawn < Piece
  def initialize(color, pos)
    super(color, pos)
    @first_move = true
  end

  def symbol
    if @color == "white"
      return 0x2659.chr('UTF-8')
    else
      return 0x265F.chr('UTF-8')
    end
  end

  def is_valid_move?(start, final, board)
    if start.x == final.x && start.y == final.y
      return false
    elsif @color == "white"
      if @first_move && (final.x - start.x) == -2 && start.y == final.y
        @first_move = false
        no_piece = true
        for i in 0..1
          no_piece = no_piece && (board[final.x + i][final.y] == "_")                
        end 
        return no_piece
      elsif (final.x - start.x) == -1 && start.y == final.y
        no_piece = true
        for i in 0..0
          no_piece = no_piece && (board[final.x + i][final.y] == "_")                    
        end 
        return no_piece
      elsif (final.x - start.x) == -1 && (start.y - final.y).abs == 1
        val = board[final.x][final.y] != "_" && board[final.x][final.y].color == "black"
        return val
      else
        return false
      end
    elsif @color == "black"
      if @first_move && (final.x - start.x) == 2 && start.y == final.y
        @first_move = false
        no_piece = true
        for i in 0..1
          no_piece = no_piece && (board[final.x - i][final.y] == "_")                
        end 
        return no_piece
      elsif (final.x - start.x) == 1 && start.y == final.y
        no_piece = true
        for i in 0..0
          no_piece = no_piece && (board[final.x - i][final.y] == "_")                    
        end 
        return no_piece
      elsif (final.x - start.x) == 1 && (start.y - final.y).abs == 1
        val = board[final.x][final.y] != "_" && board[final.x][final.y].color == "white"
        return val
      else
        return false
      end
    end
  end
end