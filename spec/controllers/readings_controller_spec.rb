require 'rails_helper'

RSpec.describe ReadingsController, type: :controller do
  describe '#create' do
    before do |example|
      unless example.metadata[:skip_before]
        rparams = ActionController::Parameters.new(reading_params).permit!

        expect(StoreThermostatReading).to receive(:call)
          .once
          .with(params: rparams, thermostat: thermostat)
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
                 household_token: thermostat.household_token,
                 format: :json
               )

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(resp.body)).to include_json(
          status: 'success',
          code: 201,
          data: { reading: reading.as_json },
          message: 'Success'
        )
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
                 params: reading_params.merge(
                   format: :json
                 )

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(resp.body)).to include_json(
            status: 'Bad Request',
            code: 404, data: nil,
            message: 'Object Not Found'
          )
        end
      end

      context 'when reading params empty' do
        let(:reading_params) { {} }

        it 'returns bad request error as json response' do
          resp =
            post :create,
                 params: reading_params.merge(
                   household_token: thermostat.household_token,
                   format: :json
                 )

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(resp.body)).to include_json(
            status: 'Bad Request',
            code: 400,
            data: nil,
            message: reading.errors.full_messages
          )
        end
      end
    end
  end
end
