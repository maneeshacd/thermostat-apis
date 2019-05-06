require 'rails_helper'

RSpec.describe StatisticsController, type: :controller do
  before do
    request.headers.merge!(
      'Api-Key': ENV['API_KEY'], 'Api-Secret': ENV['API_SECRET']
    )
  end

  describe '#show' do
    let(:final_statistics) do
      {
        temperature: { min: 9, avg: 9, max: 9 },
        humidity: { min: 10, avg: 10, max: 10 },
        battery_charge: { min: 30, avg: 30, max: 30 }
      }
    end
    let(:statistics_result) do
      double(
        :statistics_result, success?: true, statistics: final_statistics
      )
    end

    before do
      stub_const('QUEUE', 'testing')

      allow(FetchReadingsOfASingleThermostatFromQueue).to receive(:call)
        .once.with(queue: QUEUE, thermostat_id: thermostat.id)
        .and_return(readings_result)

      allow(GetReadingStatistics).to receive(:call)
        .once.with(
          readings_from_queue: readings_result.readings,
          thermostat: thermostat
        ).and_return(statistics_result)
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
          resp = get :show,
                     params: { id: thermostat.household_token },
                     format: :json

          expect(resp).to have_http_status(:ok)
          expect(JSON.parse(resp.body)).to include_json(data: {})
          expect(JSON.parse(resp.body)['data'])
            .to include_json(type: 'statistics', attributes: {})
          expect(JSON.parse(resp.body)['data']['attributes'])
            .to eq(
              'statistics' => final_statistics.as_json,
              'thermostat' => thermostat.attributes.except(
                'created_at', 'updated_at'
              )
            )
        end
      end

      context 'when queue readings empty' do
        let(:readings_result) do
          double(:readings_result, success?: false, readings: [])
        end

        it 'returns success json response ' do
          resp = get :show,
                     params: { id: thermostat.household_token },
                     format: :json

          expect(resp).to have_http_status(:ok)
          expect(JSON.parse(resp.body)).to include_json(data: {})
          expect(JSON.parse(resp.body)['data'])
            .to include_json(type: 'statistics', attributes: {})
          expect(JSON.parse(resp.body)['data']['attributes'])
            .to eq(
              'statistics' => final_statistics.as_json,
              'thermostat' => thermostat.attributes.except(
                'created_at', 'updated_at'
              )
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
            post :show,
                 params: { id: 0 }, format: :json

          expect(resp).to have_http_status(:ok)
          expect(JSON.parse(resp.body)).to include_json(data: {})
          expect(JSON.parse(resp.body)['data']).to include_json(
            type: 'error', attributes: {}
          )
          expect(JSON.parse(resp.body)['data']['attributes']).to eq(
            { code: 404, message: 'Object Not Found' }.as_json
          )
        end
      end
    end
  end
end
