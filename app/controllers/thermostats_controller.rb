class ThermostatsController < ApplicationController
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
