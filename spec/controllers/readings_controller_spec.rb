require 'rails_helper'

RSpec.describe ReadingsController, type: :controller do
  before do
    request.headers.merge!(
      'Api-Key': ENV['API_KEY'], 'Api-Secret': ENV['API_SECRET']
    )
  end

  describe '#create' do
    before do |example|
      unless example.metadata[:skip_before]
        rparams = ActionController::Parameters.new(reading_params).permit!

        expect(StoreThermostatReading).to receive(:call)
          .once.with(params: rparams, thermostat: thermostat)
          .and_return(result)
      end
    end

    context 'when successful' do
      let(:reading) { build(:reading, thermostat: thermostat) }
      let(:result) do
        double(:result, success?: true, reading: reading, number: 1)
      end
      let(:thermostat) { create(:thermostat) }
      let(:reading_params) do
        {
          temperature: reading.temperature.to_s,
          humidity: reading.humidity.to_s,
          battery_charge: reading.battery_charge.to_s
        }
      end

      it 'returns success json response' do
        resp =
          post :create,
               params: reading_params.merge(
                 household_token: thermostat.household_token
               ), format: :json

        expect(resp).to have_http_status(:ok)
        expect(JSON.parse(resp.body)).to include_json(data: {})
        expect(JSON.parse(resp.body)['data'])
          .to include_json(type: 'reading', attributes: {})
        expect(JSON.parse(resp.body)['data']['attributes'])
          .to eq(reading.attributes.except('id', 'created_at', 'updated_at'))
      end
    end

    context 'when unsuccessful' do
      let(:reading) { Reading.create }
      let(:result) do
        double(:result, success?: false, reading: reading)
      end
      let(:thermostat) { create(:thermostat) }

      context 'when household_token is not present', :skip_before do
        let(:reading_params) do
          {
            temperature: reading.temperature.to_s,
            humidity: reading.humidity.to_s,
            battery_charge: reading.battery_charge.to_s
          }
        end

        it 'returns object not found error as json response' do
          resp =
            post :create,
                 params: reading_params.merge, format: :json

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

      context 'when reading params empty' do
        let(:reading_params) { {} }

        it 'returns bad request error as json response' do
          resp =
            post :create,
                 params: reading_params.merge(
                   household_token: thermostat.household_token
                 ), format: :json

          expect(resp).to have_http_status(:ok)
          expect(JSON.parse(resp.body)).to include_json(data: {})
          expect(JSON.parse(resp.body)['data']).to include_json(
            type: 'error', attributes: {}
          )
          expect(JSON.parse(resp.body)['data']['attributes']).to eq(
            { code: 400, message: reading.errors.full_messages }.as_json
          )
        end
      end
    end
  end

  describe '#show' do
    before do
      stub_const('QUEUE', 'testing')
      expect(FetchThermostatReadingFromQueue).to receive(:call)
        .once.with(token: reading.token, queue: QUEUE)
        .and_return(result)
    end

    context 'when successful' do
      let(:thermostat) { create(:thermostat) }
      let(:reading) do
        create(:reading, thermostat: thermostat)
      end
      let(:result) do
        double(:result, success?: true, reading: reading)
      end

      it 'returns success json response' do
        resp =
          get :show,
              params: {
                id: reading.token
              }, format: :json

        expect(resp).to have_http_status(:ok)
        expect(JSON.parse(resp.body)).to include_json(data: {})
        expect(JSON.parse(resp.body)['data'])
          .to include_json(
            id: reading.id.to_s, type: 'reading', attributes: {}
          )
        expect(JSON.parse(resp.body)['data']['attributes'])
          .to eq(reading.attributes.except('id', 'created_at', 'updated_at'))
        expect(JSON.parse(resp.body)['included'][0]['attributes'])
          .to eq(thermostat.attributes.except('id', 'created_at', 'updated_at'))
      end
    end

    context 'when unsuccessful' do
      let(:thermostat) { create(:thermostat) }
      let(:reading) { build(:reading) }
      let(:result) do
        double(:result, success?: false, reading: {})
      end

      context 'when token is not valid' do
        it 'returns object not found error as json response' do
          resp =
            get :show,
                params: {
                  id: reading.token
                }, format: :json

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
