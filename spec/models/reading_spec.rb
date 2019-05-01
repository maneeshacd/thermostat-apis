require 'rails_helper'

RSpec.describe Reading, type: :model do
  describe 'Associations' do
    it { should belong_to(:thermostat) }
  end

  describe 'Validations' do
    subject { create(:reading) }

    it { should validate_presence_of(:number) }
    it { should validate_uniqueness_of(:number).scoped_to(:thermostat_id) }

    it { should validate_presence_of(:temperature) }
    it { should validate_numericality_of(:temperature) }

    it { should validate_presence_of(:humidity) }
    it { should validate_numericality_of(:humidity) }

    it { should validate_presence_of(:battery_charge) }
    it { should validate_numericality_of(:battery_charge) }
  end

  describe 'public class methods' do
    context 'responds to its methods' do
      it { expect(Reading).to respond_to(:next_id) }
    end

    context 'executes methods correctly' do
      context 'next_id' do
        let!(:thermostat) { create(:thermostat) }
        let!(:reading) { create(:reading, thermostat: thermostat) }

        it 'gives next primary_key id for a reading' do
          expect(Reading.next_id).to eq(reading.id + 1)
        end
      end
    end
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { expect(Reading.new).to respond_to(:as_json) }
    end

    context 'executes methods correctly' do
      context 'as_json' do
        let!(:thermostat) { build(:thermostat) }
        let!(:reading) { build(:reading, thermostat: thermostat) }

        it 'returns reading object hash excluding created_at and updated_at' do
          expect(reading.as_json).not_to include(:created_at, :updated_at)
        end
      end
    end
  end
end
