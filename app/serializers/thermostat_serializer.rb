class ThermostatSerializer
  include FastJsonapi::ObjectSerializer
  attributes :household_token, :address
end
