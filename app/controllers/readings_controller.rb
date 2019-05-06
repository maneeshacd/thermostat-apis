class ReadingsController < ApplicationController
  before_action :set_thermostat, only: :create

  def create
    result = StoreThermostatReading.call(
      params: reading_params, thermostat: @thermostat
    )

    if result.success?
      render json: ReadingSerializer.new(result.reading)
    else
      raise_bad_request(result.reading)
    end
  end

  def show
    result = FetchThermostatReadingFromQueue.call(
      token: params[:id], queue: QUEUE
    )
    reading = if result.success?
                result.reading
              else
                Reading.find_by!(token: params[:id])
              end
    render json: ReadingSerializer.new(
      Reading.new(reading.as_json), include: [:thermostat]
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
