require 'rails_helper'

RSpec.describe Api::V1::ThermostatReadingsController, type: :controller do

  let(:thermostat) { FactoryBot.create(:thermostat) }

  context 'gets unauthorized message' do
    headers = { 'CONTENT_TYPE' => 'application/json', 'TOKEN' => 'ASDSFRSEF' }

    it 'for post reading details' do
      request.headers.merge!(headers)
      post :create, params: { reading: { temperature: 23, humidity: 45.3, battery_charge: 50 } }
      expect(response.body).to eql("{\"message\":\"not a valid thermostat\"}")
      expect(response.status).to eql(401)
    end

    it 'for get reading details' do
      request.headers.merge!(headers)
      get :show, params: { id: '45274536' }
      expect(response.body).to eql("{\"message\":\"not a valid thermostat\"}")
      expect(response.status).to eql(401)
    end

    it 'for get stats' do
      request.headers.merge!(headers)
      get :stats
      expect(response.body).to eql("{\"message\":\"not a valid thermostat\"}")
      expect(response.status).to eql(401)
    end
  end

  context 'valid and invalid tracking number' do
    it 'gets the data for themostat readings' do
      headers = { 'CONTENT_TYPE' => 'application/json', 'TOKEN' => "#{thermostat.household_token}" }
      reading = FactoryBot.create(:reading, tracking_number: 45274536)
      request.headers.merge!(headers)
      get :show, params: { id: '45274536' }
      expect(response.body).to eql(reading.to_json)
      expect(response.status).to eql(200)
    end

    it 'gets message for blank themostat readings' do
      headers = { 'CONTENT_TYPE' => 'application/json', 'TOKEN' => "#{thermostat.household_token}" }
      FactoryBot.create(:reading)
      request.headers.merge!(headers)
      get :show, params: { id: 'AASDSSDA' }
      expect(response.body).to eql("{\"message\":\"Unable to find thermostat data\"}")
      expect(response.status).to eql(404)
    end
  end

  it 'for getting stats' do
    FactoryBot.create(:reading, temperature: 23, humidity: 54, battery_charge: 46, thermostat_id: thermostat.id)
    FactoryBot.create(:reading, temperature: 34, humidity: 76, battery_charge: 76, thermostat_id: thermostat.id)
    FactoryBot.create(:reading, temperature: 14, humidity: 23, battery_charge: 11, thermostat_id: thermostat.id)
    FactoryBot.create(:reading, temperature: 78, humidity: 98, battery_charge: 19, thermostat_id: thermostat.id)
    headers = { 'CONTENT_TYPE' => 'application/json', 'TOKEN' => "#{thermostat.household_token}" }
    reading = FactoryBot.create(:reading, tracking_number: 45274536)
    request.headers.merge!(headers)
    get :stats
    expect(response.body).to eql("[{\"id\":null,\"avg_temperature\":37.25,\"max_temperature\":78.0,\"min_temperature\":14.0,\"avg_humidity\":62.75,\"max_humidity\":98.0,\"min_humidity\":23.0,\"avg_battery_charge\":38.0,\"max_battery_charge\":76.0,\"min_battery_charge\":11.0}]")
    expect(response.status).to eql(200)
  end

end
