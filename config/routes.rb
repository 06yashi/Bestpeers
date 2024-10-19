Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'home/index'

  get 'up' => 'rails/health#show', as: :rails_health_check
  # root 'home#index'

   root 'cars#index'
   get 'search_cars', to: 'cars#search', as: 'search_cars'

 resources :cars, only: [:index]
   resources :bookings
   resources :cars
  
  # resources :bookings
  # resources :checkouts, only: [:new, :create]
  # resources :bookings
  # Checkout routes
  get 'checkout/success', to: 'checkout#success', as: 'checkout_success'
  get 'checkout/cancel', to: 'checkout#cancel', as: 'checkout_cancel'


end