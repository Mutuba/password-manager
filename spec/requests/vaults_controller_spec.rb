# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VaultsController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers(user.id) }

  describe '#create' do
    context 'when user is authenticated' do
      before { post vaults_path, params: { vault: { name: 'Iconic vault', master_password: 'Favouritepassword123' } }.to_json, headers: }

      it 'creates a new vault' do
        expect(response).to have_http_status(:created)
        expect(json_response['data']['attributes']['name']).to eq('Iconic vault')
      end
    end

    context 'when user is not authenticated' do
      before { post vaults_path, params: { vault: { name: 'Iconic vault', master_password: 'Favouritepassword123' } }.to_json }
      it 'raises authentication error' do
        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq('Missing authorization header')
      end
    end
  end

  # describe '#login' do
  #   context 'when user is authenticated' do
  #     before do
  #       let(:vaults) {create_list(:vault, 4, user:) }

  #     end
  #   end
  # end
end
