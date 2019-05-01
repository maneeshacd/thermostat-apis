require 'rails_helper'

RSpec.describe Thermostat, type: :model do
  describe 'Associations' do
    it { should have_many(:readings).dependent(:destroy) }
  end

  describe 'Validations' do
    subject { create(:thermostat) }

    it { should validate_presence_of(:address) }

    it { should validate_presence_of(:household_token) }
    it { should validate_uniqueness_of(:household_token) }
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { expect(Thermostat.new).to respond_to(:next_sequence_number) }
      it { expect(Thermostat.new).to respond_to(:reading_statistics) }
    end

    context 'executes methods correctly' do
      context 'next_sequence_number' do
        let!(:thermostat) { create(:thermostat) }
        let!(:reading) { create(:reading, thermostat: thermostat) }

        it 'gives next sequence number for a thermostat' do
          expect(thermostat.next_sequence_number).to eq(2)
        end
      end

      context 'as_json' do
        let!(:thermostat) { build(:thermostat) }

        it 'returns thermostat object hash excluding
            created_at and updated_at' do
          expect(thermostat.as_json).not_to include(:created_at, :updated_at)
        end
      end

      context 'reading_statistics' do
        subject(:statistics) do
          thermostat.reading_statistics(readings_from_sidekiq)
        end
        let(:thermostat) { create(:thermostat) }
        let!(:reading) { create(:reading, thermostat: thermostat) }
        let(:readings_from_sidekiq) do
          [{
            id: 2, thermostat_id: thermostat.id, number: 2, temperature: 10.00,
            humidity: 20.00, battery_charge: 30.00
          }].as_json
        end

        let(:result) do
          {
            'temperature': {
              'min': [
                reading.temperature,
                readings_from_sidekiq.first['temperature']
              ].min,
              'avg': (
                [
                  reading.temperature,
                  readings_from_sidekiq.first['temperature']
                ].sum / 2.0
              ).round(2),
              'max': [
                reading.temperature,
                readings_from_sidekiq.first['temperature']
              ].max
            },
            'humidity': {
              'min': [
                reading.humidity, readings_from_sidekiq.first['humidity']
              ].min,
              'avg': (
                [
                  reading.humidity, readings_from_sidekiq.first['humidity']
                ].sum / 2
              ).round(2),
              'max': [
                reading.humidity, readings_from_sidekiq.first['humidity']
              ].max
            },
            'battery_charge': {
              'min': [
                reading.battery_charge,
                readings_from_sidekiq.first['battery_charge']
              ].min,
              'avg': (
                [
                  reading.battery_charge,
                  readings_from_sidekiq.first['battery_charge']
                ].sum / 2
              ).round(2),
              'max': [
                reading.battery_charge,
                readings_from_sidekiq.first['battery_charge']
              ].max
            }
          }
        end

        it 'should return a hash' do
          expect(statistics).to be_an_instance_of(Hash)
        end

        it 'should have keys temperature, humidity, battery_charge' do
          expect(statistics).to include(:temperature, :humidity, :battery_charge)
        end

        it 'returns the statistics' do
          expect(statistics).to eq(result)
        end
      end
    end
  end
end
