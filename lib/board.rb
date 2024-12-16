require_relative 'coordinate.rb'

require_relative 'pieces/piece.rb'
require_relative 'pieces/pawn.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/knight.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/queen.rb'
require_relative 'pieces/king.rb'

class Board
  attr_accessor :checkmate, :board, :black_pieces, :white_pieces, :player

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

    if is_checkmate?
      puts "#{@player} is checkmated"
      @checkmate = true
      return checkmate
    end
    notify_check
  end

  def update_board(move)
    # Add castling
    if move == "0-0"
    elsif move == "0-0-0"
    end
  
    move = process_input(move)
    valid = false
    candidates = generate_candidates(@player, move[0])

    candidates.each do |c|
      start = c.pos
      final = Coordinate.new(8 - move[2].to_i, move[1].ord - 97)

      if c.is_valid_move?(start, final, @board)
        # p c.pos.display_coordinate

        king = @player == "white" ? white_pieces[:king][0] : black_pieces[:king][0]

        c.pos = final
        temp = @board[final.x][final.y]
        @board[final.x][final.y] = @board[start.x][start.y]
        opponent_pieces = @player == "white" ? black_pieces : white_pieces
        if king.is_check?(final, opponent_pieces, @board)
          c.pos = start
          @board[final.x][final.y] = temp
          print "King is in check. "
        else
          @board[final.x][final.y] = @board[start.x][start.y]
          @board[start.x][start.y] = '_'
          valid = true
        end
      end
    end

    if !valid
      puts "This is not a valid move. Please enter another move: "
      gets
    else
      @player = @player == "white" ? "black" : "white"
      gets
      # puts "Board updated"
      # gets
    end
  end

  def is_checkmate?
    king = @player == "white" ? white_pieces[:king][0] : black_pieces[:king][0]
    opponent_pieces = @player == "white" ? black_pieces : white_pieces

    start_pos = king.pos

    if !king.is_check?(king.pos, opponent_pieces, @board)
      return false
    end

    checkmate = true

    for i in -1..1
      next if start_pos.x + i < 0 || start_pos.x + i > 7
      for j in -1..1
        next if start_pos.y + j < 0 || start_pos.y + j > 7
        pos = Coordinate.new(start_pos.x + i, start_pos.y + j)

        if !king.is_valid_move?(start_pos, pos, @board)
          checkmate = checkmate && true
          next
        end

        # temporary move king to square
        king.pos = pos
        temp = board[pos.x][pos.y]
        board[pos.x][pos.y] = king
        board[start_pos.x][start_pos.y] = "_"
        puts pos.display_coordinate
        # puts king.is_check?(king.pos, opponent_pieces, @board)
        # puts !king.is_valid_move?(start_pos, pos, @board)
        # Why the king.ischeck is showing check for all square when qxf7?
        checkmate = checkmate && (king.is_check?(king.pos, opponent_pieces, @board))
        # puts "checkmate is #{checkmate}"
        
        king.pos = start_pos
        board[start_pos.x][start_pos.y] = king
        board[pos.x][pos.y] = temp

      end
    end
    return checkmate
  end

  def generate_candidates(player, piece)
    case piece
    when "k"
      candidates = player == "white" ? white_pieces[:king] : black_pieces[:king]
    when "q"
      candidates = player == "white" ? white_pieces[:queen] : black_pieces[:queen]
    when "r"
      candidates = player == "white" ? white_pieces[:rook] : black_pieces[:rook]
    when "b"
      candidates = player == "white" ? white_pieces[:bishop] : black_pieces[:bishop]
    when "n"
      candidates = player == "white" ? white_pieces[:knight] : black_pieces[:knight]
    when " "
      candidates = player == "white" ? white_pieces[:pawn] : black_pieces[:pawn]
    end

    return candidates
  end

  def notify_check
    king = @player == "white" ? white_pieces[:king][0] : black_pieces[:king][0]
    opponent_pieces = @player == "white" ? black_pieces : white_pieces
    if king.is_check?(king.pos, opponent_pieces, @board)
      print "#{@player.capitalize} king is in check. "
    end
  end

  def process_input(move)
    move = move.delete("x")
    if move.length == 2
      move = " " + move
    end
    move = move.chars
    return move
  end
end