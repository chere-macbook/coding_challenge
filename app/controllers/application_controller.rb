class ApplicationController < ActionController::API
  attr_accessor :current_thermostat

  private

  def authenticate_thermostat!
    auth_token = request.headers[:token]
    @current_thermostat = Thermostat.find_by_household_token(auth_token)
    render json: { message: 'not a valid thermostat' },
            status: :unauthorized unless @current_thermostat.present?
  end
end
