# frozen_string_literal: true

# VaultsController is responsible for managing the creation of Vaults.
#
# This controller handles the creation of vaults by accepting parameters
# such as the vault name and user ID. It also requires a master password
# to be provided in order to generate an encrypted master key for the vault.
class VaultsController < ApplicationController
  def create
    @vault = current_user.vaults.new(vault_params)
    @vault.add_encrypted_master_key(params[:master_password])

    if @vault.save
      render json: VaultSerializer.new(@vault).serializable_hash, status: :created
    else
      json_response({ errors: @vault.errors.full_messages }, :unprocessable_entity)
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
