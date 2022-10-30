# require rspec
require_relative './../../app/models/board.rb'
require_relative './../../app/models/bomb.rb'

describe Board do
  describe 'building a board' do
    let(:board) { Board.new }

    it 'has default rows and columns' do
      expect(board.rows).to eq(8)
      expect(board.columns).to eq(8)
    end

    it 'has no ships and bombs on the board' do
      expect(board.ships).to be_empty
      expect(board.bombs).to be_empty
    end
  end

  describe 'place_ship' do
    let(:board) { Board.new }

    subject { board.place_ship(ship) }

    context 'when out of bounds' do
      context 'when out of bounds on x-axis' do
        let(:ship) { Ship.new(name: 'test1', x1: 1, y1: 1, x2: 25, y2: 1) }

        it { is_expected.to be_falsey }

        it 'does not add the ship to the board' do
          subject
          expect(board.ships.count).to eq(0)
        end
      end

      context 'when out of bounds on y-axis' do
        let(:ship) { Ship.new(name: 'test1', x1: 1, y1: 25, x2: 5, y2: 25) }

        it { is_expected.to be_falsey }

        it 'does not add the ship to the board' do
          subject
          expect(board.ships.count).to eq(0)
        end
      end
    end

    context 'when overlapping with existing ships' do
      let(:existing_ship) { Ship.new(name: 'test1', x1: 1, y1: 1, x2: 5, y2: 1) }
      let(:ship) { Ship.new(name: 'test1', x1: 2, y1: 1, x2: 7, y2: 1) }

      before do
        board.place_ship(existing_ship)
      end

      it { is_expected.to be_falsey }

      it 'does not add the ship to the board' do
        subject
        expect(board.ships.count).to eq(1)
      end
    end

    context 'when not overlapping with existing ships' do
      let(:existing_ship) { Ship.new(name: 'test1', x1: 1, y1: 1, x2: 5, y2: 1) }
      let(:ship) { Ship.new(name: 'test1', x1: 7, y1: 1, x2: 8, y2: 1) }

      before do
        board.place_ship(existing_ship)
      end

      it { is_expected.to be_truthy }

      it 'adds the ship to the board' do
        subject
        expect(board.ships.count).to eq(2)
      end
    end
  end

  describe 'fire' do
    let(:board) { Board.new }
    let(:ship) { Ship.new(name: 'test', x1: 5, y1: 1, x2: 7, y2: 1) }

    before do
      board.place_ship(ship)
    end

    subject { board.fire(bomb) }

    context 'when the bomb misses' do
      let(:bomb) { Bomb.new(x: 7, y: 7) }

      it { is_expected.to eq(:miss) }
    end

    context 'when the bomb hits a ship' do
      let(:bomb) { Bomb.new(x: 6, y: 1) }

      it { is_expected.to eq(:hit) }
    end

    context 'when the bomb sinks a ship' do
      let(:bomb) { Bomb.new(x: 6, y: 1) }

      before do
        board.fire(Bomb.new(x: 5, y: 1))
        board.fire(Bomb.new(x: 7, y: 1))
      end

      it { is_expected.to eq(:sunk) }
    end
  end

  describe 'all_ships_destroyed?' do
    let(:board) { Board.new }

    subject { board.all_ships_destroyed? }

    context 'when there are no ships' do
      it 'raises an error' do
        expect { subject }.to raise_error 'No ships were placed'
      end
    end

    context 'when ships are present' do
      let(:ship1) { Ship.new(name: 'test1', x1: 1, y1: 1, x2: 5, y2: 1) }
      let(:ship2) { Ship.new(name: 'test2', x1: 4, y1: 1, x2: 4, y2: 4) }

      before do
        board.place_ship(ship1)
        board.place_ship(ship2)
      end

      context 'when none of them are sunk' do
        it { is_expected.to be_falsey }
      end

      context 'when some of them are sunk' do
        before do
          ship2.sunk = true
        end

        it { is_expected.to be_falsey }
      end

      context 'when all of them are sunk' do
        before do
          ship1.sunk = true
          ship2.sunk = true
        end

        it { is_expected.to be_truthy }
      end
    end
    
  end
end