class ReadingWorker
  include Sidekiq::Worker

  def perform(reading_params)
    reading = Reading.new(JSON.parse(reading_params))
    reading.save
  end
end
