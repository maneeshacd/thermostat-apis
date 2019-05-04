require 'rails_helper'

RSpec.describe 'routes for thermostat app', type: :routing do
  describe 'Reading' do
    it 'routes to /readings' do
      expect(post: '/readings')
        .to route_to(controller: 'readings', action: 'create')
    end

    it 'routes to /{reading_id}/thermostat_details' do
      expect(get: '/1/thermostat_details')
        .to route_to(
          controller: 'readings', action: 'thermostat_details', reading_id: '1'
        )
    end
  end

  describe 'Thermostat' do
    it 'routes to /thermostat_statistics' do
      expect(post: '/thermostat_statistics')
        .to route_to(controller: 'thermostats', action: 'statistics')
    end
  end
end
