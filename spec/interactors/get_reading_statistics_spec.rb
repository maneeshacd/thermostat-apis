require 'rails_helper'

RSpec.describe GetReadingStatistics, type: :interactor do
  subject(:result) do
    GetReadingStatistics.call(
      readings_from_queue: reading_params,
      thermostat: thermostat
    )
  end

  describe '.call' do
    let(:thermostat) { create(:thermostat) }

    context 'when thermostat have readings' do
      let(:reading) { create(:reading, thermostat: thermostat) }
      let(:reading_params) do
        [attributes_for(:reading, thermostat_id: thermostat.id)]
      end

      it 'succeeds' do
        expect(result).to be_a_success
      end
    end

    context 'when have no readings' do
      let(:reading_params) { [] }

      it 'fails' do
        expect(result).to be_a_failure
      end

      it 'provides a empty reading object' do
        expect(result.statistics).to be_empty
      end
    end
  end
end
