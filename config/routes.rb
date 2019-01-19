Rails.application.routes.draw do
  devise_for :users
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root to: 'patients#index'
  resources :patients do
   get 'complete'
  end

  get  '/help',    to: 'static_pages#help'
  get  '/stats',    to: 'static_pages#stats'

  post 'webhooks/twilio' => 'webhooks#twilio'
end
