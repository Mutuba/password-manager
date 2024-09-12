# frozen_string_literal: true

class PasswordRecordsController < ApplicationController
  before_action :set_vault, only: [:create]
  before_action :set_password_record, only: [:update, :destroy]

  def create
    @password_record = @vault.password_records.new(password_record_params)
    if @password_record.save
      render(
        json: PasswordRecordSerializer.new(@password_record).serializable_hash, status: :created,
      )
    else
      json_response(
        { errors: @password_record.errors.full_messages }, :unprocessable_entity
      )
    end
  end

  def update
    if @password_record.update(password_record_params)
      render(
        json: PasswordRecordSerializer.new(@password_record).serializable_hash, status: :ok,
      )
    else
      json_response(
        { errors: @password_record.errors.full_messages }, :unprocessable_entity
      )
    end
  end

  def destroy
    @password_record.destroy
    head(:no_content)
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
end
