class ReadingsController < ApplicationController
  before_action :set_thermostat, only: :create

  def create
    result = StoreThermostatReading.call(
      params: reading_params, thermostat: @thermostat
    )

    if result.success?
      success_response(
        code: 201, data: { reading: result.reading }
      )
    else
      raise_bad_request(result.reading)
    end
  end

  def thermostat_details
    result = ReadingFromSidekiq.call(
      reading_id: params[:reading_id], queue: QUEUE
    )
    reading =
      result.success? ? result.reading : Reading.find(params[:reading_id])

    thermostat = Thermostat.find(reading['thermostat_id'])
    success_response(
      code: 200, data: { thermostat: thermostat }
    )
  end

  private

  def set_thermostat
    @thermostat = Thermostat.find_by!(household_token: params[:household_token])
  end

  def reading_params
    params.permit(:temperature, :humidity, :battery_charge)
  end
end
