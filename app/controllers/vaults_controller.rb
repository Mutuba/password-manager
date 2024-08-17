# frozen_string_literal: true

# VaultsController is responsible for managing the creation of Vaults.
#
# This controller handles the creation of vaults by accepting parameters
# such as the vault name and user ID. It also requires a master password
# to be provided in order to generate an encrypted master key for the vault.
class VaultsController < ApplicationController
  before_action :set_vault, only: %i[login]
  def create
    vault = current_user.vaults.new(vault_params.except(:master_password))
    vault.add_encrypted_master_key(vault_params[:master_password])

    if vault.save
      render json: VaultSerializer.new(vault).serializable_hash, status: :created
    else
      json_response({ errors: vault.errors.full_messages }, :unprocessable_entity)
    end
  end

  def login
    if @vault&.authenticate_master_password(params[:master_password])
      render json: { message: 'Login successful' }, status: :ok
    else
      render json: { error: 'Invalid password' }, status: :unauthorized
    end
  end

  private

  def vault_params
    params.require(:vault).permit(:name, :master_password)
  end

  def set_vault
    @vault = current_user.vaults.find_by!(id: params[:id])
  end
end
