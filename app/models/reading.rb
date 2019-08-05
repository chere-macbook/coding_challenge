class Reading < ApplicationRecord
  belongs_to :thermostat

  before_validation :set_tracking_number

  validates :temperature, :humidity, :battery_charge, presence: true
  validates :temperature, :humidity, :battery_charge,
            numericality: true, allow_nil: true

  scope :tracking_number_details, -> (tracking_number) { where(tracking_number: tracking_number) }

  def process_thermostat_readings
    ReadingWorker.perform_async(self.to_json)
  end

  class << self
    def thermostat_data(tracking_number)
      data = search_in_sidekiq(tracking_number)
      data = tracking_number_details(tracking_number).first unless data.present?
      data
    end

    def search_in_sidekiq(tracking_number)
      job_queue = Sidekiq::Queue.new
      job_queue.select { |queue| queue.klass == 'ReadingWorker' }
      .collect(&:args).flatten.map { |reading| reading.class == String ? JSON.parse(reading) : reading }
      .find { |parsed_data| parsed_data['tracking_number'] == tracking_number.to_i }
    end
  end

  private

  def set_tracking_number
    self.tracking_number = SecureRandom.uuid[0..5].gsub('-', '').hex unless tracking_number.present?
  end
end
