require 'rails_helper'

RSpec.describe Reading, type: :model do
  describe 'Associations' do
    it { should belong_to(:thermostat) }
  end

  describe 'Validations' do
    subject { create(:reading) }

    it { should validate_presence_of(:number) }
    it { should validate_uniqueness_of(:number).scoped_to(:thermostat_id) }

    it { should validate_presence_of(:temperature) }
    it { should validate_numericality_of(:temperature) }

    it { should validate_presence_of(:humidity) }
    it { should validate_numericality_of(:humidity) }

    it { should validate_presence_of(:battery_charge) }
    it { should validate_numericality_of(:battery_charge) }
  end
end
