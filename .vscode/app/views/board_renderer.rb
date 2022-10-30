require_relative './../models/board.rb'

class BoardRenderer
  attr_accessor :player, :board, :board_2d

  def initialize(player:, board:)
    self.player = player
    self.board = board
    self.board_2d = Array.new(self.board.rows) { Array.new(self.board.columns) { Rainbow("x") } }
  end

  def render
    # Update the board with ships to render
    self.board.ships.each do |ship|
      update_board_with_ship(ship)
    end

    # Update the board with bombs to render
    self.board.bombs.each do |bomb|
      update_board_with_bomb(bomb)
    end

    puts "   1 2 3 4 5 6 7 8"
    index = 1
    self.board_2d.each do |row|
      puts ["#{index} ", row].flatten.join(" ")
      index += 1
    end
  end

  def update_board_with_ship(ship)
    ship_representation = nil
    if self.player == :ai
      return unless ship.sunk
      ship_representation = Rainbow("x").red
    elsif self.player == :user
      ship_representation = Rainbow("x").green
    else
      raise 'Invalid user'
    end

    if ship.x1 == ship.x2 # Vertical positioning
      (ship.y1..ship.y2).each do |y_index|
        self.board_2d[ship.x1-1][y_index-1] = ship_representation
      end
    elsif ship.y1 == ship.y2 # Horizontal positioning
      (ship.x1..ship.x2).each do |x_index|
        self.board_2d[x_index-1][ship.y1-1] = ship_representation
      end
    else
      raise 'Invalid ship position'
    end
  end

  def ship_hit?(bomb)
    self.board.ships.any? do |ship|
      (ship.x1 <= bomb.x && ship.x2 >= bomb.x) && (ship.y1 <= bomb.y && ship.y2 >= bomb.y)
    end
  end

  def update_board_with_bomb(bomb)
    bomb_representation = nil
    if self.player == :ai
      # For the AI Player, we only want the board to be updated if the ship was hit
      return unless ship_hit?(bomb)
      bomb_representation = Rainbow("x").red
    elsif self.player == :user
      if self.board_2d[bomb.x-1][bomb.y-1] == Rainbow("x").green
        # If the bomb hit the ship
        bomb_representation = Rainbow("x").red
      else
        # If the bomb did not hit the ship
        bomb_representation = Rainbow("b").red
      end
    else
      raise 'Invalid user'
    end

    self.board_2d[bomb.x-1][bomb.y-1] = bomb_representation
  end
end