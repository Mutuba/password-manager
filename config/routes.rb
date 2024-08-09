# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  post '/auth/signup', to: 'registration#signup', as: :sign_up
  post '/auth/login', to: 'authentication#login', as: :login
end

# Rails.application.routes.draw do
#   namespace :api do
#     namespace :v1 do
#       post 'signup', to: 'users#create'
#       post 'auth/login', to: 'authentication#authenticate'
#       resources :todos do
#         resources :items
#       end
#     end
#   end
# end
