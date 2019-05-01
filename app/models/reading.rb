class Reading < ApplicationRecord
  belongs_to :thermostat

  validates :number, presence: true, uniqueness: { scope: :thermostat_id }
  validates :temperature, presence: true, numericality: true
  validates :humidity, presence: true, numericality: true
  validates :battery_charge, presence: true, numericality: true

  def self.next_id
    maximum(:id).to_i + 1
  end

  def as_json(*)
    super.except('created_at', 'updated_at')
  end
end
