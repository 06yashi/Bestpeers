Rails.application.routes.draw do
  devise_for :users, 
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'home/index'
 
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"  # Change "home#index" to your actual home controller action

   


  # # Devise routes for User model
  # devise_for :users, 
  #            controllers: {
  #              sessions: 'users/sessions',
  #              registrations: 'users/registrations'
  #            }

  # Profile resource routes
  # resources :profiles do
  #   member do
  #     get 'details'  # Example of a custom member route
  #   end
  # end
  # resources :bookings, only: [:new, :create, :index]

  resources :users do
    member do
      delete :destroy
    end
  end
  

end
