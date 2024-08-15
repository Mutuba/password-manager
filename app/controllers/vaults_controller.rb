# frozen_string_literal: true

# VaultsController is responsible for managing the creation of Vaults.
#
# This controller handles the creation of vaults by accepting parameters
# such as the vault name and user ID. It also requires a master password
# to be provided in order to generate an encrypted master key for the vault.
#
# Methods:
#   - create: Creates a new vault with the provided parameters and master password.
#
# Usage:
#   - Send a POST request to create a new vault. The request must include
#     a vault name, user ID, and master password.
#
# Example:
#   POST /vaults
#   {
#     "vault": {
#       "name": "Personal Vault",
#       "user_id": 1
#     },
#     "master_password": "your_master_password"
#   }
#
#   Response (Success):
#   Status: 201 Created
#   {
#     "id": 1,
#     "name": "Personal Vault",
#     "user_id": 1,
#     "created_at": "2024-08-14T12:00:00Z",
#     "updated_at": "2024-08-14T12:00:00Z"
#   }
#
#   Response (Failure):
#   Status: 422 Unprocessable Entity
#   {
#     "errors": ["Name can't be blank", "Encrypted master key can't be blank"]
#   }
#
class VaultsController < ApplicationController
  def create
    @vault = Vault.new(vault_params)
    @vault.add_encrypted_master_key(params[:master_password])

    if @vault.save
      render json: @vault, status: :created
    else
      render json: { errors: @vault.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def vault_params
    params.require(:vault).permit(:name, :user_id)
  end
end
