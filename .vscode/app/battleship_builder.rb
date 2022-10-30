require_relative './models/board.rb'
require_relative './models/bomb.rb'
require_relative './models/ship.rb'

class BattleshipBuilder
  SHIP_SIZES = {
    battleship: 4,
    carrier: 5,
    cruiser: 3,
    submarine: 3,
    destroyer: 2,
  }
  AI_SHIPS = {
    battleship: Ship.new(name: 'battleship', x1: 8, y1: 1, x2: 8, y2: 4),
    destroyer: Ship.new(name: 'destroyer', x1: 6, y1: 3, x2: 7, y2: 3),
    # carrier: Ship.new(name: 'carrier', x1: 5, y1: 2, x2: 5, y2: 6),
    # cruiser: Ship.new(name: 'cruiser', x1: 1, y1: 1, x2: 3, y2: 1),
    # submarine: Ship.new(name: 'submarine', x1: 1, y1: 3, x2: 1, y2: 5),
  }

  attr_accessor :ai_board, :user_board
  
  def initialize()
    @ai_board = Board.new
    @user_board = Board.new
    populate_ai_board()
    populate_user_board()
  end

  def populate_ai_board
    AI_SHIPS.each do |_, ship|
      @ai_board.place_ship(ship)
    end
  end
  
  def populate_user_board
    SHIP_SIZES.each do |name, size|
      while true do
        x = rand(Board::ROWS) + 1
        y = rand(Board::COLUMNS) + 1
        # Try placing the ship horizontally
        temp_ship_horizontal = Ship.new(name: name.to_s, x1: x, y1: y, x2: x + size - 1, y2: y)
        break if @user_board.place_ship(temp_ship_horizontal)

        # Try placing the ship vertically
        temp_ship_vertical = Ship.new(name: name.to_s, x1: x, y1: y, x2: x, y2: y + size - 1)
        break if @user_board.place_ship(temp_ship_vertical)
      end
    end
  end
end
