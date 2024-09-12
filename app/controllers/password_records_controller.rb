# frozen_string_literal: true

class PasswordRecordsController < ApplicationController
  before_action :set_vault, only: [:create]
  before_action :set_password_record, only: [:update, :destroy]

  def create
    @password_record = @vault.password_records.new(password_record_params)
    if @password_record.save
      render(json: PasswordRecordSerializer.new(@password_record).serializable_hash, status: :created)
    else
      render(json: @password_record.errors.full_messages, status: :unprocessable_entity)
    end
  end

  def update
  end

  def destroy
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
