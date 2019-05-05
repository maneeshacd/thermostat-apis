class FetchReadingsOfASingleThermostatFromQueue
  include Interactor

  def call
    queued_items =
      Sidekiq::Queue.new(context.queue).map(&:item).pluck('args').flatten
    readings = queued_items
               .find_all { |r| r['thermostat_id'] == context.thermostat_id }

    if readings.present?
      context.readings = readings
    else
      context.fail!(readings: [])
    end
  end
end
