require 'rainbow'

class Board
  ROWS = 8
  COLUMNS = 8
  attr_accessor :rows, :columns, :ships, :bombs

  def initialize(rows: ROWS, columns: COLUMNS)
    self.rows = rows
    self.columns = columns
    self.ships = []
    self.bombs = []
  end

  def place_ship(new_ship)
    # Check for ship to be within the bounds of the board
    return false if !ship_within_bounds?(new_ship)

    # Check if ship overlaps with existing ships
    return false if self.ships.any? do |ship|
      ship.overlaps?(new_ship)
    end

    self.ships << new_ship
    true
  end

  def fire(bomb)
    self.bombs << bomb

    ship_hit = self.ships.any? do |ship|
      (bomb.x >= ship.x1 && bomb.x <= ship.x2) && (bomb.y >= ship.y1 && bomb.y <= ship.y2)
    end

    return :miss unless ship_hit

    return :sunk if update_ships()

    :hit
  end

  def all_ships_destroyed?
    raise 'No ships were placed' if self.ships.none?

    self.ships.all? { |ship| ship.sunk }
  end

  private

  def ship_within_bounds?(ship)
    (ship.x1 >= 1 && ship.x2 <= ROWS) && (ship.y1 >= 1 && ship.y2 <= COLUMNS)
  end

  def update_ships
    ship_sunk = false
    self.ships.each do |ship|
      # skip if the ship is already sunk
      next if ship.sunk

      if ship.x1 == ship.x2 # Vertical positioning
        # Check if a bomb is present in all the positions where the ship is located
        ship.sunk = (ship.y1..ship.y2).all? do |y_index|
          self.bombs.any? { |b| b.x == ship.x1 && b.y == y_index }
        end
      elsif ship.y1 == ship.y2 # Horizontal positioning
        # Check if a bomb is present in all the positions where the ship is located
        ship.sunk = (ship.x1..ship.x2).all? do |x_index|
          self.bombs.any? { |b| b.x == x_index && b.y == ship.y1 }
        end
      else
        raise 'Invalid ship position'
      end

      # puts "#{ship.name}, #{ship.sunk}"
      ship_sunk = true if ship.sunk
    end
    ship_sunk
  end
end