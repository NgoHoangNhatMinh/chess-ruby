require_relative 'piece.rb'

class King < Piece
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
      return board [final.x][final.y] == '_' || board[final.x][final.y].color != @color
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
      # p p
      # p board
      # p p.pos
      # p @pos
      # puts p.is_valid_move?(p.pos, @pos, board)
      check = check || val
      # puts "#{p.symbol} from #{p.pos.display_coordinate} to #{@pos.display_coordinate}. Check is #{val}"
      # puts "Board is #{board}"
    end
    # puts check
    return check
  end
end