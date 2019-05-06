class Thermostat < ApplicationRecord
  has_many :readings, dependent: :destroy

  validates :household_token, presence: true, uniqueness: true
  validates :address, presence: true

  def next_sequence_number
    [
      readings.maximum(:number).to_i,
      FetchReadingsOfASingleThermostatFromQueue.call(
        queue: QUEUE, thermostat_id: id
      ).readings.pluck('number').max.to_i
    ].max + 1
  end
end
