Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      resources :thermostat_readings, only: [:create, :show] do
        get :stats, on: :collection
      end
    end
  end
end
