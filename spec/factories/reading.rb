FactoryBot.define do
  factory :reading do
    association :thermostat, factory: :thermostat

    number { 1 }
    temperature { Faker::Number.decimal(2) }
    humidity { Faker::Number.decimal(2) }
    battery_charge { Faker::Number.decimal(2) }
    token { Faker::Lorem.characters(10) }
  end
end
