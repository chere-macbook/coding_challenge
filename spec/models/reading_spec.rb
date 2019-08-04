require 'rails_helper'

RSpec.describe Reading, type: :model do
  it 'shold be valid? ' do
    reading = FactoryBot.build(:reading)
    expect(reading).to be_valid
  end

  it 'shold not be valid? ' do
    reading = FactoryBot.build(:reading, temperature: 'Text')
    expect(reading).not_to be_valid
  end

  context 'should get thermostat data' do

    it 'should get blank data' do
      expect(Reading.thermostat_data('FASVDJKHv').to_json).to eql('null')
    end

    it 'shoild get data' do
      thermostat = FactoryBot.create(:thermostat)
      readings = FactoryBot.create(:reading, thermostat_id: thermostat.id)
      expect(Reading.thermostat_data(readings.tracking_number).to_json).to eql(readings.to_json)
    end
  end
end
