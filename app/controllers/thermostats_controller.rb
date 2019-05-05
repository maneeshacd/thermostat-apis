class ThermostatsController < ApplicationController
  def statistics
    @thermostat = Thermostat.find_by!(household_token: params[:household_token])
    result =
      ReadingsFromSidekiq.call(queue: QUEUE, thermostat_id: @thermostat.id)
    success_response(
      data: {
        statistics: @thermostat.reading_statistics(result.readings),
        thermostat: @thermostat
      }
    )
  end
end
