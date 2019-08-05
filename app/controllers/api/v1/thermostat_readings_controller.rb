class Api::V1::ThermostatReadingsController < ApplicationController

  before_action :authenticate_thermostat!

  def create
    @reading = current_thermostat.readings.build(reading_params)
    if @reading.valid?
      @reading.process_thermostat_readings
      render json: { tracking_number: @reading.tracking_number }, status: :created
    else
      render json: @reading.errors, status: :unprocessable_entity
    end
  end

  def show
    @reading = Reading.thermostat_data(params[:id], current_thermostat.id)
    if @reading.present?
      render json: @reading, status: :ok
    else
      render json: { message: 'Unable to find thermostat data' }, status: :not_found
    end
  end

  def stats
    statatics = current_thermostat.statatics.first.attributes.except('id')
    if statatics.present?
      render json: statatics, status: :ok
    else
      render json: { message: 'Unable to find thermostat data' }, status: :not_found
    end
  end

  private

  def reading_params
    params.require(:reading).permit(:temperature, :humidity, :battery_charge)
  end
end
