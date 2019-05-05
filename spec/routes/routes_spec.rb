require 'rails_helper'

RSpec.describe 'routes for thermostat app', type: :routing do
  describe 'Reading' do
    it 'routes to /readings' do
      expect(post: '/readings')
        .to route_to(controller: 'readings', action: 'create')
    end
  end

  describe 'Thermostat' do
    it 'routes to /readings/{reading_id}/thermostat/{id}' do
      expect(
        get: '/readings/4ef1b6ecf0ee1ecafcad/thermostats/pypNs7Zxf1onDDDzVmQf'
      ).to route_to(
        controller: 'thermostats', action: 'show',
        reading_id: '4ef1b6ecf0ee1ecafcad', id: 'pypNs7Zxf1onDDDzVmQf'
      )
    end
  end

  describe 'Statistics' do
    it 'routes to /statistics/{id}' do
      expect(get: '/statistics/pypNs7Zxf1onDDDzVmQf')
        .to route_to(
          controller: 'statistics', action: 'show', id: 'pypNs7Zxf1onDDDzVmQf'
        )
    end
  end
end
