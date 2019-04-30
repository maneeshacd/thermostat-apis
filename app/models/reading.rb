class Reading < ApplicationRecord
  belongs_to :thermostat

  validates :number, presence: true, uniqueness: { scope: :thermostat_id }
  validates :temperature, presence: true, numericality: true
  validates :humidity, presence: true, numericality: true
  validates :battery_charge, presence: true, numericality: true
end
