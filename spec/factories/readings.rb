FactoryBot.define do
  factory :reading do
    association :thermostat, factory: :thermostat
    temperature { 56 }
    humidity { 23.8 }
    battery_charge { 55.45 }
  end
end
