FactoryBot.define do
  factory :thermostat do
    location { 'Pune' }
    household_token { SecureRandom.urlsafe_base64(nil, false) }
  end
end
