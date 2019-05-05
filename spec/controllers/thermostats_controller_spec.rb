require 'rails_helper'

RSpec.describe ThermostatsController, type: :controller do
  before do
    request.headers.merge!(
      'Api-Key': ENV['API_KEY'], 'Api-Secret': ENV['API_SECRET']
    )
  end

  describe '#show' do
    before do
      stub_const('QUEUE', 'testing')
      expect(FetchThermostatReadingFromQueue).to receive(:call)
        .once.with(token: reading_params['token'].to_s, queue: QUEUE)
        .and_return(result)
    end

    context 'when successful' do
      let(:thermostat) { create(:thermostat) }
      let(:reading_params) do
        attributes_for(:reading, thermostat_id: thermostat.id).as_json
      end
      let(:result) do
        double(:result, success?: true, reading: reading_params)
      end

      it 'returns success json response' do
        resp =
          get :show,
              params: {
                reading_id: reading_params['token'],
                id: thermostat.household_token
              }, format: :json

        expect(resp).to have_http_status(:ok)
        expect(JSON.parse(resp.body)).to include_json(
          status: 'success',
          code: 200,
          data: { thermostat: thermostat.as_json },
          message: 'Success'
        )
      end
    end

    context 'when unsuccessful' do
      let(:thermostat) { create(:thermostat) }
      let(:reading_params) { attributes_for(:reading).as_json }
      let(:result) do
        double(:result, success?: false, reading: {})
      end

      context 'when token is not valid' do
        it 'returns object not found error as json response' do
          resp =
            get :show,
                params: {
                  reading_id: reading_params['token'],
                  id: thermostat.household_token
                }, format: :json

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
