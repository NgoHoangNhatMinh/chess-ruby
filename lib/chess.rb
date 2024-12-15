class Board
  attr_accessor :checkmate, :board

  def initialize
    @board = Array.new(8) { Array.new(8, "_") }
    @checkmate = false

    for i in 0..7
      @board[1][i] = Pawn.new("black")
      @board[6][i] = Pawn.new("white")

      if i == 0 || i == 7
        @board[0][i] = Rook.new("black")
        @board[7][i] = Rook.new("white")
      elsif i == 1 || i == 6
        @board[0][i] = Knight.new("black")
        @board[7][i] = Knight.new("white")
      elsif i == 2 || i == 5
        @board[0][i] = Bishop.new("black")
        @board[7][i] = Bishop.new("white")
      elsif i == 3
        @board[0][i] = Queen.new("black")
        @board[7][i] = Queen.new("white")
      elsif i == 4
        @board[0][i] = King.new("black")
        @board[7][i] = King.new("white")
      end
    end

    # @valid_moves = Hash.new
    # @board.each_with_index do |row, i|
    #   row.each_with_index do |col, j|
    #     if col != '_'
    #       valid_moves[col.representation.to_sym] = col.generate_moves(@board)
    #     end
    #   end
    # end

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
    # Do a primitive move "p/e2/e4"
    move = move.chars
    piece = move[0]
    start = [8 - move[2].to_i, move[1].ord - 97]
    final = [8 - move[4].to_i, move[3].ord - 97]
    if @board[start[0]][start[1]] != "_" && @board[start[0]][start[1]].is_valid_move?(start, final, @board)
      @board[final[0]][final[1]] = @board[start[0]][start[1]]
      @board[start[0]][start[1]] = '_'
    end
  end

  def find_move(piece)
    
  end

  def is_checkmate?
    false
  end
end

class Piece
  def initialize(color)
    @color = color
  end
end

class King < Piece
  def initialize(color)
    super(color)
  end

  def symbol
    if @color == "white"
      return 0x2654.chr('UTF-8')
    else
      return 0x265A.chr('UTF-8')
    end
  end

  def is_valid_move?(start, final, board)
    true
  end
end

class Queen < Piece
  def initialize(color)
    super(color)
  end

  def symbol
    if @color == "white"
      return 0x2655.chr('UTF-8')
    else
      return 0x265B.chr('UTF-8')
    end
  end

  def is_valid_move?(start, final, board)
    true
  end
end

class Rook < Piece
  def initialize(color)
    super(color)
  end

  def symbol
    if @color == "white"
      return 0x2656.chr('UTF-8')
    else
      return 0x265C.chr('UTF-8')
    end
  end

  def is_valid_move?(start, final, board)
    true
  end
end

class Bishop < Piece
  def initialize(color)
    super(color)
  end

  def symbol
    if @color == "white"
      return 0x2657.chr('UTF-8')
    else
      return 0x265D.chr('UTF-8')
    end
  end

  def is_valid_move?(start, final, board)
    true
  end
end

class Knight < Piece
  def initialize(color)
    super(color)
  end

  def symbol
    if @color == "white"
      return 0x2658.chr('UTF-8')
    else
      return 0x265E.chr('UTF-8')
    end
  end

  def is_valid_move?(start, final, board)
    true
  end
end

class Pawn < Piece
  def initialize(color)
    super(color)
  end

  def symbol
    if @color == "white"
      return 0x2659.chr('UTF-8')
    else
      return 0x265F.chr('UTF-8')
    end
  end

  def is_valid_move?(start, final, board)
    true
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
# board = Board.new
# board.display_board
# board.update_board("pe2e4")
# board.display_board
# p board.board[3][1]

# puts "\x2654".force_encoding("UTF-16")
