require_relative './../app/battleship_builder.rb'

describe BattleshipBuilder do
  describe 'initializing battleship' do
    let(:builder) { BattleshipBuilder.new }

    it 'populates the AI Board with ships' do
      expect(builder.ai_board.ships.count).to eq(2)
    end

    it 'populates the User Board with ships' do
      expect(builder.user_board.ships.count).to eq(5)
    end
  end
end