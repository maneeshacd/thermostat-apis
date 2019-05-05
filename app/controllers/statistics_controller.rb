class StatisticsController < ApplicationController
  def show
    @thermostat = Thermostat.find_by!(household_token: params[:id])
    success_response(
      data: { statistics: statistics.values, thermostat: @thermostat }
    )
  end

  private

  def statistics
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
