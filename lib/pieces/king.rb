require_relative 'piece.rb'

class King < Piece
  attr_accessor :first_move
  def initialize(color, pos)
    super(color, pos)
    @first_move = true
  end

  def symbol
    if @color == "white"
      return 0x2654.chr('UTF-8')
    else
      return 0x265A.chr('UTF-8')
    end
  end

  def is_valid_move?(start, final, board)
    # assuming final is within the board
    if start.x == final.x && start.y == final.y
      return false
    elsif ((final.x - start.x).abs <= 1 && (final.y - start.y).abs <= 1)
      val = board [final.x][final.y] == '_' || board[final.x][final.y].color != @color
      return val
    else
      return false
    end
  end

  def is_check?(final, opponent_hash, board)
    opponent_pieces = []
    opponent_hash.each_pair do |key, value|
      opponent_pieces += opponent_hash[key]
    end 
    
    check = false
    opponent_pieces.each do |p|
      val = p.is_valid_move?(p.pos, @pos, board)
      check = check || val
      if val == true
        board.each_with_index do |r, i|
        end
      end
    end
    return check
  end
end