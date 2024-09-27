# frozen_string_literal: true

class VaultsController < ApplicationController
  before_action :set_vault, except: [:create, :index]

  def index
    @vaults = current_user.vaults
    render(json: VaultSerializer.new(@vaults).serializable_hash)
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

      # session_timeout = ENV.fetch("SESSION_TIMEOUT", 10).to_i.minutes
      # REDIS.setex(session_key, session_timeout, hashed_value)

      @vault.update(last_accessed_at: Time.current)

      render(
        json: VaultSerializer.new(@vault, include: [:password_records]).serializable_hash,
        status: :ok,
      )
    else
      render(json: { error: "Invalid credentials" }, status: :unauthorized)
    end
  end

  # def logout
  #   session_key = "vault:#{@vault.id}:user:#{current_user.id}"

  #   if REDIS.exists?(session_key)
  #     REDIS.del(session_key)
  #     render(json: { message: "Logout successful" }, status: :ok)
  #   else
  #     render(json: { error: "No active session found" }, status: :unprocessable_entity)
  #   end
  # end

  private

  def vault_params
    params.require(:vault).permit(
      :name,
      :unlock_code,
      :description,
      :vault_type,
      :shared_with,
      :status,
      :is_shared,
    )
  end

  def set_vault
    @vault = current_user.vaults.find_by!(id: params[:id])
  end
end
