# frozen_string_literal: true

class PasswordRecordsController < ApplicationController
  before_action :set_vault, only: [:create, :update]
  before_action :set_password_record, only: [:update, :destroy, :decrypt_password]
  before_action :validate_encryption_key, only: [:create, :update, :decrypt_password]

  def create
    @password_record = @vault.password_records.new(password_record_params)
    @password_record.encryption_key(@encryption_key)
    if @password_record.save
      render_serialized_record(@password_record, :created)
    else
      render_errors(@password_record.errors.full_messages, :unprocessable_entity)
    end
  end

  def update
    @password_record.encryption_key(@encryption_key)
    if @password_record.update(password_record_params)
      render_serialized_record(@password_record, :ok)
    else
      render_errors(@password_record.errors.full_messages, :unprocessable_entity)
    end
  end

  def destroy
    @password_record.destroy!
    head :no_content
  rescue ActiveRecord::RecordNotDestroyed => e
    render_errors(e.record.errors.full_messages, :unprocessable_entity)
  end  

  def decrypt_password
    decrypted_password = @password_record.decrypt_password(@encryption_key)
    if decrypted_password
      render(json: { password: decrypted_password }, status: :ok)
    else
      render_errors(["Invalid decryption key or corrupted data"], :unprocessable_entity)
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
    params.require(:password_record).permit(:name, :username, :notes, :url, :password)
  end

  def validate_encryption_key
    @encryption_key = params[:encryption_key]
    if @encryption_key.blank?
      render_errors(["Password record encryption key is required"], :unprocessable_entity)
    end
  end

  def render_serialized_record(record, status)
    render(json: PasswordRecordSerializer.new(record).serializable_hash, status: status)
  end

  def render_errors(errors, status)
    render(json: { errors: errors }, status: status)
  end
end
