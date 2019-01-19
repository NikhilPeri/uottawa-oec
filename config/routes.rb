Rails.application.routes.draw do
  devise_for :users
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  resources :patients do
   get 'complete'
  end

  root to: 'patients#index'

  get  '/help',    to: 'static_pages#help'
  get  '/stats',    to: 'static_pages#stats'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
