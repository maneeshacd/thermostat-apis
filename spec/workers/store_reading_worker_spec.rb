require 'rails_helper'

RSpec.describe StoreReadingWorker, type: :worker do
  let(:thermostat) { create(:thermostat) }

  context 'success' do
    let(:reading) { attributes_for(:reading, thermostat_id: thermostat.id) }

    it 'creates reading object' do
      expect { described_class.new.perform(reading) }
        .to change { Reading.count }.by(1)
    end
  end

  context 'when params containing existing id' do
    let!(:reading) { create(:reading, thermostat: thermostat) }
    let(:reading_attrs) do
      attributes_for(:reading, thermostat_id: thermostat.id).as_json
    end
    it 'return false' do
      expect(described_class.new.perform(reading_attrs)).to be_nil
    end
  end

  context 'when params containing sequence number' do
    let!(:reading) { create(:reading, id: 2, thermostat: thermostat) }
    let(:reading_attrs) do
      attributes_for(
        :reading, id: 3, thermostat_id: thermostat.id, number: reading.number
      ).as_json
    end
    it 'return false' do
      expect(described_class.new.perform(reading_attrs)).to be_nil
    end
  end
end
