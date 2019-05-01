class Thermostat < ApplicationRecord
  has_many :readings, dependent: :destroy

  validates :household_token, presence: true, uniqueness: true
  validates :address, presence: true

  def next_sequence_number
    readings.maximum(:number).to_i + 1
  end

  def as_json(*)
    super.except('created_at', 'updated_at')
  end
end
