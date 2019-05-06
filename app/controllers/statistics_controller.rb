class StatisticsController < ApplicationController
  def show
    @thermostat = Thermostat.find_by!(household_token: params[:id])
    @statistics =
      Statistics.new(statistics: statistics.statistics, thermostat: @thermostat)
    render json: StatisticsSerializer.new(@statistics)
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
