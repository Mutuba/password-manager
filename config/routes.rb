# frozen_string_literal: true

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # root "posts#index"
  post "/auth/sign_up", to: "registration#sign_up", as: :sign_up
  post "/auth/login", to: "authentication#login", as: :login

  resources :vaults

  post "vaults/:id/login", to: "vaults#login", as: :vault_login
  post "vaults/:id/logout", to: "vaults#logout", as: :vault_logout
end
