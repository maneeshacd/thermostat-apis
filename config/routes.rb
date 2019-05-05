Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  resources :readings, only: %i[create] do
    resources :thermostats, only: :show
  end
  resources :statistics, only: :show
end
