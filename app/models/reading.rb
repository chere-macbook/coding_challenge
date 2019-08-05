class Reading < ApplicationRecord
  belongs_to :thermostat

  before_validation :set_tracking_number

  validates :temperature, :humidity, :battery_charge, presence: true
  validates :temperature, :humidity, :battery_charge,
            numericality: true, allow_nil: true

  scope :tracking_number_details, -> (tracking_number,thermostat_id) {
    where(tracking_number: tracking_number, thermostat_id: thermostat_id) }

  def process_thermostat_readings
    ReadingWorker.perform_async(self.to_json)
  end

  class << self
    def thermostat_data(tracking_number, thermostat_id)
      data = search_in_sidekiq(tracking_number, thermostat_id)
      data = tracking_number_details(tracking_number, thermostat_id).first unless data.present?
      data
    end

    def search_in_sidekiq(tracking_number, thermostat_id)
      job_queue = Sidekiq::Queue.new
      job_queue.select { |queue| queue.klass == 'ReadingWorker' }
      .collect(&:args).flatten.map { |reading| reading.class == String ? JSON.parse(reading) : reading }
      .find { |parsed_data| parsed_data['tracking_number'] == tracking_number.to_i &&
        parsed_data['thermostat_id'] == thermostat_id.to_i }
    end
  end

  private

  def set_tracking_number
    self.tracking_number = SecureRandom.uuid[0..5].gsub('-', '').hex unless tracking_number.present?
  end
end
