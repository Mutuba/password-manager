# frozen_string_literal: true

class PasswordRecordsController < ApplicationController
  before_action :set_vault, only: %i[create update]
  before_action :set_password_record, only: %i[update destroy]
  before_action :validate_vault_password, only: %i[create update]

  def create
    @password_record = @vault.password_records.new(password_record_params)
    @password_record.encryption_key(@vault_password)
    if @password_record.save
      render_serialized_record(@password_record, :created)
    else
      render_errors(@password_record.errors.full_messages, :unprocessable_entity)
    end
  end

  def update
    @password_record.encryption_key(@vault_password)
    if @password_record.update(password_record_params)
      render_serialized_record(@password_record, :ok)
    else
      render_errors(@password_record.errors.full_messages, :unprocessable_entity)
    end
  end

  def destroy
    if @password_record.destroy
      head :no_content
    else
      render_errors(@password_record.errors.full_messages, :unprocessable_entity)
    end
  end

  private

  def set_vault
    @vault = Vault.find(params[:vault_id])
  end

  def set_password_record
    @password_record = PasswordRecord.find(params[:id])
  end

  def password_record_params
    params.require(:password_record).permit(:name, :username, :password)
  end

  def validate_vault_password
    @vault_password = params[:vault_password]
    if @vault_password.blank?
      render_errors(["Vault password is required"], :unprocessable_entity)
    elsif !@vault.authenticate_vault(@vault_password)
      render_errors(["Invalid vault password"], :unauthorized)
    end
  end

  def render_serialized_record(record, status)
    render json: PasswordRecordSerializer.new(record).serializable_hash, status: status
  end

  def render_errors(errors, status)
    render json: { errors: errors }, status: status
  end
end
