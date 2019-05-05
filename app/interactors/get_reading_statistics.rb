class GetReadingStatistics
  include Interactor

  def call
    statistics = {}
    @total_readings = total_readings
    %i[temperature humidity battery_charge].each do |col|
      statistics[col] = statistics_of(col)
    end
    if @total_readings.present?
      context.values = statistics
    else
      context.fail!(values: {})
    end
  end

  def statistics_of(field)
    field_values = @total_readings.map { |e| e[field.to_s] }.map(&:to_f)

    { min: field_values.min,
      avg: (field_values.sum / (field_values.size.to_f.nonzero? || 1)).round(2),
      max: field_values.max }
  end

  def total_readings
    context.thermostat.readings.as_json + context.readings_from_queue
  end
end
