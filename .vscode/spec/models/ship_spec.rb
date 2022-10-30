# require rspec
require_relative './../../app/models/ship.rb'

describe Ship do
  describe 'building ship' do
    # Add a test to build a ship model
  end

  describe 'overlaps?' do
    let(:ship) { Ship.new(name: 'existing_ship', x1: 3, y1: 1, x2: 7, y2: 1) }
    
    subject { ship.overlaps?(test_ship) }

    context 'when there is no overlap' do
      let(:test_ship) { Ship.new(name: 'test', x1: 4, y1: 4, x2: 4, y2: 8) }

      it { is_expected.to be_falsey }
    end
    
    context 'when there is overlap' do
      context 'overlap on x-axis' do
        context 'when test ship begins within the existing ship' do
          let(:test_ship) { Ship.new(name: 'test', x1: 5, y1: 1, x2: 8, y2: 1) }

          it { is_expected.to be_truthy }
        end

        context 'when test ship ends within the existing ship' do
          let(:test_ship) { Ship.new(name: 'test', x1: 1, y1: 1, x2: 5, y2: 1) }

          it { is_expected.to be_truthy }
        end

        context 'when test ship begins and ends within the existing ship' do
          let(:test_ship) { Ship.new(name: 'test', x1: 5, y1: 1, x2: 6, y2: 1) }

          it { is_expected.to be_truthy }
        end
      end

      context 'overlap on y-axis' do
        let(:ship) { Ship.new(name: 'existing_ship', x1: 1, y1: 3, x2: 1, y2: 7) }

        context 'when test ship begins within the existing ship' do
          let(:test_ship) { Ship.new(name: 'test', x1: 1, y1: 5, x2: 1, y2: 8) }

          it { is_expected.to be_truthy }
        end

        context 'when test ship ends within the existing ship' do
          let(:test_ship) { Ship.new(name: 'test', x1: 1, y1: 1, x2: 1, y2: 5) }

          it { is_expected.to be_truthy }
        end

        context 'when test ship begins and ends within the existing ship' do
          let(:test_ship) { Ship.new(name: 'test', x1: 1, y1: 5, x2: 1, y2: 6) }

          it { is_expected.to be_truthy }
        end
      end
    end
  end
end
