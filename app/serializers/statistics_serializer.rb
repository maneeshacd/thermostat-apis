class StatisticsSerializer
  include FastJsonapi::ObjectSerializer
  attributes :statistics, :thermostat

  attribute :thermostat do |object|
    {
      id: object.thermostat.id,
      household_token: object.thermostat.household_token,
      address: object.thermostat.address
    }
  end
end
