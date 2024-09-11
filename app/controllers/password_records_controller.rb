# frozen_string_literal: true

class PasswordRecordsController < ApplicationController
  before_action :set_vault, only: [:index, :create]
  before_action :set_password_record, only: [:show, :update, :destroy]

  def index
  end

  def create
  end

  def update
  end

  def show
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
