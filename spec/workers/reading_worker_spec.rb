require 'rails_helper'
RSpec.describe ReadingWorker, type: :worker do
  it "enqueues a reading worker" do
    reading = {
        id: nil,
        thermostat_id: 1,
        tracking_number: 14561458,
        temperature: 23,
        humidity: 45.3,
        battery_charge: 50,
        created_at: nil,
        updated_at: nil
    }

    expect { ReadingWorker.perform_async(reading) }
    .to change(ReadingWorker.jobs, :size).by(1)
  end
end
