require 'rails_helper'

RSpec.describe ReadingFromSidekiq, type: :interactor do
  subject(:result) do
    ReadingFromSidekiq.call(
      token: reading_params[:token].to_s,
      queue: 'testing'
    )
  end

  describe '.call' do
    let(:thermostat) { create(:thermostat) }
    let(:reading_params) do
      attributes_for(:reading, thermostat_id: thermostat.id)
    end

    context 'when given token present in sidekiq' do
      let!(:sidekiq_job) do
        StoreReadingWorker.set(queue: :testing).perform_async(reading_params)
      end

      it 'succeeds' do
        expect(result).to be_a_success
      end

      it 'provides the reading in sidekiq' do
        expect(result.reading).to eql(reading_params.as_json)
        Sidekiq::Queue.new('testing').clear
      end
    end

    context 'when given token not present in sidekiq' do
      it 'fails' do
        expect(result).to be_a_failure
      end

      it 'provides a empty reading object' do
        expect(result.reading).to be_empty
      end
    end
  end
end
