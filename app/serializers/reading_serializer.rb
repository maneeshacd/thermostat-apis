class ReadingSerializer
  include FastJsonapi::ObjectSerializer
  attributes :number, :token, :temperature, :humidity,
             :battery_charge, :thermostat_id
  belongs_to :thermostat
end
