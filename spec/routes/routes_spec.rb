require 'rails_helper'

RSpec.describe 'routes for thermostat app', type: :routing do
  describe 'Reading' do
    it 'routes to /readings' do
      expect(post: '/readings')
        .to route_to(controller: 'readings', action: 'create')
    end

    it 'routes to /readings/{id}' do
      expect(
        get: '/readings/4ef1b6ecf0ee1ecafcad'
      ).to route_to(
        controller: 'readings', action: 'show', id: '4ef1b6ecf0ee1ecafcad'
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
