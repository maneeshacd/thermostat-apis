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
end
