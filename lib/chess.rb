class Board
  attr_accessor :checkmate, :board, :black_pieces, :white_pieces

  def initialize
    @board = Array.new(8) { Array.new(8, "_") }
    @checkmate = false
    @black_pieces = Hash.new { |h, k| h[k] = [] }
    @white_pieces = Hash.new { |h, k| h[k] = [] }
    @player = "white"

    for i in 0..7
      @board[1][i] = Pawn.new("black", Coordinate.new(1, i))
      @board[6][i] = Pawn.new("white", Coordinate.new(6, i))

      @black_pieces[:pawn].push(@board[1][i])
      @white_pieces[:pawn].push(@board[6][i])

      if i == 0 || i == 7
        @board[0][i] = Rook.new("black", Coordinate.new(0, i))
        @board[7][i] = Rook.new("white", Coordinate.new(7, i))

        @black_pieces[:rook].push(@board[0][i])
        @white_pieces[:rook].push(@board[7][i])
      elsif i == 1 || i == 6
        @board[0][i] = Knight.new("black", Coordinate.new(0, i))
        @board[7][i] = Knight.new("white", Coordinate.new(7, i))

        @black_pieces[:knight].push(@board[0][i])
        @white_pieces[:knight].push(@board[7][i])
      elsif i == 2 || i == 5
        @board[0][i] = Bishop.new("black", Coordinate.new(0, i))
        @board[7][i] = Bishop.new("white", Coordinate.new(7, i))

        @black_pieces[:bishop].push(@board[0][i])
        @white_pieces[:bishop].push(@board[7][i])
      elsif i == 3
        @board[0][i] = Queen.new("black", Coordinate.new(0, i))
        @board[7][i] = Queen.new("white", Coordinate.new(7, i))

        @black_pieces[:queen].push(@board[0][i])
        @white_pieces[:queen].push(@board[7][i])
      elsif i == 4
        @board[0][i] = King.new("black", Coordinate.new(0, i))
        @board[7][i] = King.new("white", Coordinate.new(7, i))

        @black_pieces[:king].push(@board[0][i])
        @white_pieces[:king].push(@board[7][i])
      end
    end
  end

  def display_board
    for i in 0..7
      for j in 0..7
        if @board[i][j].is_a? String
          print @board[i][j] + ' '
        else
          print @board[i][j].symbol + ' '
        end
      end
      puts "\n"
    end
  end

  def update_board(move)
    valid = false
    if move.length == 2
      move = " " + move
    end
    move = move.chars

    case move[0]
    when "k"
      candidates = @player == "white" ? white_pieces[:king] : black_pieces[:king]
    when "q"
      candidates = @player == "white" ? white_pieces[:queen] : black_pieces[:queen]
    when "r"
      candidates = @player == "white" ? white_pieces[:rook] : black_pieces[:rook]
    when "b"
      candidates = @player == "white" ? white_pieces[:bishop] : black_pieces[:bishop]
    when "n"
      candidates = @player == "white" ? white_pieces[:knight] : black_pieces[:knight]
    when " "
      candidates = @player == "white" ? white_pieces[:pawn] : black_pieces[:pawn]
    end

    candidates.each do |c|
      start = c.pos
      final = Coordinate.new(8 - move[2].to_i, move[1].ord - 97)

      # p start
      # p final

      if c.is_valid_move?(start, final, @board)
        king = @player == "white" ? white_pieces[:king][0] : black_pieces[:king][0]
        c.pos = final
        temp = @board[final.x][final.y]
        @board[final.x][final.y] = @board[start.x][start.y]
        opponent_pieces = @player == "white" ? black_pieces : white_pieces
        if king.is_check?(final, opponent_pieces, @board)
          c.pos = start
          @board[final.x][final.y] = temp
          puts "Invalid move, king is in check"
        else
          @board[final.x][final.y] = @board[start.x][start.y]
          @board[start.x][start.y] = '_'
          # c.pos = final
          valid = true
          puts "board updated"
        end
      end
      # puts "#{c.pos.x} #{c.pos.y} is not the right candidate "
    end
    # puts "wait..."
    gets
    if !valid
      puts "Not a valid move"
      gets
    end
    @player = @player == "white" ? "black" : "white"
    # start = Coordinate.new(8 - move[2].to_i, move[1].ord - 97)
    # final = Coordinate.new(8 - move[4].to_i, move[3].ord - 97)

    # if @board[start.x][start.y] != "_" && @board[start.x][start.y].is_valid_move?(start, final, @board)
    #   @board[final.x][final.y] = @board[start.x][start.y]
    #   @board[start.x][start.y] = '_'
    # else
    #   puts "Invalid move"
    #   gets
    # end
  end

  def is_checkmate?
    
  end
end

class Piece
  attr_accessor :color, :pos
  def initialize(color, pos)
    @color = color
    @pos = pos
  end
end

class King < Piece
  def initialize(color, pos)
    super(color, pos)
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
    # ALSO ADD CHECKING CONDITION
    if ((final.x - start.x).abs <= 1 && (final.y - start.y).abs <= 1)
      return board [final.x][final.y] == '_' || board[final.x][final.y].color != @color && !is_check?(board)
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
      # puts "#{p.symbol} from #{p.pos.display_coordinate} to #{@pos.display_coordinate}. Check is #{val}"
    end
    # puts check
    return check
  end

      
  # end

  # def is_checkmate?(board)
    
  # end
end

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

class Rook < Piece
  def initialize(color, pos)
    super(color, pos)
  end

  def symbol
    if @color == "white"
      return 0x2656.chr('UTF-8')
    else
      return 0x265C.chr('UTF-8')
    end
  end

  def is_valid_move?(start, final, board)
    if (start.x == final.x || start.y == final.y) && (board[final.x][final.y] == "_" || board[final.x][final.y].color != @color)
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
    if (start.x - final.x).abs == (start.y - final.y).abs && (board[final.x][final.y] == "_" || board[final.x][final.y].color != @color)
      
      n = (start.x - final.x).abs
      for i in 1..(n-1)
        dx = final.x > start.x ? i : -i
        dy = final.y > start.y ? i : -i

        # puts dx
        # puts dy

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
    if ((final.y - start.y).abs == 2 && (final.x - start.x).abs == 1) || ((final.y - start.y).abs == 1 && (final.x - start.x).abs == 2)
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
    if @color == "white"
      if @first_move && (final.x - start.x) == -2 && start.y == final.y
        @first_move = false
        no_piece = true
        for i in 0..1
          # puts board[final.x + i][final.y]
          no_piece = no_piece && (board[final.x + i][final.y] == "_")                
        end 
        # puts "2-move checker"
        # puts no_piece
        return no_piece
      elsif (final.x - start.x) == -1 && start.y == final.y
        no_piece = true
        for i in 0..0
          no_piece = no_piece && (board[final.x + i][final.y] == "_")                    
        end 
        # puts "1-move checker"
        # puts no_piece
        return no_piece
      elsif (final.x - start.x) == -1 && (start.y - final.y).abs == 1
        # puts "capture checker"
        val = board[final.x][final.y] != "_" && board[final.x][final.y].color == "black"
        # puts "This is #{val}"
        return val
      else
        # puts "Invalid move checker"
        return false
      end
    elsif @color == "black"
      if @first_move && (final.x - start.x) == 2 && start.y == final.y
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
        return board[final.x][final.y] != "_" && board[final.x][final.y].color = "white"
      else
        return false
      end
    end
  end
end

class Coordinate
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end

  def display_coordinate
    return "#{(@y + 97).chr}#{8 - @x}"
  end
end

def play
  board = Board.new

  game_over = false
  player = "white"

  while !game_over && !board.checkmate
    puts "\e[H\e[2J"
    board.display_board

    puts "#{player} to play. Please enter your move: "
    move = gets.chomp.downcase

    board.update_board(move)

    if board.is_checkmate?
      puts "#{player} wins"
      board.checkmate = true
    end

    player = player == "white" ? "black" : "white"
  end
end

play

# Testing
board = Board.new
board.update_board("e4")
board.update_board("e5")
board.update_board("ke2")
board.update_board("ke7")
board.update_board("ke3")
board.update_board("ke6")
board.update_board("kd4")
board.update_board("kd5")
board.display_board

start = Coordinate.new(4, 4)
final = Coordinate.new(3, 3)

pawn = Pawn.new("white", start)
pawn.is_valid_move?(start, final, board.board)

# knight = Knight.new("white")
# knight.is_valid_move?(Coordinate.new(7, 1), Coordinate.new(6, 3), board.board)

# bishop = Bishop.new("white")
# bishop.is_valid_move?(start, final, board.board)

# rook = Rook.new("white", start)
# puts rook.pos.y
# rook.is_valid_move?(start, final, board.board)

# king = King.new("white", start)
# puts king.is_check?(board)