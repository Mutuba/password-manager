# frozen_string_literal: true

# VaultsController is responsible for managing the creation of Vaults.
#
# This controller handles the creation of vaults by accepting parameters
# such as the vault name and user ID. It also requires a unlock_code
# to be provided in order to generate an encrypted unlock_code for the vault.
#
class VaultsController < ApplicationController
  before_action :set_vault, except: [:create, :index]

  def index
    @vaults = current_user.vaults
    render(json: VaultSerializer.new(@vaults).serializable_hash)
  end

  def show
    raise AuthenticationError,
      "Vault session expired" unless REDIS.exists?("vault:#{@vault.id}:user:#{current_user.id}")

    render(json: VaultSerializer.new(@vault, include: [:password_records]).serializable_hash, status: :ok)
  end

  def create
    vault = current_user.vaults.new(vault_params)

    if vault.save
      render(json: VaultSerializer.new(vault).serializable_hash, status: :created)
    else
      json_response({ errors: vault.errors.full_messages }, :unprocessable_entity)
    end
  end

  def update
    if @vault.update(vault_params)
      render(json: VaultSerializer.new(@vault).serializable_hash, status: :ok)
    else
      json_response({ errors: @vault.errors.full_messages }, :unprocessable_entity)
    end
  end

  def destroy
    @vault.destroy
    head(:no_content)
  end

  def login
    if @vault&.authenticate_vault(vault_params[:unlock_code])
      session_key = "vault:#{@vault.id}:user:#{current_user.id}"
      hashed_value = Digest::SHA256.hexdigest("authenticated#{current_user.id}")

      REDIS.setex(session_key, 10.minutes, hashed_value)
      render(json: { message: "Login successful" }, status: :ok)
    else
      render(json: { error: "Invalid password" }, status: :unauthorized)
    end
  end

  def logout
    session_key = "vault:#{@vault.id}:user:#{current_user.id}"

    if REDIS.exists?(session_key)
      REDIS.del(session_key)
      render(json: { message: "Logout successful" }, status: :ok)
    else
      render(json: { error: "No active session found" }, status: :unprocessable_entity)
    end
  end

  private

  def vault_params
    params.require(:vault).permit(:name, :unlock_code)
  end

  def set_vault
    @vault = current_user.vaults.find_by!(id: params[:id])
  end
end
