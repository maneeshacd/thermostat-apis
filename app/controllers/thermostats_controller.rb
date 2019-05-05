class ThermostatsController < ApplicationController
  def show
    @thermostat = Thermostat.find_by!(household_token: params[:id])
    result = FetchThermostatReadingFromQueue.call(
      token: params[:reading_id], queue: QUEUE
    )
    reading = if result.success?
                result.reading
              else
                Reading.find_by!(token: params[:reading_id])
              end
    success_response(code: 200, data: { thermostat: @thermostat })
  end

  def statistics
    @thermostat = Thermostat.find_by!(household_token: params[:household_token])
    success_response(
      data: { statistics: get_statistics.values, thermostat: @thermostat }
    )
  end

  def get_statistics
    GetReadingStatistics.call(
      readings_from_queue: readings_from_queue.readings,
      thermostat: @thermostat
    )
  end

  def readings_from_queue
    FetchReadingsOfASingleThermostatFromQueue.call(
      queue: QUEUE, thermostat_id: @thermostat.id
    )
  end
end
