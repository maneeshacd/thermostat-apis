require 'rails_helper'

RSpec.describe Thermostat, type: :model do
  describe 'Associations' do
    it { should have_many(:readings).dependent(:destroy) }
  end

  describe 'Validations' do
    subject { create(:thermostat) }

    it { should validate_presence_of(:address) }

    it { should validate_presence_of(:household_token) }
    it { should validate_uniqueness_of(:household_token) }
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { expect(Thermostat.new).to respond_to(:next_sequence_number) }
    end

    context 'executes methods correctly' do
      context 'next_sequence_number' do
        let!(:thermostat) { create(:thermostat) }
        let!(:reading) { create(:reading, thermostat: thermostat) }

        it 'gives next sequence number for a thermostat' do
          expect(thermostat.next_sequence_number).to eq(2)
        end
      end
    end
  end
end
