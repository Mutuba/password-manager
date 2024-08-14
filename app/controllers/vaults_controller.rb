class VaultsController < ApplicationController
  def create
    @vault = Vault.new(vault_params)
    @vault.set_master_key(params[:master_password])
    
    if @vault.save
      render json: @vault, status: :created 
    else
      render json: { errors: @vault.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def vault_params
    params.require(:vault).permit(:name, :user_id)
  end
end
