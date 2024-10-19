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

  # config/routes.rb
resources :bookings do
  resources :payments, only: [:create, :destroy]
end


   root 'cars#index'
   get 'search_cars', to: 'cars#search', as: 'search_cars'

   resources :bookings do
    member do
      post 'refund'  # Add refund route for booking
    end
  end

 resources :cars, only: [:index]
   resources :bookings
   resources :cars
   get 'checkout/success', to: 'checkout#success', as: 'checkout_success'
   get 'checkout/cancel', to: 'checkout#cancel', as: 'checkout_cancel'
   post 'checkout/refund', to: 'checkout#refund', as: 'checkout_refund'

end