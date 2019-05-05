class Thermostat < ApplicationRecord
  has_many :readings, dependent: :destroy

  validates :household_token, presence: true, uniqueness: true
  validates :address, presence: true

  def next_sequence_number
    [
      readings.maximum(:number).to_i,
      FetchReadingsOfASingleThermostatFromQueue.call(queue: QUEUE, thermostat_id: id)
                         .readings.pluck('number').max.to_i
    ].max + 1
  end

  def as_json(*)
    super.except('created_at', 'updated_at')
  end

  def reading_statistics(sidekiq_readings)
    statistics = {}
    %i[temperature humidity battery_charge].each do |col|
      col_values = (readings.as_json + sidekiq_readings)
                   .uniq { |e| e['id'] }.map { |e| e[col.to_s] }.map(&:to_f)

      statistics[col] = {
        min: col_values.min,
        avg: (col_values.sum / (col_values.size.to_f.nonzero? || 1)).round(2),
        max: col_values.max
      }
    end
    statistics
  end
end
