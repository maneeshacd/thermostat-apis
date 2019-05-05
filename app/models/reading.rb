class Reading < ApplicationRecord
  belongs_to :thermostat

  validates :number, presence: true, uniqueness: { scope: :thermostat_id }
  validates :temperature, presence: true, numericality: true
  validates :humidity, presence: true, numericality: true
  validates :battery_charge, presence: true, numericality: true
  validates :token, presence: true, uniqueness: true

  def self.set_token
    loop do
      token = SecureRandom.hex(10)
      break token unless Reading.where(token: token).exists?
    end
  end

  def as_json(*)
    super.except('created_at', 'updated_at')
  end
end
