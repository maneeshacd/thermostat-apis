require 'rails_helper'

RSpec.describe ThermostatsController, type: :controller do
  before do
    request.headers.merge!(
      'Api-Key': ENV['API_KEY'], 'Api-Secret': ENV['API_SECRET']
    )
  end

  describe '#statistics' do
    before do
      stub_const('QUEUE', 'testing')

      allow(FetchReadingsOfASingleThermostatFromQueue).to receive(:call)
        .once.with(queue: QUEUE, thermostat_id: thermostat.id)
        .and_return(readings_result)

      allow(GetReadingStatistics).to receive(:call)
        .once.with(
          readings_from_queue: readings_result.readings,
          thermostat: thermostat
        ).and_return({})
    end

    context 'when successful' do
      let(:thermostat) { create(:thermostat) }
      let!(:reading) { create(:reading, thermostat: thermostat) }

      context 'when readings present in queue' do
        let(:readings_from_queue) do
          [{
            id: 2, thermostat_id: thermostat.id, number: 2,
            temperature: 10.00, humidity: 20.00, battery_charge: 30.00
          }].as_json
        end
        let(:readings_result) do
          double(
            :readings_result, success?: true, readings: readings_from_queue
          )
        end
        it 'returns success json response' do
          resp = post :statistics,
                      params: { household_token: thermostat.household_token },
                      format: :json

          expect(resp).to have_http_status(:ok)
          expect(JSON.parse(resp.body)).to include_json(
            status: 'success',
            code: 200
          )
        end
      end

      context 'when queue readings empty' do
        let(:readings_result) do
          double(:readings_result, success?: false, readings: [])
        end

        it 'returns success json response ' do
          resp = post :statistics,
                      params: { household_token: thermostat.household_token },
                      format: :json

          expect(resp).to have_http_status(:ok)
          expect(JSON.parse(resp.body)).to include_json(
            status: 'success',
            code: 200
          )
        end
      end
    end

    context 'when unsuccessful' do
      let(:thermostat) { create(:thermostat) }
      let!(:reading) { create(:reading, thermostat: thermostat) }
      let(:readings_result) do
        double(:readings_result, success?: false, readings: [])
      end

      context 'invalid household_token' do
        it 'returns object not found error as json response' do
          resp =
            post :statistics,
                 params: { household_token: '' }, format: :json

          expect(resp).to have_http_status(:ok)
          expect(JSON.parse(resp.body)).to include_json(
            status: 'Bad Request',
            code: 404, data: nil,
            message: 'Object Not Found'
          )
        end
      end
    end
  end
end
