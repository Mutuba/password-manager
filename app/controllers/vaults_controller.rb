# frozen_string_literal: true

# VaultsController is responsible for managing the creation of Vaults.
#
# This controller handles the creation of vaults by accepting parameters
# such as the vault name and user ID. It also requires a master password
# to be provided in order to generate an encrypted master key for the vault.
#
# Methods:
#   - create: Creates a new vault with the provided parameters and master password
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

  def login
    @vault = Vault.find_by(id: params[:id], user_id: params[:user_id])

    if @vault&.authenticate_master_password(params[:master_password])
      render json: { message: 'Login successful' }, status: :ok
    else
      render json: { error: 'Invalid master password' }, status: :unauthorized
    end
  end

  private

  def vault_params
    params.require(:vault).permit(:name, :user_id)
  end
end
