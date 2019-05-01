require 'rails_helper'

RSpec.describe StoreThermostatReading, type: :interactor do
  subject(:result) do
    StoreThermostatReading.call(
      params: reading_params, thermostat: thermostat
    )
  end

  describe '.call' do
    before do
      allow(thermostat).to receive(:next_sequence_number).and_return(1)
      allow(StoreReadingWorker).to receive(:perform_async).and_return(nil)
    end

    context 'when given valid params' do
      let(:thermostat) { create(:thermostat) }
      let(:reading) { build(:reading, thermostat: thermostat) }
      let(:reading_params) do
        {
          temperature: reading.temperature,
          humidity: reading.humidity,
          battery_charge: reading.battery_charge
        }
      end

      it 'succeeds' do
        expect(result).to be_a_success
      end

      it 'provides the reading' do
        expect(result.reading.attributes).to eql(reading.attributes)
      end

      it "provides the reading's sequence number" do
        expect(result.reading.number).to eq(1)
      end
    end

    context 'when given invalid params' do
      let(:thermostat) { create(:thermostat) }
      let(:reading) { build(:reading, thermostat: thermostat) }
      let(:reading_params) { {} }

      it 'fails' do
        expect(result).to be_a_failure
      end

      it 'provides a reading object with error' do
        expect(result.reading.errors).to be_present
      end
    end
  end
end
