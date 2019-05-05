class StoreThermostatReading
  include Interactor

  def call
    @token = Reading.set_token

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

    context.params.merge(
      number: number, thermostat_id: thermostat.id, token: @token
    )
  end
end
