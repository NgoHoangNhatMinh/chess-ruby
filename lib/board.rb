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
    valid = false

    # Add castling
    if move == "0-0"
      if player == "white"
        king = @white_pieces[:king][0]
        rook = @white_pieces[:rook][1]
        opponent_hash = @black_pieces
        if king.is_check?(Coordinate.new(7, 5), opponent_hash, @board) || king.is_check?(Coordinate.new(7, 6), opponent_hash, @board) || @board[7][5] != "_" || @board[7][6] != "_" || !rook.first_move || !king.first_move
          valid = false
        else
          valid = true
          @board[7][5] = rook
          @board[7][6] = king
          @board[7][4] = "_"
          @board[7][7] = "_"

          rook.pos = Coordinate.new(7, 5)
          king.pos = Coordinate.new(7, 6)

          rook.first_move = false
          king.first_move = false
        end
      else
        king = @black_pieces[:king][0]
        rook = @black_pieces[:rook][1]
        opponent_hash = @white_pieces
        if king.is_check?(Coordinate.new(0, 5), opponent_hash, @board) || king.is_check?(Coordinate.new(0, 6), opponent_hash, @board) || @board[0][5] != "_" || @board[0][6] != "_" || !rook.first_move || !king.first_move
          valid = false
        else
          valid = true
          @board[0][5] = rook
          @board[0][6] = king
          @board[0][4] = "_"
          @board[0][7] = "_"

          rook.pos = Coordinate.new(0, 5)
          king.pos = Coordinate.new(0, 6)

          rook.first_move = false
          king.first_move = false
        end
      end
    elsif move == "0-0-0"
      if player == "white"
        king = @white_pieces[:king][0]
        rook = @white_pieces[:rook][1]
        opponent_hash = @black_pieces
        if king.is_check?(Coordinate.new(7, 3), opponent_hash, @board) || king.is_check?(Coordinate.new(7, 2), opponent_hash, @board) || @board[7][3] != "_" || @board[7][2] != "_" || !rook.first_move || !king.first_move
          valid = false
        else
          valid = true
          @board[7][2] = rook
          @board[7][3] = king
          @board[7][4] = "_"
          @board[7][0] = "_"

          rook.pos = Coordinate.new(7, 2)
          king.pos = Coordinate.new(7, 3)

          rook.first_move = false
          king.first_move = false
        end
      else
        king = @black_pieces[:king][0]
        rook = @black_pieces[:rook][1]
        opponent_hash = @white_pieces
        if king.is_check?(Coordinate.new(0, 2), opponent_hash, @board) || king.is_check?(Coordinate.new(0, 3), opponent_hash, @board) || @board[0][2] != "_" || @board[0][3] != "_" || !rook.first_move || !king.first_move
          valid = false
        else
          valid = true
          @board[0][2] = rook
          @board[0][3] = king
          @board[0][4] = "_"
          @board[0][0] = "_"

          rook.pos = Coordinate.new(0, 2)
          king.pos = Coordinate.new(0, 3)

          rook.first_move = false
          king.first_move = false
        end
      end
    else
      move = process_input(move)
      candidates = generate_candidates(@player, move[0])
      good_candidates = []
  
      candidates.each do |c|
        start = c.pos
        final = Coordinate.new(8 - move[2].to_i, move[1].ord - 97)
  
        if c.is_valid_move?(start, final, @board)
          king = @player == "white" ? white_pieces[:king][0] : black_pieces[:king][0]
          rooks = @player == "white" ? white_pieces[:rook] : black_pieces[:rook]

          c.pos = final
          temp = @board[final.x][final.y]
          @board[final.x][final.y] = @board[start.x][start.y]
          opponent_pieces = @player == "white" ? black_pieces : white_pieces
          if king.is_check?(final, opponent_pieces, @board)
            c.pos = start
            @board[final.x][final.y] = temp
            print "King is in check. "
          else
            if c == king || c == rooks[0] || c == rooks[1]
              c.first_move = false
            end
            good_candidates.push(c)

            @board[final.x][final.y] = @board[start.x][start.y]
            @board[start.x][start.y] = '_'
            valid = true
          end
        end
      end
    end
    
    if !valid
      puts "This is not a valid move. Press y to continue playing or n to save game"
      gets
    else
      @player = @player == "white" ? "black" : "white"
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
        checkmate = checkmate && (king.is_check?(king.pos, opponent_pieces, @board))
        
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