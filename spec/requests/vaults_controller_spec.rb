# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VaultsController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers(user.id) }

  describe '#create' do
    context 'when user is authenticated' do
      before { post vaults_path, params: { vault: { name: 'Iconic vault', master_password: 'Favouritepassword123!' } }.to_json, headers: }

      it 'creates a new vault' do
        expect(response).to have_http_status(:created)
        expect(json_response['data']['attributes']['name']).to eq('Iconic vault')
      end
    end

    context 'when user is not authenticated' do
      before { post vaults_path, params: { vault: { name: 'Iconic vault', master_password: 'Favouritepassword123!' } }.to_json }
      it 'raises authentication error' do
        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq('Missing authorization header')
      end
    end
    context 'when password does not meet the requirements' do
      before { post vaults_path, params: { vault: { name: 'Game of Thrones', master_password: 'tooshort' } }.to_json, headers: }

      it 'raises validation error' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to eq 'Validation failed: Master password must be at least 8 characters long and include letters, numbers, and special characters'
      end
    end
  end

  describe '#login' do
    let(:vault) { build(:vault, user:) }
    let(:valid_password) { 'FavouritePassword123!' }
    let(:headers) { valid_headers(user.id) }
    let(:session_key) { "vault:#{vault.id}:user:#{user.id}" }

    before do
      vault.add_encrypted_master_key(valid_password)
      vault.save!
    end

    context 'when correct password' do
      before do
        allow(REDIS).to receive(:setex)
        post vault_login_path(vault.id), params: { vault: { master_password: 'FavouritePassword123!' } }.to_json, headers:
      end

      it 'logs in' do
        expect(response).to have_http_status(:success)
        expect(json_response['message']).to eq 'Login successful'
        expect(REDIS).to have_received(:setex)
      end
    end

    context 'when wrong password' do
      before do
        post vault_login_path(vault.id), params: { vault: { master_password: 'Password1234' } }.to_json, headers:
      end

      it 'does not login in' do
        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq 'Invalid password'
      end
    end
  end
end
