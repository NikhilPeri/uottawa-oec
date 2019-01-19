Rails.application.routes.draw do
  devise_for :users
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root to: 'static_pages#stats'
  resources :patients
  get 'patiens/:id/complete', to: 'patients#complete'

  get  '/help',    to: 'static_pages#help'

  post 'webhooks/twilio' => 'webhooks#twilio'
end
