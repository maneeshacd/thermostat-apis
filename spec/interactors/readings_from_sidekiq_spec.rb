require 'rails_helper'

RSpec.describe ReadingsFromSidekiq, type: :interactor do
  subject(:result) do
    ReadingsFromSidekiq.call(queue: 'testing', thermostat_id: thermostat.id)
  end

  describe '.call' do
    let(:thermostat) { create(:thermostat) }
    let(:reading_params) do
      attributes_for(:reading, thermostat_id: thermostat.id)
    end

    context 'when items in sidekiq queue' do
      let!(:sidekiq_job) do
        StoreReadingWorker.set(queue: :testing).perform_async(reading_params)
      end

      it 'succeeds' do
        expect(result).to be_a_success
      end

      it 'provides the readings in sidekiq' do
        expect(result.readings).to be_an_instance_of(Array)
        expect(result.readings).to eql([reading_params.as_json])
        Sidekiq::Queue.new('testing').clear
      end
    end

    context 'when items empty in sidekiq' do
      it 'fails' do
        expect(result).to be_a_failure
      end

      it 'provides a empty readings array' do
        expect(result.readings).to be_empty
      end
    end
  end
end
