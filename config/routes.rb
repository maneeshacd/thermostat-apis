Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  resources :readings, only: %i[create show]
  resources :statistics, only: :show
end
