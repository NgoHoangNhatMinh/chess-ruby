require_relative 'bishop.rb'
require_relative 'rook.rb'
require_relative 'piece.rb'

class Queen < Piece
  def initialize(color, pos)
    super(color, pos)
  end

  def symbol
    if @color == "white"
      return 0x2655.chr('UTF-8')
    else
      return 0x265B.chr('UTF-8')
    end
  end

  def is_valid_move?(start, final, board)
    return Rook.new(@color, @pos).is_valid_move?(start, final, board) || Bishop.new(@color, @pos).is_valid_move?(start, final, board)
  end
end