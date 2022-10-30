class Ship
  attr_accessor :name, :x1, :y1, :x2, :y2, :sunk

  def initialize(name:, x1:, y1:, x2:, y2:)
    self.name = name
    self.x1 = x1
    self.y1 = y1
    self.x2 = x2
    self.y2 = y2
    self.sunk = false
  end

  def overlaps?(new_ship)
    x_coordinates_overlap?(new_ship) && y_coordinates_overlap?(new_ship)
  end

  private

  def x_coordinates_overlap?(new_ship)
    (new_ship.x1 >= self.x1 && new_ship.x1 <= self.x2) || (new_ship.x2 >= self.x1 && new_ship.x2 <= self.x2)
  end
 
  def y_coordinates_overlap?(new_ship)
    (new_ship.y1 >= self.y1 && new_ship.y1 <= self.y2) || (new_ship.y2 >= self.y1 && new_ship.y2 <= self.y2)
  end
end