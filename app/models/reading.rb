class Reading < ApplicationRecord
  belongs_to :thermostat

  before_validation :set_tracking_number

  validates :temperature, :humidity, :battery_charge, presence: true
  validates :temperature, :humidity, :battery_charge,
            numericality: true, allow_nil: true

  def process_thermostat_readings
    ReadingWorker.perform_async(self.to_json)
  end

  def self.thermostat_data(tracking_number)
    # If we are assuming small amount of queue we can use below logic else we need to
    # change the logic of searching queue to some caching technique or redis implementation
    job_queue = Sidekiq::Queue.new
    data = job_queue.select { |queue| queue.klass == 'ReadingWorker' }
    .collect(&:args).flatten.map { |reading| JSON.parse(reading) }
    .find { |parsed_data| parsed_data['tracking_number'] == tracking_number.to_i }
    data = Reading.where(tracking_number: tracking_number).first unless data.present?
    data
  end

  private

  def set_tracking_number
    self.tracking_number = SecureRandom.uuid[0..5].gsub('-', '').hex unless tracking_number.present?
  end
end
