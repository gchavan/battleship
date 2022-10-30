require_relative './battleship_builder.rb'
require_relative './views/board_renderer.rb'
require_relative './models/bomb.rb'

class Battleship
  def render(ai_board_renderer, user_board_renderer)
    puts Rainbow("AI board").underline
    ai_board_renderer.render
    puts
    puts Rainbow("User board").underline
    user_board_renderer.render
  end

  def run
    builder = BattleshipBuilder.new
    ai_board = builder.ai_board
    user_board = builder.user_board
    ai_board_renderer = BoardRenderer.new(player: :ai, board: ai_board)
    user_board_renderer = BoardRenderer.new(player: :user, board: user_board)
    render(ai_board_renderer, user_board_renderer)

    while(!ai_board.all_ships_destroyed? && !user_board.all_ships_destroyed?) do
      puts "Where would like to fire the bomb? x, y"
      bomb_position = gets
      x, y = bomb_position.chomp.split(',').map(&:to_i)
      user_bomb = Bomb.new(x: x, y: y)
      status = ai_board.fire(user_bomb)
      puts "You fired at position [#{x},#{y}]: #{status.to_s}"

      x = rand(Board::ROWS) + 1
      y = rand(Board::COLUMNS) + 1
      ai_bomb = Bomb.new(x: x, y: y)
      status = user_board.fire(ai_bomb)
      puts "AI fired at position [#{x},#{y}]: #{status.to_s}"

      render(ai_board_renderer, user_board_renderer)
    end

    puts
    if ai_board.all_ships_destroyed?
      puts Rainbow("You won!!").green.bright.underline
    elsif user_board.all_ships_destroyed?
      puts Rainbow("AI won!!").red.bright.underline
    end
    puts
  end
end

Battleship.new.run
