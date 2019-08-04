class Thermostat < ApplicationRecord

  has_many :readings


  def statatics
    readings.select(
      'AVG(temperature) AS avg_temperature',
      'MAX(temperature) AS max_temperature',
      'MIN(temperature) AS min_temperature',
      'AVG(humidity) AS avg_humidity',
      'MAX(humidity) AS max_humidity',
      'MIN(humidity) AS min_humidity',
      'AVG(battery_charge) AS avg_battery_charge',
      'MAX(battery_charge) AS max_battery_charge',
      'MIN(battery_charge) AS min_battery_charge'
      )
  end
end
