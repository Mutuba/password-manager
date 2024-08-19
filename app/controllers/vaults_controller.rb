# frozen_string_literal: true

# VaultsController is responsible for managing the creation of Vaults.
#
# This controller handles the creation of vaults by accepting parameters
# such as the vault name and user ID. It also requires a master password
# to be provided in order to generate an encrypted master key for the vault.
#
class VaultsController < ApplicationController
  before_action :set_vault, except: %i[create index]

  def index
    @vaults = current_user.vaults
    render json: VaultsController.new(@vaults).serializable_hash, status: :ok
  end

  def show
    raise AuthenticationError, 'Vault session expired' unless REDIS.exists?(key).positive?

    render json: VaultsController.new(@vault).serializable_hash, status: :ok
  end

  def create
    vault = current_user.vaults.new(vault_params.except(:master_password))
    vault.add_encrypted_master_key(vault_params[:master_password])

    if vault.save
      render json: VaultSerializer.new(vault).serializable_hash, status: :created
    else
      json_response({ errors: vault.errors.full_messages }, :unprocessable_entity)
    end
  end

  def update
    raise AuthenticationError, 'Vault session expired' unless REDIS.exists?(key).positive?

    if @vault.update(vault_params.except(:master_password))
      render json: VaultSerializer.new(@vault).serializable_hash, status: :ok
    else
      json_response({ errors: vault.errors.full_messages }, :unprocessable_entity)
    end
  end

  def destroy
    raise AuthenticationError, 'Vault session expired' unless REDIS.exists?(key).positive?

    @vault.destroy
    head :no_content
  end

  def login
    if @vault&.authenticate_master_password(vault_params[:master_password])
      session_key = "vault:#{@vault.id}:user:#{current_user.id}"
      hashed_value = Digest::SHA256.hexdigest("authenticated#{current_user.id}")

      REDIS.setex(session_key, 10.minutes, hashed_value)
      render json: { message: 'Login successful' }, status: :ok
    else
      render json: { error: 'Invalid password' }, status: :unauthorized
    end
  end

  def logout
    session_key = "vault:#{@vault.id}:user:#{current_user.id}"

    if REDIS.exists?(session_key).positive?
      REDIS.del(session_key)
      render json: { message: 'Logout successful' }, status: :ok
    else
      render json: { error: 'No active session found' }, status: :unprocessable_entity
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
