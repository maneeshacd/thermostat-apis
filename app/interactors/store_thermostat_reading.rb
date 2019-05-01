class StoreThermostatReading
  include Interactor

  def call
    reading = Reading.new(build_params)
    if reading.valid?
      StoreReadingWorker.perform_async(build_params.to_h)
      context.reading = reading
    else
      context.fail!(reading: reading)
    end
  end

  private

  def build_params
    thermostat = context.thermostat
    number = thermostat.next_sequence_number
    id = Reading.next_id

    context.params.merge(
      id: id, number: number, thermostat_id: thermostat.id
    )
  end
end
