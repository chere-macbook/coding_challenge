require 'rails_helper'

RSpec.describe Thermostat, type: :model do
  let(:thermostat) { FactoryBot.create(:thermostat) }

  it 'for getting stats' do
    FactoryBot.create(:reading, temperature: 23, humidity: 54,
      battery_charge: 46, thermostat_id: thermostat.id)
    FactoryBot.create(:reading, temperature: 34, humidity: 76,
      battery_charge: 76, thermostat_id: thermostat.id)
    FactoryBot.create(:reading, temperature: 14, humidity: 23,
      battery_charge: 11, thermostat_id: thermostat.id)
    FactoryBot.create(:reading, temperature: 78, humidity: 98,
      battery_charge: 19, thermostat_id: thermostat.id)


    expect(thermostat.statatics.to_json).to eql("[{\"id\":null,\"avg_temperature\":37.25,\"max_temperature\":78.0,\"min_temperature\":14.0,\"avg_humidity\":62.75,\"max_humidity\":98.0,\"min_humidity\":23.0,\"avg_battery_charge\":38.0,\"max_battery_charge\":76.0,\"min_battery_charge\":11.0}]")
  end
end
