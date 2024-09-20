# frozen_string_literal: true

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "/auth/sign_up", to: "registration#sign_up", as: :sign_up
  post "/auth/login", to: "authentication#login", as: :login
  get "/auth/session", to: "authentication#session", as: :session

  resources :vaults do
    resources :password_records, only: [:create, :update]
  end

  resources :password_records, only: [:destroy]

  post "vaults/:id/login", to: "vaults#login", as: :vault_login
  post "vaults/:id/logout", to: "vaults#logout", as: :vault_logout
  post "password_records/:id/decrypt_password", to: "password_records#decrypt_password", as: :decrypt_password
end
