Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  resources :readings, only: %i[create]
  get '/:reading_id/thermostat_details', to: 'readings#thermostat_details',
                                         as: :thermostat_details
  post '/thermostat_statistics', to: 'thermostats#statistics'
end
